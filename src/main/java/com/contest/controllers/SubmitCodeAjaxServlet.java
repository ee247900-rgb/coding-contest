package com.contest.controllers;

import com.contest.services.execution.CodeExecutionService;
import com.contest.services.execution.ExecutionResult;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/submitCodeAjax")
public class SubmitCodeAjaxServlet extends HttpServlet {
    private CodeExecutionService executionService;
    private Gson gson;

    @Override public void init() { executionService = new CodeExecutionService(); gson = new Gson(); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String language = request.getParameter("language");
        String sourceCode = request.getParameter("sourceCode");
        boolean submit = "submit".equals(request.getParameter("action"));
        ExecutionResult result = new ExecutionResult();
        int id;
        try { id = Integer.parseInt(request.getParameter("problemId")); } catch (Exception ex) { id = -1; }

        HttpSession session = request.getSession();
        String contestCode = (String) session.getAttribute("currentContestCode");
        boolean assigned = false;
        if (contestCode != null) {
            for (Map<String,Object> problem : com.contest.data.ContestDatabase.problems(contestCode)) {
                if (((Number)problem.get("id")).intValue() == id) assigned = true;
            }
        }
        if (!assigned && com.contest.data.ProblemDatabase.getProblem(id) != null) {
            assigned = true;
        }

        List<Map<String,String>> cases = assigned ? com.contest.data.ProblemDatabase.getTestCases(id) : Collections.<Map<String,String>>emptyList();

        if (!assigned) {
            result.setStatus("PROBLEM_NOT_FOUND"); result.setMessage("Problem invalid or not found.");
        } else if (sourceCode == null || sourceCode.trim().isEmpty()) {
            result.setStatus("EMPTY_SOLUTION"); result.setMessage("Write a solution before running it.");
        } else if (cases.isEmpty()) {
            result.setStatus("NO_TEST_CASES"); result.setMessage("This problem has no test cases yet. Add test cases in Admin panel.");
        } else if (!submit) {
            runSelectedCase(request, language, sourceCode, cases, result);
        } else {
            runSubmission(language, sourceCode, cases, result);
            rememberSubmission(session, id, language, sourceCode, result);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(result));
    }

    private void runSelectedCase(HttpServletRequest request, String language, String sourceCode,
            List<Map<String,String>> cases, ExecutionResult result) {
        int selected;
        try { selected = Integer.parseInt(request.getParameter("testCaseIndex")); }
        catch (Exception ex) { selected = firstVisible(cases); }
        if (selected == -1) {
            String input = request.getParameter("testInput");
            String expected = request.getParameter("customExpectedOutput");
            ExecutionResult run = executionService.execute(language, sourceCode, input, expected);
            copyExecution(run, result); result.setTotalTestCases(1);
            result.setTestCaseInput(input); result.setExpectedOutput(expected); result.setActualOutput(run.getMessage());
            if ("ACCEPTED".equals(run.getStatus())) { result.setPassedTestCases(1); result.setMessage("Your custom case passed."); }
            else {
                result.setFailedTestCase(cases.size() + 1);
                result.setMessage("Your custom test case failed: " + run.getStatus().replace('_', ' ') + ".");
            }
            return;
        }
        if (selected < 0 || selected >= cases.size() || Boolean.parseBoolean(cases.get(selected).get("hidden"))) {
            result.setStatus("INVALID_TEST_CASE"); result.setMessage("Select one of the visible sample cases to run."); return;
        }
        Map<String,String> test = cases.get(selected);
        String input = request.getParameter("testInput");
        if (input == null) input = test.get("input");
        ExecutionResult run = executionService.execute(language, sourceCode, input, test.get("output"));
        copyExecution(run, result);
        result.setTotalTestCases(1);
        result.setTestCaseInput(input); result.setExpectedOutput(test.get("output")); result.setActualOutput(run.getMessage());
        if ("ACCEPTED".equals(run.getStatus())) {
            result.setPassedTestCases(1);
            result.setMessage("Sample case " + (selected + 1) + " passed.");
        } else {
            result.setFailedTestCase(selected + 1);
            result.setMessage("Failed on sample case " + (selected + 1) + ".");
        }
    }

    private void runSubmission(String language, String sourceCode, List<Map<String,String>> cases, ExecutionResult result) {
        result.setTotalTestCases(cases.size());
        long totalTime = 0, maxMemory = 0;
        for (int i=0; i<cases.size(); i++) {
            Map<String,String> test = cases.get(i);
            ExecutionResult run = executionService.execute(language, sourceCode, test.get("input"), test.get("output"));
            totalTime += run.getExecutionTimeMs(); maxMemory = Math.max(maxMemory, run.getMemoryUsedMb());
            if (!"ACCEPTED".equals(run.getStatus())) {
                copyExecution(run, result);
                result.setExecutionTimeMs(totalTime); result.setMemoryUsedMb(maxMemory);
                result.setFailedTestCase(i + 1);
                boolean hidden = Boolean.parseBoolean(test.get("hidden"));
                result.setHiddenFailure(hidden);
                result.setMessage((hidden ? "Hidden test case #" : "Test case #") + (i + 1) + " failed: " + run.getStatus().replace('_', ' ') + ".");
                if (!hidden) {
                    result.setTestCaseInput(test.get("input"));
                    result.setExpectedOutput(test.get("output"));
                    result.setActualOutput(run.getMessage());
                }
                return;
            }
            result.setPassedTestCases(i + 1);
        }
        result.setStatus("ACCEPTED"); result.setExecutionTimeMs(totalTime); result.setMemoryUsedMb(maxMemory);
        result.setMessage("All " + cases.size() + " test cases passed.");
    }

    private int firstVisible(List<Map<String,String>> cases) {
        for (int i=0; i<cases.size(); i++) if (!Boolean.parseBoolean(cases.get(i).get("hidden"))) return i;
        return -1;
    }
    private void copyExecution(ExecutionResult from, ExecutionResult to) {
        to.setStatus(from.getStatus()); to.setMessage(from.getMessage());
        to.setExecutionTimeMs(from.getExecutionTimeMs()); to.setMemoryUsedMb(from.getMemoryUsedMb());
    }
    @SuppressWarnings("unchecked")
    private void rememberSubmission(HttpSession session, int id, String language, String sourceCode, ExecutionResult result) {
        List<Map<String,Object>> history = (List<Map<String,Object>>)session.getAttribute("submissionHistory");
        if (history == null) history = new ArrayList<Map<String,Object>>();
        Map<String,Object> row = new LinkedHashMap<String,Object>();
        Map<String,Object> problem = com.contest.data.ProblemDatabase.getProblem(id);
        row.put("problemId", id);
        row.put("problem", problem == null ? "Problem #" + id : problem.get("title"));
        row.put("language", language);
        row.put("sourceCode", sourceCode);
        row.put("status", result.getStatus());
        row.put("message", result.getMessage());
        row.put("executionTimeMs", result.getExecutionTimeMs());
        row.put("memoryUsedMb", result.getMemoryUsedMb());
        row.put("passedTestCases", result.getPassedTestCases());
        row.put("totalTestCases", result.getTotalTestCases());
        row.put("failedTestCase", result.getFailedTestCase());
        row.put("submittedAt", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        history.add(0, row);
        session.setAttribute("submissionHistory", history);

        // Also track solved set in session
        Set<Integer> solvedSet = (Set<Integer>) session.getAttribute("solvedProblems");
        if (solvedSet == null) solvedSet = new HashSet<Integer>();
        if ("ACCEPTED".equals(result.getStatus())) {
            solvedSet.add(id);
        }
        session.setAttribute("solvedProblems", solvedSet);
    }
}

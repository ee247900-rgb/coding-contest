package com.contest.controllers;

import com.contest.services.execution.CodeExecutionService;
import com.contest.services.execution.ExecutionResult;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/submitCode")
public class SubmitCodeServlet extends HttpServlet {

    private CodeExecutionService executionService;

    @Override
    public void init() throws ServletException {
        // Initialize the execution service once
        executionService = new CodeExecutionService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String problemId = request.getParameter("problemId");
        String language = request.getParameter("language");
        String sourceCode = request.getParameter("sourceCode");
        
        // In a real application, you would fetch the problem's test cases from the DB here
        String testInput = "2 7 11 15\n9";
        String expectedOutput = "0 1";

        // Execute the code using our multi-language service
        ExecutionResult result = executionService.execute(language, sourceCode, testInput, expectedOutput);

        // Update database with submission history here (JDBC)
        // e.g. updateSubmissionsTable(userId, problemId, language, result, sourceCode);

        // Set attributes for the result page
        request.setAttribute("problemId", problemId);
        request.setAttribute("language", language);
        request.setAttribute("status", result.getStatus());
        request.setAttribute("executionTime", result.getExecutionTimeMs());
        request.setAttribute("memoryUsed", result.getMemoryUsedMb());
        request.setAttribute("points", result.getStatus().equals("ACCEPTED") ? 10 : 0);

        // Forward to a result JSP
        request.getRequestDispatcher("/user/submission-result.jsp").forward(request, response);
    }
}

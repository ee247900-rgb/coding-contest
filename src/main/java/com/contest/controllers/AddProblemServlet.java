package com.contest.controllers;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@WebServlet("/addProblem")
public class AddProblemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String difficulty = request.getParameter("difficulty");
        String points = request.getParameter("points");
        String testCases = request.getParameter("testCases");
        String inputFormat = request.getParameter("inputFormat");
        String outputFormat = request.getParameter("outputFormat");
        String constraints = request.getParameter("constraints");
        String category = request.getParameter("category");

        if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Title and Description are required.");
            request.getRequestDispatcher("/admin/add-problem.jsp").forward(request, response);
            return;
        }

        try {
            int score = Integer.parseInt(points);
            if (score < 1 || score > 10000) throw new IllegalArgumentException("Points must be between 1 and 10000.");
            if (!"Easy".equals(difficulty) && !"Medium".equals(difficulty) && !"Hard".equals(difficulty)) throw new IllegalArgumentException("Choose a valid difficulty.");
            List<Map<String,String>> cases = new Gson().fromJson(testCases, new TypeToken<List<Map<String,String>>>(){}.getType());
            if (cases == null || cases.isEmpty()) throw new IllegalArgumentException("Add at least one test case as JSON.");
            List<Map<String,String>> normalized = new ArrayList<Map<String,String>>();
            for (Map<String,String> test : cases) {
                if (test.get("input") == null || test.get("output") == null) throw new IllegalArgumentException("Each test case needs input and output values.");
                normalized.add(com.contest.data.ProblemDatabase.test(test.get("input"), test.get("output"), Boolean.parseBoolean(test.get("hidden"))));
            }
            int id = com.contest.data.ProblemDatabase.addProblem(title.trim(), description.trim(), inputFormat, outputFormat,
                    constraints, difficulty, String.valueOf(score), category, normalized);
            request.setAttribute("successMsg", "Problem '" + title + "' added successfully!");
            request.setAttribute("createdProblemId", id);
            request.getRequestDispatcher("/admin/add-problem.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMsg", "Failed to add problem: " + e.getMessage());
            request.getRequestDispatcher("/admin/add-problem.jsp").forward(request, response);
        }
    }
}

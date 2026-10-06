package com.contest.controllers;

import com.contest.services.importer.ImportService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.Map;

@WebServlet("/importProblem")
public class ImportProblemServlet extends HttpServlet {

    private ImportService importService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        importService = new ImportService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String source = request.getParameter("source");
        String sourceUrlsStr = request.getParameter("sourceUrls");

        if (sourceUrlsStr == null || sourceUrlsStr.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Please provide at least one valid Problem Source URL.");
            request.getRequestDispatcher("/admin/import-problem.jsp").forward(request, response);
            return;
        }

        String[] urls = sourceUrlsStr.split("\\r?\\n");
        java.util.List<Map<String, Object>> importedList = new java.util.ArrayList<>();

        try {
            for (String sourceUrl : urls) {
                if (sourceUrl == null || sourceUrl.trim().isEmpty()) continue;
                
                Map<String, Object> problemData = new java.util.HashMap<>();
                String title = "Unknown Problem";
                if (sourceUrl.contains("leetcode.com/problems/")) {
                    String[] parts = sourceUrl.split("/problems/");
                    if (parts.length > 1) {
                        String slug = parts[1].replace("/", "");
                        String[] words = slug.split("-");
                        StringBuilder titleBuilder = new StringBuilder();
                        for (String w : words) {
                            if (w.length() > 0) {
                                titleBuilder.append(Character.toUpperCase(w.charAt(0))).append(w.substring(1)).append(" ");
                            }
                        }
                        title = titleBuilder.toString().trim();
                    }
                } else if (sourceUrl.contains("hackerrank.com/challenges/")) {
                    String[] parts = sourceUrl.split("/challenges/");
                    if (parts.length > 1) {
                        String slug = parts[1].split("/")[0].replace("/", "");
                        String[] words = slug.split("-");
                        StringBuilder titleBuilder = new StringBuilder();
                        for (String w : words) {
                            if (w.length() > 0) {
                                titleBuilder.append(Character.toUpperCase(w.charAt(0))).append(w.substring(1)).append(" ");
                            }
                        }
                        title = titleBuilder.toString().trim();
                    }
                } else {
                    title = "Imported Custom Problem";
                }
                
                problemData.put("title", title);
                problemData.put("source", source);
                problemData.put("sourceUrl", sourceUrl);

                boolean isValid = importService.validateData(problemData);
                if (isValid) {
                    boolean saved = importService.importToDatabase(problemData);
                    if (saved) {
                        importedList.add(problemData);
                    }
                }
            }
            
            request.setAttribute("importedCount", importedList.size());
            request.setAttribute("importedList", importedList);
            request.getRequestDispatcher("/admin/preview-import.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error processing URLs: " + e.getMessage());
        }
    }
}

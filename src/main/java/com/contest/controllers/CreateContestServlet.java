package com.contest.controllers;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/createContest")
public class CreateContestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String contestCode = request.getParameter("contestCode");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");
        String duration = request.getParameter("duration");
        String[] selectedProblems = request.getParameterValues("problemIds");

        if (title == null || title.trim().isEmpty() || contestCode == null || contestCode.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Title and Contest Code are required.");
            request.getRequestDispatcher("/admin/create-contest.jsp").forward(request, response);
            return;
        }

        try {
            if (startTime == null || endTime == null || duration == null || Integer.parseInt(duration) < 1 ||
                    java.time.LocalDateTime.parse(endTime).isBefore(java.time.LocalDateTime.parse(startTime))) {
                throw new IllegalArgumentException("Choose a valid schedule and a duration greater than zero.");
            }
            if (com.contest.data.ContestDatabase.find(contestCode) != null) throw new IllegalArgumentException("That invite code is already in use.");
            if (selectedProblems == null || selectedProblems.length == 0) throw new IllegalArgumentException("Select at least one problem for this contest.");
            int[] ids = new int[selectedProblems.length];
            for (int i=0; i<selectedProblems.length; i++) {
                ids[i] = Integer.parseInt(selectedProblems[i]);
                if (com.contest.data.ProblemDatabase.getProblem(ids[i]) == null) throw new IllegalArgumentException("A selected problem no longer exists. Refresh and try again.");
            }
            com.contest.data.ContestDatabase.add(title.trim(), contestCode.trim(), startTime, endTime, Integer.parseInt(duration), ids);
            request.setAttribute("successMsg", "Contest '" + title + "' created successfully! Users can join using code: " + contestCode);
            request.getRequestDispatcher("/admin/create-contest.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMsg", "Failed to create contest: " + e.getMessage());
            request.getRequestDispatcher("/admin/create-contest.jsp").forward(request, response);
        }
    }
}

package com.contest.controllers;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/joinContest")
public class JoinContestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processJoin(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processJoin(request, response);
    }

    private void processJoin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String contestCode = request.getParameter("contestCode");
        if (contestCode == null || contestCode.trim().isEmpty()) {
            contestCode = request.getParameter("code");
        }
        
        String name = request.getParameter("displayName");
        if (name == null || name.trim().isEmpty()) {
            name = request.getParameter("name");
        }

        // Validate that both Name AND Contest Code are supplied
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Mandatory step: You must enter your name to attend the contest.");
            request.getRequestDispatcher("/user/join-contest.jsp").forward(request, response);
            return;
        }

        if (contestCode == null || contestCode.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Mandatory step: You must enter a valid contest code to attend.");
            request.getRequestDispatcher("/user/join-contest.jsp").forward(request, response);
            return;
        }

        java.util.Map<String, Object> contest = com.contest.data.ContestDatabase.find(contestCode);
        if (contest != null) {
            request.getSession().setAttribute("currentContestCode", contest.get("code"));
            request.getSession().setAttribute("currentContestTitle", contest.get("title"));
            request.getSession().setAttribute("displayName", name.trim());
            response.sendRedirect(request.getContextPath() + "/user/contest-dashboard.jsp");
        } else {
            request.setAttribute("errorMsg", "Invalid contest code '" + contestCode + "'. Please check the code and try again.");
            request.getRequestDispatcher("/user/join-contest.jsp").forward(request, response);
        }
    }
}

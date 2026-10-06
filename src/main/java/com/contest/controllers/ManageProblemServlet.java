package com.contest.controllers;

import com.contest.data.ProblemDatabase;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet("/manageProblem")
public class ManageProblemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action=request.getParameter("action");
        int id;
        try { id=Integer.parseInt(request.getParameter("id")); }
        catch(Exception e) { response.sendError(HttpServletResponse.SC_BAD_REQUEST,"Invalid problem id"); return; }
        if ("delete".equals(action)) {
            if (!ProblemDatabase.deleteProblem(id)) { response.sendError(HttpServletResponse.SC_NOT_FOUND,"Problem not found"); return; }
            com.contest.data.ContestDatabase.removeProblem(id);
            response.sendRedirect(request.getContextPath()+"/admin/manage-problems.jsp?deleted=1");
            return;
        }
        if (!"save".equals(action)) { response.sendError(HttpServletResponse.SC_BAD_REQUEST,"Unknown action"); return; }
        try {
            String title=required(request,"title"), description=required(request,"description");
            String difficulty=required(request,"difficulty");
            if (!Arrays.asList("Easy","Medium","Hard").contains(difficulty)) throw new IllegalArgumentException("Choose a valid difficulty.");
            int points=Integer.parseInt(required(request,"points"));
            if(points<1||points>10000) throw new IllegalArgumentException("Points must be between 1 and 10000.");
            List<Map<String,String>> cases=new Gson().fromJson(required(request,"testCases"),new TypeToken<List<Map<String,String>>>(){}.getType());
            if(cases==null||cases.isEmpty()) throw new IllegalArgumentException("Add at least one test case.");
            List<Map<String,String>> normalized=new ArrayList<Map<String,String>>();
            for(Map<String,String> test:cases){
                if(test==null||test.get("input")==null||test.get("output")==null) throw new IllegalArgumentException("Each test case needs input and output fields.");
                normalized.add(ProblemDatabase.test(test.get("input"),test.get("output"),Boolean.parseBoolean(test.get("hidden"))));
            }
            boolean updated=ProblemDatabase.updateProblem(id,title,description,request.getParameter("inputFormat"),request.getParameter("outputFormat"),request.getParameter("constraints"),difficulty,String.valueOf(points),request.getParameter("category"),normalized);
            if(!updated){response.sendError(HttpServletResponse.SC_NOT_FOUND,"Problem not found");return;}
            response.sendRedirect(request.getContextPath()+"/admin/manage-problems.jsp?saved=1");
        } catch(Exception e) {
            request.setAttribute("errorMsg",e instanceof IllegalArgumentException?e.getMessage():"Could not save this problem. Check the points and test case JSON.");
            request.getRequestDispatcher("/admin/edit-problem.jsp?id="+id).forward(request,response);
        }
    }
    private String required(HttpServletRequest request,String key){String value=request.getParameter(key);if(value==null||value.trim().isEmpty())throw new IllegalArgumentException("The "+key+" field is required.");return value.trim();}
}

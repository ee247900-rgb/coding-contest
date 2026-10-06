<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Sidebar -->
<div class="bg-dark text-white p-3" style="width: 250px; min-height: 100vh;">
    <h4>Admin Dashboard</h4>
    <ul class="nav flex-column mt-4">
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("dashboard.jsp") ? "bg-secondary" : "" %>">Dashboard</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/create-contest.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("create-contest.jsp") ? "bg-secondary" : "" %>">Create Contest</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/manage-contests.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("manage-contests.jsp") ? "bg-secondary" : "" %>">Manage Contests</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/add-problem.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("add-problem.jsp") ? "bg-secondary" : "" %>">Add Problem</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/import-problem.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("import-problem.jsp") ? "bg-secondary" : "" %>">Import Problems</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/manage-problems.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("manage-problems.jsp") ? "bg-secondary" : "" %>">Manage Problems</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/test-cases.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("test-cases.jsp") ? "bg-secondary" : "" %>">Test Cases</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/participants.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("participants.jsp") ? "bg-secondary" : "" %>">Participants</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/submissions.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("submissions.jsp") ? "bg-secondary" : "" %>">Submissions</a></li>
        <li class="nav-item"><a href="<%= request.getContextPath() %>/admin/leaderboard.jsp" class="nav-link text-white <%= request.getRequestURI().endsWith("leaderboard.jsp") ? "bg-secondary" : "" %>">Leaderboard</a></li>
        <li class="nav-item mt-4"><a href="<%= request.getContextPath() %>/index.jsp" class="nav-link text-danger">Logout</a></li>
    </ul>
</div>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <jsp:include page="sidebar.jsp" />
        <div class="flex-grow-1 p-5">
            <h2>Dashboard</h2>
            <hr>
            <div class="row">
                <div class="col-md-3 mb-4">
                    <div class="card text-white bg-primary shadow">
                        <div class="card-body">
                            <h5 class="card-title">Total Contests</h5>
                            <h2 class="mb-0"><%= com.contest.data.ContestDatabase.all().size() %></h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-white bg-success shadow">
                        <div class="card-body">
                            <h5 class="card-title">Total Problems</h5>
                            <h2 class="mb-0"><%= com.contest.data.ProblemDatabase.getAllProblems().size() %></h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-white bg-warning shadow">
                        <div class="card-body">
                            <h5 class="card-title">Active Users</h5>
                            <h2 class="mb-0">—</h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card text-white bg-danger shadow">
                        <div class="card-body">
                            <h5 class="card-title">Submissions</h5>
                            <h2 class="mb-0">—</h2>
                        </div>
                    </div>
                </div>
            </div>
            
            <h4 class="mt-4">Recent Activity</h4>
            <div class="alert alert-info mt-4">Create a contest and share its invite code. This starter edition keeps contests in memory while the server is running.</div>
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/admin/create-contest.jsp">Create your first contest</a>
    </div>
</body>
</html>

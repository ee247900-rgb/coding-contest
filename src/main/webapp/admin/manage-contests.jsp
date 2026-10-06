<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Contests - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <jsp:include page="sidebar.jsp" />
        <div class="flex-grow-1 p-5">
            <h2>Manage Contests</h2>
            <hr>
            <div class="d-flex justify-content-between mb-3">
                <input type="text" class="form-control w-25" placeholder="Search contests...">
                <a href="create-contest.jsp" class="btn btn-primary">Create New Contest</a>
            </div>
            
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Contest Code</th>
                                <th>Title</th>
                                <th>Start Time</th>
                                <th>Duration</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (java.util.Map<String,Object> contest : com.contest.data.ContestDatabase.all()) { %>
                            <tr>
                                <td><span class="font-monospace fw-bold"><%= contest.get("code") %></span></td>
                                <td><%= contest.get("title") %></td>
                                <td><%= contest.get("start") %></td>
                                <td><%= contest.get("duration") %> mins</td>
                                <td><span class="badge bg-success">Ready to join</span></td>
                                <td><a class="btn btn-sm btn-outline-primary" href="<%= request.getContextPath() %>/user/join-contest.jsp">Preview join</a></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

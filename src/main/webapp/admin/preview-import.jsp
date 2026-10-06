<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Preview Problem</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5 w-50">
        <div class="card shadow">
            <div class="card-header bg-dark text-white">
                <h4 class="mb-0">IMPORT PREVIEW</h4>
            </div>
            <div class="card-body">
                <div class="alert alert-success">
                    Successfully imported <%= request.getAttribute("importedCount") %> problem(s)!
                </div>
                
                <table class="table table-bordered table-striped mt-3">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Title</th>
                            <th>Source</th>
                            <th>Difficulty</th>
                            <th>Points</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            java.util.List<java.util.Map<String, Object>> importedList = 
                                (java.util.List<java.util.Map<String, Object>>) request.getAttribute("importedList");
                            if (importedList != null) {
                                int i = 1;
                                for (java.util.Map<String, Object> problem : importedList) {
                        %>
                        <tr>
                            <td><%= i++ %></td>
                            <td><%= problem.get("title") %></td>
                            <td><%= problem.get("source") %></td>
                            <td><%= problem.get("difficulty") %></td>
                            <td><%= problem.get("points") %></td>
                        </tr>
                        <% 
                                }
                            }
                        %>
                    </tbody>
                </table>
                
                <div class="text-center mt-4">
                    <a href="<%= request.getContextPath() %>/admin/manage-problems.jsp" class="btn btn-primary">Go to Manage Problems</a>
                    <a href="<%= request.getContextPath() %>/admin/import-problem.jsp" class="btn btn-outline-secondary ms-2">Import More</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

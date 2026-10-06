<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Submission Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5 w-50">
        <div class="card shadow">
            <div class="card-header bg-dark text-white text-center">
                <h4 class="mb-0">SUBMISSION RESULT</h4>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between">
                        <strong>Problem:</strong> <span>Two Sum (ID: <%= request.getAttribute("problemId") %>)</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <strong>Language:</strong> <span><%= request.getAttribute("language") %></span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <strong>Status:</strong> 
                        <span class="fw-bold text-<%= "ACCEPTED".equals(request.getAttribute("status")) ? "success" : "danger" %>">
                            <%= "ACCEPTED".equals(request.getAttribute("status")) ? "✓ " : "✗ " %><%= request.getAttribute("status") %>
                        </span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <strong>Test Cases:</strong> <span>10 / 10 Passed</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <strong>Execution Time:</strong> <span><%= request.getAttribute("executionTime") %> ms</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <strong>Memory:</strong> <span><%= request.getAttribute("memoryUsed") %> MB</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between bg-light mt-3">
                        <strong class="fs-5">Points:</strong> <span class="fs-5 fw-bold text-primary"><%= request.getAttribute("points") %></span>
                    </li>
                </ul>
                <div class="text-center mt-4">
                    <a href="coding-page.jsp" class="btn btn-outline-secondary">Back to Problem</a>
                    <a href="leaderboard.jsp" class="btn btn-primary">View Leaderboard</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

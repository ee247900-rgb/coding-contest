<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Contest - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <jsp:include page="sidebar.jsp" />
        <div class="flex-grow-1 p-5">
            <h2>Create Contest</h2>
            <hr>
            
            <% if (request.getAttribute("successMsg") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("successMsg") %></div>
            <% } %>
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("errorMsg") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/createContest" method="post" class="w-75">
                <div class="mb-3">
                    <label class="form-label">Contest Title</label>
                    <input type="text" class="form-control" name="title" required placeholder="e.g., Weekly Coding Challenge 1">
                </div>
                
                <div class="mb-3">
                    <label class="form-label">Contest Code (Users will use this to join)</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="contestCode" name="contestCode" required>
                        <button class="btn btn-outline-secondary" type="button" onclick="generateCode()">Generate Random Code</button>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Start Time</label>
                        <input type="datetime-local" class="form-control" name="startTime" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">End Time</label>
                        <input type="datetime-local" class="form-control" name="endTime" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Duration (Minutes)</label>
                        <input type="number" class="form-control" name="duration" required value="120">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Problems in this contest</label>
                    <p class="text-muted small">Choose the questions participants will see after joining.</p>
                    <div class="border rounded p-3 bg-light">
                        <% for (java.util.Map<String,Object> problem : com.contest.data.ProblemDatabase.getAllProblems()) { %>
                        <label class="d-flex align-items-center gap-2 py-2 border-bottom">
                            <input type="checkbox" name="problemIds" value="<%= problem.get("id") %>" checked>
                            <span><strong><%= problem.get("title") %></strong> <span class="text-muted">· <%= problem.get("difficulty") %> · <%= problem.get("points") %> pts</span></span>
                        </label>
                        <% } %>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Create Contest</button>
            </form>
        </div>
    </div>
    <script>
        function generateCode() {
            const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            let result = '';
            for (let i = 0; i < 8; i++) {
                result += characters.charAt(Math.floor(Math.random() * characters.length));
            }
            document.getElementById('contestCode').value = result;
        }
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Problems - Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <jsp:include page="sidebar.jsp" />

        <!-- Main Content -->
        <div class="flex-grow-1 p-5">
            <h2>Add New Problem</h2>
            <hr>
            
            <% if (request.getAttribute("successMsg") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("successMsg") %> It is now available to select when creating a contest. <a href="<%= request.getContextPath() %>/admin/create-contest.jsp">Create a contest →</a></div>
            <% } %>
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("errorMsg") %></div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/addProblem" method="post" class="w-75">
                <div class="mb-3">
                    <label class="form-label">Problem Title</label>
                    <input type="text" class="form-control" name="title" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea class="form-control" name="description" rows="4" required></textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3"><label class="form-label">Category</label><input class="form-control" name="category" placeholder="Arrays, strings, graphs…"></div>
                    <div class="col-md-6 mb-3"><label class="form-label">Input format</label><textarea class="form-control" name="inputFormat" rows="2" placeholder="Describe how input is provided"></textarea></div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3"><label class="form-label">Output format</label><textarea class="form-control" name="outputFormat" rows="2" placeholder="Describe the expected output"></textarea></div>
                    <div class="col-md-6 mb-3"><label class="form-label">Constraints</label><textarea class="form-control" name="constraints" rows="2" placeholder="Input limits and edge cases"></textarea></div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Difficulty</label>
                        <select class="form-select" name="difficulty">
                            <option value="Easy">Easy</option>
                            <option value="Medium">Medium</option>
                            <option value="Hard">Hard</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Points</label>
                        <input type="number" class="form-control" name="points" value="10">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Test Cases (JSON format)</label>
                    <textarea class="form-control font-monospace" name="testCases" rows="6" required placeholder='[{"input":"2 7 11 15\n9","output":"0 1","hidden":false},{"input":"3 2 4\n6","output":"1 2","hidden":true}]'>[{"input":"","output":"","hidden":false}]</textarea>
                    <div class="form-text">Each case is tested by running the participant’s program with this input and comparing stdout with output. Set hidden to true to hide it from the statement.</div>
                </div>

                <button type="submit" class="btn btn-success">Save Problem</button>
                <button type="reset" class="btn btn-secondary">Clear</button>
            </form>
        </div>
    </div>
</body>
</html>

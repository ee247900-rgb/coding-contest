<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Import Problem - Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <jsp:include page="sidebar.jsp" />

        <!-- Main Content -->
        <div class="flex-grow-1 p-5">
            <h2>Import Problem</h2>
            <hr>
            
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("errorMsg") %></div>
            <% } %>
            
            <form action="<%= request.getContextPath() %>/importProblem" method="post" class="w-50">
                
                <div class="mb-3">
                    <label class="form-label">Select Source</label>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="source" id="sourceLeetCode" value="LeetCode" checked>
                        <label class="form-check-label" for="sourceLeetCode">LeetCode</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="source" id="sourceHackerRank" value="HackerRank">
                        <label class="form-check-label" for="sourceHackerRank">HackerRank</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="source" id="sourceCustom" value="Other">
                        <label class="form-check-label" for="sourceCustom">Other / Custom</label>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Problem Source URLs (One URL per line for bulk import):</label>
                    <textarea class="form-control" name="sourceUrls" rows="6" placeholder="https://leetcode.com/problems/two-sum&#10;https://leetcode.com/problems/add-two-numbers"></textarea>
                </div>

                <button type="submit" class="btn btn-primary">Fetch & Import Problems</button>
            </form>
        </div>
    </div>
</body>
</html>

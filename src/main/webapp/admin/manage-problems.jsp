<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
private String escSearch(String s){if(s==null)return "";return s.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;").replace("'","&#39;");}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Problems - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex">
        <jsp:include page="sidebar.jsp" />
        <div class="flex-grow-1 p-5">
            <h2>Manage Problems</h2>
            <hr>
            <% if ("1".equals(request.getParameter("saved"))) { %><div class="alert alert-success">Problem updated successfully.</div><% } %>
            <% if ("1".equals(request.getParameter("deleted"))) { %><div class="alert alert-success">Problem deleted and removed from its contests.</div><% } %>
            <div class="d-flex justify-content-between mb-3">
                <input id="problemSearch" type="search" class="form-control w-25" placeholder="Search problems..." aria-label="Search problems">
                <div>
                    <a href="add-problem.jsp" class="btn btn-primary">Add New Problem</a>
                    <a href="import-problem.jsp" class="btn btn-outline-secondary">Import Problems</a>
                </div>
            </div>
            
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Difficulty</th>
                                <th>Points</th>
                                <th>Source</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                java.util.List<java.util.Map<String, Object>> allProblems = 
                                    com.contest.data.ProblemDatabase.getAllProblems();
                                for(java.util.Map<String, Object> p : allProblems) {
                                    String diffBadge = "bg-success";
                                    if("Medium".equalsIgnoreCase(String.valueOf(p.get("difficulty")))) diffBadge = "bg-warning text-dark";
                                    if("Hard".equalsIgnoreCase(String.valueOf(p.get("difficulty")))) diffBadge = "bg-danger";
                            %>
                            <tr class="problem-record" data-search="<%= escSearch(String.valueOf(p.get("title")).toLowerCase()) %> <%= p.get("id") %> <%= escSearch(String.valueOf(p.get("difficulty")).toLowerCase()) %> <%= escSearch(String.valueOf(p.get("source")).toLowerCase()) %>">
                                <td><%= p.get("id") %></td>
                                <td><%= p.get("title") %></td>
                                <td><span class="badge <%= diffBadge %>"><%= p.get("difficulty") %></span></td>
                                <td><%= p.get("points") %></td>
                                <td><%= p.get("source") %></td>
                                <td>
                                    <a class="btn btn-sm btn-outline-primary" href="<%= request.getContextPath() %>/admin/edit-problem.jsp?id=<%= p.get("id") %>">Edit</a>
                                    <form class="d-inline" action="<%= request.getContextPath() %>/manageProblem" method="post" onsubmit="return confirm('Delete this problem? It will also be removed from contests that use it.');">
                                        <input type="hidden" name="id" value="<%= p.get("id") %>"><input type="hidden" name="action" value="delete">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
<script>document.getElementById('problemSearch').addEventListener('input',function(){const q=this.value.trim().toLowerCase();document.querySelectorAll('.problem-record').forEach(row=>row.hidden=!row.dataset.search.includes(q));});</script>
</html>

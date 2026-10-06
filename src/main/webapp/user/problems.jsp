<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
String ctx = request.getContextPath();
List<Map<String, Object>> allProblems = com.contest.data.ProblemDatabase.getAllProblems();

Set<Integer> solvedSet = (Set<Integer>) session.getAttribute("solvedProblems");
if (solvedSet == null) solvedSet = new HashSet<Integer>();

int totalEasy = 0, totalMedium = 0, totalHard = 0;
int solvedEasy = 0, solvedMedium = 0, solvedHard = 0;

Set<String> categories = new TreeSet<String>();
StringBuilder idSb = new StringBuilder();

for (int i = 0; i < allProblems.size(); i++) {
    Map<String, Object> p = allProblems.get(i);
    String diff = String.valueOf(p.get("difficulty"));
    String cat = String.valueOf(p.get("category"));
    if (cat != null) categories.add(cat);
    int id = ((Number) p.get("id")).intValue();
    boolean isSolved = solvedSet.contains(id);

    idSb.append(id);
    if (i < allProblems.size() - 1) idSb.append(",");

    if ("Easy".equalsIgnoreCase(diff)) {
        totalEasy++;
        if (isSolved) solvedEasy++;
    } else if ("Medium".equalsIgnoreCase(diff)) {
        totalMedium++;
        if (isSolved) solvedMedium++;
    } else if ("Hard".equalsIgnoreCase(diff)) {
        totalHard++;
        if (isSolved) solvedHard++;
    }
}
String idListJson = idSb.toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Problems Catalog — LeetCode Clone | CodeArena</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@400;500&family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="<%=ctx%>/assets/site.css" rel="stylesheet">
    <style>
        body { background: #181917; color: #ecede9; font-family: 'DM Sans', sans-serif; margin: 0; min-height: 100vh; }
        .topbar { background: #111210; border-bottom: 1px solid #2e2f2b; padding: 0 24px; height: 56px; display: flex; align-items: center; justify-content: space-between; }
        .brand { font-weight: 800; font-size: 18px; color: #fff; text-decoration: none; display: flex; align-items: center; gap: 6px; }
        .brand-mark { color: #aee56e; font-family: 'DM Mono', monospace; }
        .nav-links { display: flex; gap: 20px; font-size: 13px; }
        .nav-links a { color: #aaa; text-decoration: none; font-weight: 500; }
        .nav-links a.active, .nav-links a:hover { color: #fff; }
        .top-right { display: flex; align-items: center; gap: 14px; }
        .btn-rand { background: #2b2c28; color: #aee56e; border: 1px solid #3e403a; border-radius: 6px; padding: 7px 14px; font-size: 12px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 6px; }
        .btn-rand:hover { background: #353731; border-color: #aee56e; }

        .container { max-width: 1100px; margin: 36px auto 60px; padding: 0 20px; }
        
        .hero-stats { display: grid; grid-template-columns: 1fr 2fr; gap: 20px; margin-bottom: 30px; background: #21221e; border: 1px solid #32342f; border-radius: 12px; padding: 24px; }
        .stat-main { display: flex; flex-direction: column; justify-content: center; border-right: 1px solid #32342f; padding-right: 24px; }
        .stat-main h1 { font-size: 28px; margin: 0 0 6px; font-weight: 800; letter-spacing: -0.5px; }
        .stat-main p { margin: 0; color: #9c9e96; font-size: 13px; }
        
        .stat-bars { display: flex; flex-direction: column; justify-content: center; gap: 12px; }
        .diff-bar-row { display: grid; grid-template-columns: 70px 1fr 60px; align-items: center; gap: 12px; font-size: 12px; font-family: 'DM Mono', monospace; }
        .diff-name { font-weight: 600; }
        .diff-easy { color: #00b8a3; }
        .diff-medium { color: #ffc01e; }
        .diff-hard { color: #ff375f; }
        .bar-bg { background: #2c2e29; height: 8px; border-radius: 4px; overflow: hidden; width: 100%; }
        .bar-fill { height: 100%; border-radius: 4px; transition: width 0.4s ease; }
        .fill-easy { background: #00b8a3; }
        .fill-medium { background: #ffc01e; }
        .fill-hard { background: #ff375f; }

        .filters-bar { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 24px; align-items: center; }
        .search-box { flex: 1; min-width: 220px; position: relative; }
        .search-box input { width: 100%; background: #21221e; border: 1px solid #343630; border-radius: 8px; padding: 10px 14px 10px 36px; color: #fff; font-size: 13px; outline: none; box-sizing: border-box; }
        .search-box input:focus { border-color: #aee56e; }
        .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #777; font-size: 14px; }
        .filter-select { background: #21221e; border: 1px solid #343630; color: #ccc; padding: 10px 14px; border-radius: 8px; font-size: 12px; outline: none; cursor: pointer; }
        .filter-select:focus { border-color: #aee56e; }

        .problems-card { background: #21221e; border: 1px solid #32342f; border-radius: 12px; overflow: hidden; }
        .p-table { width: 100%; border-collapse: collapse; text-align: left; }
        .p-table th { background: #1c1d1a; color: #888; font-size: 11px; font-family: 'DM Mono', monospace; padding: 14px 18px; border-bottom: 1px solid #32342f; text-transform: uppercase; letter-spacing: 0.5px; }
        .p-table td { padding: 16px 18px; border-bottom: 1px solid #2b2d28; font-size: 13px; color: #ddd; vertical-align: middle; }
        .p-table tr:hover { background: #282a25; }
        .p-table tr:last-child td { border-bottom: 0; }
        
        .status-solved { color: #2cbb5d; font-size: 16px; font-weight: bold; }
        .status-todo { color: #555; font-size: 16px; }

        .p-title-link { color: #fff; font-weight: 700; text-decoration: none; font-size: 14px; }
        .p-title-link:hover { color: #aee56e; }
        .tag-pill { display: inline-block; background: #2c2e28; color: #9c9e96; font-size: 10px; padding: 3px 8px; border-radius: 12px; margin-left: 8px; font-family: 'DM Mono', monospace; }

        .badge-diff { font-family: 'DM Mono', monospace; font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 12px; display: inline-block; }
        .badge-easy { background: rgba(0,184,163,0.15); color: #00b8a3; }
        .badge-medium { background: rgba(255,192,30,0.15); color: #ffc01e; }
        .badge-hard { background: rgba(255,55,95,0.15); color: #ff375f; }

        .btn-solve { background: #aee56e; color: #111; font-weight: 700; border: 0; padding: 8px 16px; border-radius: 6px; font-size: 11px; text-decoration: none; cursor: pointer; display: inline-block; }
        .btn-solve:hover { background: #bdff7d; }

        @media (max-width: 768px) {
            .hero-stats { grid-template-columns: 1fr; }
            .stat-main { border-right: 0; border-bottom: 1px solid #32342f; padding-bottom: 16px; margin-bottom: 16px; }
        }
    </style>
</head>
<body>

<header class="topbar">
    <a class="brand" href="<%=ctx%>/index.jsp">
        <span class="brand-mark">&lt;/&gt;</span> CodeArena
    </a>
    <nav class="nav-links">
        <a href="<%=ctx%>/user/problems.jsp" class="active">Problems</a>
        <a href="<%=ctx%>/user/contest-dashboard.jsp">Contests</a>
        <a href="<%=ctx%>/admin/dashboard.jsp">Admin Portal</a>
    </nav>
    <div class="top-right">
        <button class="btn-rand" onclick="pickRandomProblem()">
            ⚡ Pick Random
        </button>
    </div>
</header>

<main class="container">
    <div class="hero-stats">
        <div class="stat-main">
            <h1>Problems Explorer</h1>
            <p>Practice algorithmic problems across Arrays, Strings, Dynamic Programming, Trees, and more.</p>
        </div>
        <div class="stat-bars">
            <div class="diff-bar-row">
                <span class="diff-name diff-easy">Easy</span>
                <div class="bar-bg">
                    <div class="bar-fill fill-easy" style="width: <%= totalEasy == 0 ? 0 : (solvedEasy * 100 / totalEasy) %>%;"></div>
                </div>
                <span><%=solvedEasy%> / <%=totalEasy%></span>
            </div>
            <div class="diff-bar-row">
                <span class="diff-name diff-medium">Medium</span>
                <div class="bar-bg">
                    <div class="bar-fill fill-medium" style="width: <%= totalMedium == 0 ? 0 : (solvedMedium * 100 / totalMedium) %>%;"></div>
                </div>
                <span><%=solvedMedium%> / <%=totalMedium%></span>
            </div>
            <div class="diff-bar-row">
                <span class="diff-name diff-hard">Hard</span>
                <div class="bar-bg">
                    <div class="bar-fill fill-hard" style="width: <%= totalHard == 0 ? 0 : (solvedHard * 100 / totalHard) %>%;"></div>
                </div>
                <span><%=solvedHard%> / <%=totalHard%></span>
            </div>
        </div>
    </div>

    <div class="filters-bar">
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input type="text" id="searchInput" placeholder="Search title or topic..." onkeyup="filterProblems()">
        </div>
        <select class="filter-select" id="diffFilter" onchange="filterProblems()">
            <option value="ALL">All Difficulties</option>
            <option value="EASY">Easy</option>
            <option value="MEDIUM">Medium</option>
            <option value="HARD">Hard</option>
        </select>
        <select class="filter-select" id="catFilter" onchange="filterProblems()">
            <option value="ALL">All Topics</option>
            <% for (String cat : categories) { %>
                <option value="<%=cat.toUpperCase()%>"><%=cat%></option>
            <% } %>
        </select>
        <select class="filter-select" id="statusFilter" onchange="filterProblems()">
            <option value="ALL">All Status</option>
            <option value="SOLVED">Solved</option>
            <option value="UNSOLVED">Unsolved</option>
        </select>
    </div>

    <div class="problems-card">
        <table class="p-table" id="problemsTable">
            <thead>
                <tr>
                    <th style="width: 50px;">Status</th>
                    <th>Title & Category</th>
                    <th style="width: 120px;">Difficulty</th>
                    <th style="width: 80px;">Points</th>
                    <th style="width: 100px; text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                for (Map<String, Object> p : allProblems) {
                    int id = ((Number) p.get("id")).intValue();
                    String title = String.valueOf(p.get("title"));
                    String diff = String.valueOf(p.get("difficulty"));
                    String cat = String.valueOf(p.get("category"));
                    String points = String.valueOf(p.get("points"));
                    boolean isSolved = solvedSet.contains(id);
                    
                    String badgeClass = "badge-easy";
                    if ("Medium".equalsIgnoreCase(diff)) badgeClass = "badge-medium";
                    else if ("Hard".equalsIgnoreCase(diff)) badgeClass = "badge-hard";
                %>
                <tr class="problem-row" 
                    data-id="<%=id%>" 
                    data-title="<%=title.toLowerCase()%>" 
                    data-diff="<%=diff.toUpperCase()%>" 
                    data-cat="<%=cat.toUpperCase()%>"
                    data-solved="<%=isSolved ? "SOLVED" : "UNSOLVED"%>">
                    <td>
                        <% if (isSolved) { %>
                            <span class="status-solved" title="Solved">✓</span>
                        <% } else { %>
                            <span class="status-todo" title="Todo">○</span>
                        <% } %>
                    </td>
                    <td>
                        <a href="<%=ctx%>/user/coding-page.jsp?id=<%=id%>" class="p-title-link">
                            <%=id - 100%>. <%=title%>
                        </a>
                        <span class="tag-pill"><%=cat%></span>
                    </td>
                    <td>
                        <span class="badge-diff <%=badgeClass%>"><%=diff%></span>
                    </td>
                    <td style="font-family: 'DM Mono', monospace;"><%=points%> pts</td>
                    <td style="text-align: right;">
                        <a href="<%=ctx%>/user/coding-page.jsp?id=<%=id%>" class="btn-solve">Solve →</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</main>

<script>
const problemIds = [<%=idListJson%>];

function filterProblems() {
    const query = document.getElementById('searchInput').value.toLowerCase().trim();
    const diff = document.getElementById('diffFilter').value;
    const cat = document.getElementById('catFilter').value;
    const status = document.getElementById('statusFilter').value;

    const rows = document.querySelectorAll('.problem-row');
    rows.forEach(row => {
        const title = row.dataset.title;
        const rowDiff = row.dataset.diff;
        const rowCat = row.dataset.cat;
        const rowSolved = row.dataset.solved;

        const matchesQuery = !query || title.includes(query) || rowCat.toLowerCase().includes(query);
        const matchesDiff = diff === 'ALL' || rowDiff === diff;
        const matchesCat = cat === 'ALL' || rowCat === cat;
        const matchesStatus = status === 'ALL' || rowSolved === status;

        if (matchesQuery && matchesDiff && matchesCat && matchesStatus) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function pickRandomProblem() {
    if (problemIds.length === 0) return;
    const randomIndex = Math.floor(Math.random() * problemIds.length);
    const randomId = problemIds[randomIndex];
    window.location.href = '<%=ctx%>/user/coding-page.jsp?id=' + randomId;
}
</script>

</body>
</html>

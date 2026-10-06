<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<% 
String ctx = request.getContextPath(); 
String code = (String) session.getAttribute("currentContestCode");
String title = (String) session.getAttribute("currentContestTitle");
String player = (String) session.getAttribute("displayName");

// Strictly enforce mandatory name and contest code entry
if (code == null || code.trim().isEmpty() || player == null || player.trim().isEmpty()) {
    response.sendRedirect(ctx + "/user/join-contest.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><%=title%> — Contest Arena</title>
<link href="<%=ctx%>/assets/site.css" rel="stylesheet">
<style>
.arena-top{height:65px;background:#242720;color:white;display:flex;align-items:center;justify-content:space-between;padding:0 max(24px,calc((100vw - 1160px)/2))}
.arena-top .brand{font-size:17px}
.arena-top .brand-mark{background:var(--lime);color:#222}
.arena-right{display:flex;align-items:center;gap:20px;font-size:11px;color:#c7c9bf}
.arena-user{border-left:1px solid #44483f;padding-left:18px;font-weight:700;color:#aee56e}
.arena-wrap{width:min(1060px,calc(100% - 48px));margin:48px auto 80px}
.arena-crumb{font:10px var(--mono);color:#898b82}
.arena-heading{display:flex;align-items:flex-end;justify-content:space-between;margin:16px 0 26px}
.arena-heading h1{font-size:36px;letter-spacing:-1.6px;margin:0 0 7px}
.arena-heading p{font-size:12px;color:#7c7e75;margin:0}
.arena-code{border:1px solid #e5e5dd;border-radius:6px;padding:10px 13px;font:10px var(--mono);color:#777970;background:white}
.arena-code strong{color:#272822;margin-left:8px;letter-spacing:1px}
.arena-banner{display:flex;justify-content:space-between;align-items:center;background:#eff2e4;border:1px solid #e5e9d8;border-radius:9px;padding:17px 20px;margin-bottom:24px}
.arena-banner strong{font-size:12px}
.arena-banner p{font-size:11px;color:#777970;margin:5px 0 0}
.arena-banner a{font-size:11px;font-weight:700;border-bottom:1px solid #adb98a;padding-bottom:4px}
.problem-table{background:#fff;border:1px solid #e9e8e2;border-radius:9px;overflow:hidden}
.table-head,.problem-row{display:grid;grid-template-columns:90px 1fr 140px 100px 100px;align-items:center;padding:15px 20px}
.table-head{background:#f6f6f1;color:#85877e;font:9px var(--mono);letter-spacing:.7px}
.problem-row{border-top:1px solid #efeee9;min-height:74px}
.problem-row:hover{background:#fbfcf7}
.problem-row .solved{color:#6d8d2f;font-size:11px}
.prob-id{font:10px var(--mono);color:#999b92}
.prob-title{font-size:13px;font-weight:700}
.prob-title small{display:block;font:9px var(--mono);font-weight:400;letter-spacing:.5px;color:#999b92;margin-top:5px}
.badge-diff{font:8px var(--mono);letter-spacing:.5px}
.badge-easy{color:#668136}
.badge-medium{color:#a37740}
.badge-hard{color:#b25a51}
.pts{font:10px var(--mono);color:#777970}
.solve-btn{font-size:10px;font-weight:700;border:1px solid #e1e1d9;border-radius:5px;padding:8px 12px;justify-self:end;text-decoration:none;color:#333}
.solve-btn:hover{background:var(--lime);border-color:var(--lime);color:#111}
.arena-bottom{margin-top:17px;display:flex;justify-content:space-between;color:#898b82;font-size:10px}
.arena-bottom a:hover{color:#688126}
@media(max-width:640px){.arena-top{padding:0 18px}.arena-right{gap:10px}.arena-user{display:none}.arena-wrap{width:calc(100% - 32px);margin:32px auto}.arena-heading{align-items:flex-start;gap:15px;flex-direction:column}.arena-heading h1{font-size:30px}.table-head,.problem-row{grid-template-columns:36px 1fr 74px 58px 62px;padding:13px 9px;gap:4px}.solve-btn{padding:7px;font-size:9px}.arena-banner{align-items:flex-start;gap:10px}.arena-banner a{white-space:nowrap}.table-head{font-size:8px}}
</style>
</head>
<body>
<header class="arena-top">
    <a class="brand" href="<%=ctx%>/index.jsp"><span class="brand-mark">&lt;/&gt;</span> codearena<span class="brand-dot">.</span></a>
    <div class="arena-right">
        <span>CONTEST: <strong><%=code%></strong></span>
        <span class="arena-user">👤 <%=player%></span>
        <a href="<%=ctx%>/user/join-contest.jsp" style="color:#aaa;text-decoration:none;">Switch Contest ↗</a>
    </div>
</header>
<main class="arena-wrap">
    <div class="arena-crumb">CONTEST ARENA <span class="eyebrow-divider">/</span> <%=code%></div>
    <div class="arena-heading">
        <div>
            <h1><%=title%></h1>
            <p>Welcome, <strong><%=player%></strong>. Solve problems to earn points and climb the contest leaderboard.</p>
        </div>
        <div class="arena-code">INVITE CODE: <strong><%=code%></strong></div>
    </div>
    <div class="arena-banner">
        <div>
            <strong>You're registered in <%=title%>.</strong>
            <p>Select any challenge below to write, test, and submit your code against live judge test cases.</p>
        </div>
        <a href="<%=ctx%>/admin/leaderboard.jsp">View Leaderboard ↗</a>
    </div>
    <section class="problem-table">
        <div class="table-head">
            <span>STATUS</span>
            <span>PROBLEM</span>
            <span>DIFFICULTY</span>
            <span>POINTS</span>
            <span></span>
        </div>
        <% 
        List<Map<String,Object>> problems = com.contest.data.ContestDatabase.problems(code); 
        Set<Integer> solvedSet = (Set<Integer>) session.getAttribute("solvedProblems");
        if (solvedSet == null) solvedSet = new HashSet<Integer>();

        for (Map<String,Object> p : problems) {
            int pId = ((Number)p.get("id")).intValue();
            boolean isSolved = solvedSet.contains(pId);
            String d = String.valueOf(p.get("difficulty")); 
            String dc = "badge-easy";
            if("Medium".equalsIgnoreCase(d)) dc = "badge-medium";
            if("Hard".equalsIgnoreCase(d)) dc = "badge-hard";
        %>
        <article class="problem-row">
            <span class="solved"><%=isSolved ? "✓ Solved" : "○ To do"%></span>
            <span class="prob-title">
                <%=p.get("title")%>
                <small><%=p.get("category")%> · PROBLEM #<%=pId%></small>
            </span>
            <span class="badge-diff <%=dc%>"><%=d.toUpperCase()%></span>
            <span class="pts"><%=p.get("points")%> pts</span>
            <a class="solve-btn" href="<%=ctx%>/user/coding-page.jsp?id=<%=pId%>">Solve Problem →</a>
        </article>
        <% } %>
        <% if(problems.isEmpty()) { %>
            <div style="padding: 24px; color: #888;">This contest currently has no assigned questions.</div>
        <% } %>
    </section>
    <div class="arena-bottom">
        <span>Logged in as <strong><%=player%></strong> for Contest Code: <strong><%=code%></strong></span>
        <a href="<%=ctx%>/user/join-contest.jsp">Join with another code ↗</a>
    </div>
</main>
</body>
</html>

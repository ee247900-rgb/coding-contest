<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<% 
String ctx = request.getContextPath(); 
String prefilledCode = request.getParameter("code");
if (prefilledCode == null) prefilledCode = request.getParameter("contestCode");
if (prefilledCode == null) prefilledCode = "SPRINT26";

List<Map<String, Object>> activeContests = com.contest.data.ContestDatabase.all();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Join a Contest — CodeArena</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@400;500&family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="<%=ctx%>/assets/site.css" rel="stylesheet">
<style>
.join-page{min-height:100vh;background:#f4f4ee;display:grid;grid-template-columns:1fr 1fr}
.join-visual{background:#242720;color:#fff;padding:32px 8%;position:relative;overflow:hidden;display:flex;flex-direction:column;justify-content:space-between;min-height:100vh}
.join-visual:after{content:'{ }';position:absolute;right:-20px;bottom:14%;font:180px var(--mono);color:#ffffff0a;transform:rotate(-10deg)}
.join-visual .brand{color:#fff;position:relative;z-index:1}
.join-quote{position:relative;z-index:1;max-width:470px;margin:auto 0}
.join-quote .eyebrow{color:#c2c9ae}
.join-quote h1{font-size:clamp(42px,5vw,68px);line-height:1.02;letter-spacing:-3px;margin:20px 0}
.join-quote h1 span{color:var(--lime)}
.join-quote p{font-size:14px;color:#b7baaf;line-height:1.8;max-width:390px}
.join-foot{position:relative;z-index:1;color:#8f9486;font-size:11px}
.join-form-wrap{display:grid;place-items:center;padding:40px 24px}
.join-form{width:min(440px,100%)}
.join-form .eyebrow{margin-bottom:13px}
.join-form h2{font-size:32px;letter-spacing:-1.2px;margin:0 0 8px}
.join-form>p{font-size:13px;color:#777970;margin:0 0 24px}
.join-form label{display:block;font-size:11px;font-weight:700;margin:16px 0 6px}
.join-form input{height:46px;width:100%;border:1px solid #dfdfd7;border-radius:6px;background:#fff;padding:0 13px;font:13px var(--sans);outline:none;box-sizing:border-box}
.join-form input:focus{border-color:#91a64c;box-shadow:0 0 0 3px #d8fa724a}
.join-form input.code-input{font:15px var(--mono);letter-spacing:1px;text-transform:uppercase}
.join-form .button{width:100%;margin-top:20px;border:0;cursor:pointer;height:46px;font-size:13px}
.join-note{border-top:1px solid #e4e4dc;margin-top:24px;padding-top:18px;color:#85877f;font-size:12px;line-height:1.7}
.join-note strong{color:#333}
.contest-chip{display:flex;align-items:center;justify-content:space-between;background:#fff;border:1px solid #e1e1d8;border-radius:8px;padding:12px 14px;margin-top:10px;text-decoration:none;color:#222;transition:all 0.2s ease;cursor:pointer}
.contest-chip:hover{border-color:#91a64c;box-shadow:0 2px 8px rgba(0,0,0,0.06)}
.contest-chip-info strong{display:block;font-size:13px;font-weight:700}
.contest-chip-info span{font:11px var(--mono);color:#666}
.btn-chip-join{background:#111;color:#aee56e;font-size:11px;font-weight:700;padding:6px 12px;border-radius:5px}
.alert-error{background:#f8e8e5;color:#8e3b31;padding:12px;border-radius:6px;font-size:12px;margin-bottom:17px}
.join-back{display:inline-block;font-size:11px;color:#74766e;margin-top:20px;text-decoration:none}
.join-back:hover{color:#637c28}
@media(max-width:700px){.join-page{grid-template-columns:1fr}.join-visual{min-height:250px;padding:22px 24px}.join-quote{margin:45px 0 22px}.join-quote h1{font-size:44px;margin:12px 0}.join-quote p,.join-foot{display:none}.join-visual:after{font-size:95px;bottom:8%;right:10px}.join-form-wrap{padding:42px 24px}}
</style>
</head>
<body>
<div class="join-page">
    <aside class="join-visual">
        <a class="brand" href="<%=ctx%>/index.jsp"><span class="brand-mark">&lt;/&gt;</span> codearena<span class="brand-dot">.</span></a>
        <div class="join-quote">
            <div class="eyebrow">MANDATORY CONTEST REGISTRATION</div>
            <h1>Make room<br>for a <span>breakthrough.</span></h1>
            <p>To attend any contest, participants must enter their full name and a valid contest code.</p>
        </div>
        <div class="join-foot">A little friendly competition goes a long way.</div>
    </aside>
    
    <main class="join-form-wrap">
        <form class="join-form" action="<%=ctx%>/joinContest" method="post">
            <div class="eyebrow">REQUIRED STEP <span class="eyebrow-divider">/</span> CONTEST ATTENDANCE</div>
            <h2>Attend a Contest</h2>
            <p>Please enter your name and contest code to join the arena.</p>
            
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="alert-error">⚠️ <%= request.getAttribute("errorMsg") %></div>
            <% } %>
            
            <label for="displayName">YOUR NAME (REQUIRED)</label>
            <input id="displayName" name="displayName" placeholder="e.g. Alex Morgan" maxlength="50" autocomplete="name" required>
            
            <label for="contestCode">CONTEST CODE (REQUIRED)</label>
            <input class="code-input" id="contestCode" name="contestCode" required maxlength="20" placeholder="e.g. SPRINT26" value="<%=prefilledCode%>" autocomplete="off">
            
            <button type="submit" class="button button-dark">Enter Contest Arena <span>→</span></button>
            
            <div class="join-note">
                <strong>Active Contests:</strong>
                <% for (Map<String, Object> c : activeContests) { 
                    String cCode = String.valueOf(c.get("code"));
                    String cTitle = String.valueOf(c.get("title"));
                %>
                    <div onclick="selectContest('<%=cCode%>')" class="contest-chip">
                        <div class="contest-chip-info">
                            <strong><%=cTitle%></strong>
                            <span>Code: <%=cCode%></span>
                        </div>
                        <span class="btn-chip-join">Select Code</span>
                    </div>
                <% } %>
            </div>
            
            <a class="join-back" href="<%=ctx%>/user/problems.jsp">← Practice Problems Without Contest Code</a>
        </form>
    </main>
</div>

<script>
document.getElementById('contestCode').addEventListener('input', function(){
    this.value = this.value.toUpperCase().replace(/[^A-Z0-9-]/g, '');
});

function selectContest(code) {
    document.getElementById('contestCode').value = code;
    document.getElementById('displayName').focus();
}
</script>
</body>
</html>

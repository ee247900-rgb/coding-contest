<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%!
private String html(String s) { if(s==null)return ""; return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;"); }
%>
<%
String ctx = request.getContextPath();
String contestCode = String.valueOf(session.getAttribute("currentContestCode") == null ? "SPRINT26" : session.getAttribute("currentContestCode"));
int problemId = 101; 
try { 
    if(request.getParameter("id") != null) problemId = Integer.parseInt(request.getParameter("id")); 
} catch(NumberFormatException ignored) { }

Map<String,Object> problem = com.contest.data.ProblemDatabase.getProblem(problemId);
if(problem == null) { 
    response.sendRedirect(ctx + "/user/problems.jsp"); 
    return; 
}

Set<Integer> solvedSet = (Set<Integer>) session.getAttribute("solvedProblems");
boolean isSolved = (solvedSet != null && solvedSet.contains(problemId));

List<Map<String,String>> testCases = com.contest.data.ProblemDatabase.getTestCases(problemId);
List<Map<String,Object>> visibleCases = new ArrayList<Map<String,Object>>();
for(int i = 0; i < testCases.size(); i++) {
    Map<String,String> test = testCases.get(i); 
    if(!Boolean.parseBoolean(test.get("hidden"))) {
        Map<String,Object> visible = new LinkedHashMap<String,Object>();
        visible.put("index", i);
        visible.put("input", test.get("input"));
        visible.put("output", test.get("output"));
        visibleCases.add(visible);
    }
}
Map<String,Object> firstSample = visibleCases.isEmpty() ? null : visibleCases.get(0);
String title = String.valueOf(problem.get("title"));
String editorial = String.valueOf(problem.get("editorial") == null ? "Editorial coming soon." : problem.get("editorial"));
String timeComp = String.valueOf(problem.get("timeComplexity") == null ? "O(N)" : problem.get("timeComplexity"));
String spaceComp = String.valueOf(problem.get("spaceComplexity") == null ? "O(1)" : problem.get("spaceComplexity"));

String pyTemplate = "import sys\n\ndef solve():\n    lines = sys.stdin.read().split()\n    if not lines:\n        return\n    # Solution logic here\n\nif __name__ == '__main__':\n    solve()\n";
String cppTemplate = "#include <iostream>\n#include <vector>\n#include <string>\n#include <unordered_map>\n#include <algorithm>\nusing namespace std;\n\nint main() {\n    ios::sync_with_stdio(false);\n    cin.tie(nullptr);\n    // Read input and produce solution output\n    return 0;\n}\n";
String javaTemplate = "import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        if (!sc.hasNext()) return;\n        // Solution logic here\n    }\n}\n";
String jsTemplate = "const fs = require('fs');\n\nfunction main() {\n    const input = fs.readFileSync(0, 'utf-8').trim().split(/\\s+/);\n    if (input.length === 0 || input[0] === '') return;\n    // Solution logic here\n}\n\nmain();\n";

if("Two Sum".equals(title)) {
    pyTemplate = "import sys\n\ndef solve():\n    tokens = list(map(int, sys.stdin.read().split()))\n    if len(tokens) < 2: return\n    target = tokens[-1]\n    nums = tokens[:-1]\n    seen = {}\n    for i, n in enumerate(nums):\n        need = target - n\n        if need in seen:\n            print(f\"{seen[need]} {i}\")\n            return\n        seen[n] = i\n\nsolve()\n";
    cppTemplate = "#include <iostream>\n#include <vector>\n#include <unordered_map>\nusing namespace std;\n\nint main() {\n    ios::sync_with_stdio(false); cin.tie(nullptr);\n    vector<int> nums; int val;\n    while (cin >> val) nums.push_back(val);\n    if (nums.size() < 2) return 0;\n    int target = nums.back(); nums.pop_back();\n    unordered_map<int, int> seen;\n    for (int i = 0; i < (int)nums.size(); i++) {\n        int need = target - nums[i];\n        if (seen.count(need)) {\n            cout << seen[need] << \" \" << i;\n            return 0;\n        }\n        seen[nums[i]] = i;\n    }\n    return 0;\n}\n";
    javaTemplate = "import java.util.*;\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        List<Integer> nums = new ArrayList<>();\n        while (sc.hasNextInt()) nums.add(sc.nextInt());\n        if (nums.size() < 2) return;\n        int target = nums.remove(nums.size() - 1);\n        Map<Integer, Integer> seen = new HashMap<>();\n        for (int i = 0; i < nums.size(); i++) {\n            int need = target - nums.get(i);\n            if (seen.containsKey(need)) {\n                System.out.println(seen.get(need) + \" \" + i);\n                return;\n            }\n            seen.put(nums.get(i), i);\n        }\n    }\n}\n";
    jsTemplate = "const fs = require('fs');\n\nfunction main() {\n    const tokens = fs.readFileSync(0, 'utf-8').trim().split(/\\s+/).map(Number);\n    if (tokens.length < 2) return;\n    const target = tokens.pop();\n    const seen = new Map();\n    for (let i = 0; i < tokens.length; i++) {\n        const need = target - tokens[i];\n        if (seen.has(need)) {\n            console.log(seen.get(need) + ' ' + i);\n            return;\n        }\n        seen.set(tokens[i], i);\n    }\n}\nmain();\n";
} else if("Valid Parentheses".equals(title)) {
    pyTemplate = "import sys\n\ndef solve():\n    s = sys.stdin.read().strip()\n    stack = []\n    mapping = {')': '(', '}': '{', ']': '['}\n    for char in s:\n        if char in mapping:\n            top = stack.pop() if stack else '#'\n            if mapping[char] != top:\n                print('false')\n                return\n        else:\n            stack.append(char)\n    print('true' if not stack else 'false')\n\nsolve()\n";
} else if("Palindrome Number".equals(title)) {
    pyTemplate = "import sys\n\ndef solve():\n    s = sys.stdin.read().strip()\n    if not s: return\n    print('true' if s == s[::-1] else 'false')\n\nsolve()\n";
} else if("Reverse String".equals(title)) {
    pyTemplate = "import sys\n\ndef solve():\n    s = sys.stdin.read().strip()\n    print(s[::-1])\n\nsolve()\n";
} else if("Best Time to Buy and Sell Stock".equals(title)) {
    pyTemplate = "import sys\n\ndef solve():\n    prices = list(map(int, sys.stdin.read().split()))\n    if not prices: return\n    min_p, max_prof = float('inf'), 0\n    for p in prices:\n        min_p = min(min_p, p)\n        max_prof = max(max_prof, p - min_p)\n    print(max_prof)\n\nsolve()\n";
}

List<Map<String,Object>> submissionHistory = (List<Map<String,Object>>) session.getAttribute("submissionHistory");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=html(title)%> — CodeArena Judge</title>
<link href="<%=ctx%>/assets/site.css" rel="stylesheet">
<style>
:root{--app:#171816;--panel:#222320;--raised:#2c2d2a;--stroke:#3a3b37;--muted:#999b94;--white:#f0f0ed;--green:#13b86b;--blue:#62a9ff;--mono:'DM Mono',Consolas,monospace}
*{box-sizing:border-box}
body{margin:0;background:var(--app);color:var(--white);font-family:var(--sans),Arial,sans-serif;overflow:hidden}
.workbar{height:54px;display:flex;align-items:center;gap:18px;padding:0 18px;background:#111210;border-bottom:1px solid #343531}
.workbar a{color:#c5c6c0;text-decoration:none;font-size:12px}
.workbar a:hover{color:white}
.brand-mini{font-weight:700;color:#fff!important;letter-spacing:-.4px}
.brand-mini b{color:#aee56e}
.work-title{font-weight:700;font-size:13px;white-space:nowrap}
.work-spacer{flex:1}
.work-context{font:10px var(--mono);color:#9c9e96}
.icon-button{border:1px solid var(--stroke);background:#242522;color:#ccc;border-radius:6px;height:31px;padding:0 12px;cursor:pointer;font-size:11px;font-weight:600}
.icon-button:hover{background:#32332e;color:#fff}
.action-btn{height:33px;padding:0 16px;border-radius:6px;border:0;font-weight:700;font-size:11px;cursor:pointer}
.submit-btn{background:#0da65d;color:#fff}
.submit-btn:hover{background:#11bf6c}
.action-btn:disabled{opacity:.55;cursor:wait}
.workarea{height:calc(100vh - 54px);padding:7px;display:grid;grid-template-columns:minmax(360px,1fr) minmax(400px,1fr);gap:7px;min-height:0}
.left-pane,.right-pane{min-height:0;display:flex;flex-direction:column;gap:7px}
.surface{background:var(--panel);border:1px solid #343531;border-radius:7px;overflow:hidden}
.description-panel{flex:1;min-height:0;display:flex;flex-direction:column}
.tabbar{height:40px;display:flex;align-items:stretch;border-bottom:1px solid var(--stroke);background:#282926;padding:0 10px;gap:3px;flex-shrink:0}
.tab-button{background:none;border:0;color:#a8aaa3;padding:0 11px;font-size:11px;cursor:pointer;border-bottom:2px solid transparent}
.tab-button:hover{color:#fff}
.tab-button.active{color:#f4f4f1;border-bottom-color:#91cf6d}
.pane-content{display:none;overflow-y:auto;padding:23px 24px 28px;line-height:1.7}
.pane-content.active{display:block}
.statement-head{display:flex;align-items:flex-start;gap:12px}
.statement-head h1{font-size:23px;letter-spacing:-.7px;margin:0 0 15px}
.solved-tag{margin-left:auto;color:#75d99c;font-size:11px;font-weight:700;background:rgba(117,217,156,0.12);padding:4px 10px;border-radius:12px;white-space:nowrap}
.tags{display:flex;gap:7px;margin-bottom:20px;flex-wrap:wrap}
.tag{background:#373834;color:#d3d4cf;border-radius:20px;padding:4px 9px;font-size:9px;font-family:var(--mono)}
.tag.diff-Easy{color:#00b8a3;background:rgba(0,184,163,0.15)}
.tag.diff-Medium{color:#ffc01e;background:rgba(255,192,30,0.15)}
.tag.diff-Hard{color:#ff375f;background:rgba(255,55,95,0.15)}
.pane-content p,.pane-content li{color:#d5d6d1;font-size:12px;line-height:1.75;white-space:pre-wrap}
.pane-content h2{font-size:12px;margin:25px 0 8px;color:#f0f0ed;text-transform:uppercase;letter-spacing:0.5px}
.pane-content code{font:11px var(--mono);background:#363733;padding:2px 5px;border-radius:4px;color:#d6dfb8}
.example-card{border-left:2px solid #4b4d47;padding:8px 12px;margin:9px 0 15px;color:#d1d2cc;font:11px/1.8 var(--mono);background:#1a1b19;border-radius:0 6px 6px 0;white-space:pre-wrap;overflow-wrap:anywhere}
.description-callout{margin-top:20px;padding:11px 12px;background:#2b2c28;border:1px solid #40413c;border-radius:6px;color:#adafa7;font-size:10px}
.editor-panel{flex:1;min-height:0;display:flex;flex-direction:column}
.editor-toolbar{height:42px;display:flex;align-items:center;gap:9px;padding:0 12px;border-bottom:1px solid var(--stroke);background:#292a27;flex-shrink:0}
.language-select{background:#1f201d;border:1px solid #444;color:#eee;font:11px var(--mono);outline:none;padding:4px 8px;border-radius:4px}
.editor-state{font-size:9px;color:#96988f}
.editor-spacer{flex:1}
.tool-icon{background:none;border:0;color:#aaa;font-size:14px;cursor:pointer;padding:5px}
.editor-shell{flex:1;min-height:200px;display:flex;overflow:hidden;background:#1d1e1c}
.gutter{width:42px;padding:13px 8px 16px 0;text-align:right;color:#6c6e67;background:#1d1e1c;font:11px/1.65 var(--mono);white-space:pre;overflow:hidden;user-select:none}
.editor-area{flex:1;min-width:0;resize:none;outline:none;border:0;background:#1d1e1c;color:#daddd5;padding:13px 15px 16px 8px;font:12px/1.65 var(--mono);tab-size:4;white-space:pre;overflow:auto}
.bottom-panel{height:41%;min-height:225px;max-height:390px;display:flex;flex-direction:column}
.bottom-tabs{display:flex;align-items:center;height:38px;background:#292a27;border-bottom:1px solid var(--stroke);padding:0 11px;gap:16px;flex-shrink:0}
.bottom-tab{height:100%;display:flex;align-items:center;gap:6px;border:0;background:none;color:#aeb0a8;font-size:11px;cursor:pointer;border-bottom:2px solid transparent}
.bottom-tab.active{color:#f2f2ee;border-color:#78d091}
.tiny-green{width:11px;height:11px;border:1.5px solid #4bd68a;border-radius:2px}
.result-pill{font:9px var(--mono);margin-left:auto;color:var(--muted)}
.bottom-content{display:none;flex:1;min-height:0;overflow:auto;padding:11px 14px}
.bottom-content.active{display:block}
.case-tabs{display:flex;align-items:center;gap:8px;margin:0 0 12px}
.case-tab{border:0;background:none;color:#a8aaa3;padding:7px 12px;border-radius:6px;font-size:10px;cursor:pointer}
.case-tab.active{background:#393a36;color:#fff}
.case-add{border:0;background:none;color:#aeb0a8;font-size:18px;cursor:pointer}
.case-field{margin:7px 0 11px}
.case-field label{display:block;color:#aeb0a8;font-size:9px;margin-bottom:6px}
.case-input{width:100%;min-height:43px;resize:vertical;border:1px solid transparent;border-radius:6px;background:#393a37;color:#eee;padding:11px 13px;font:11px/1.55 var(--mono);outline:none}
.case-input:focus{border-color:#77796e}
.run-case-row{display:flex;justify-content:flex-end;margin-top:8px}
.small-run{background:#363733;border:1px solid #494a44;border-radius:5px;color:#ddd;padding:7px 11px;font-size:10px;cursor:pointer}
.result-summary{display:flex;align-items:center;gap:9px;margin-bottom:12px}
.result-status{font:700 12px var(--mono)}
.status-accepted{color:#7ee2a5}
.status-failed{color:#ff8e84}
.result-cases{color:#a9aaa4;font-size:10px}
.result-block{margin:9px 0}
.result-block h4{font-size:9px;color:#aaa;font-weight:500;margin:0 0 5px}
.result-value{background:#191a18;border:1px solid #363733;border-radius:5px;padding:9px 11px;white-space:pre-wrap;overflow-wrap:anywhere;font:10px/1.5 var(--mono);color:#ddd;max-height:95px;overflow:auto}
.diff-expected{color:#8de0a9}
.diff-actual{color:#ff9b91}
.history-table{width:100%;border-collapse:collapse;font-size:10px}
.history-table th,.history-table td{text-align:left;padding:10px 7px;border-bottom:1px solid #393a36}
.history-table th{color:#999b94;font-weight:500}
.submission-ok{color:#7ee2a5;font-weight:bold}
.submission-failed{color:#ff8e84;font-weight:bold}
.editorial-box{background:#1a1b19;border:1px solid #343630;border-radius:8px;padding:16px;margin-top:12px}
.complexity-pills{display:flex;gap:12px;margin:12px 0 16px}
.comp-pill{background:#2b2c28;border:1px solid #3a3c36;padding:6px 12px;border-radius:6px;font:11px var(--mono);color:#aee56e}
</style>
</head>
<body>
<header class="workbar">
    <a class="brand-mini" href="<%=ctx%>/index.jsp"><b>&lt;/&gt;</b> codearena</a>
    <a href="<%=ctx%>/user/problems.jsp">☷ &nbsp;Problems Catalog</a>
    <a href="<%=ctx%>/user/contest-dashboard.jsp">🏆 &nbsp;Contests</a>
    <span class="work-title"><%=problemId - 100%>. <%=html(title)%></span>
    <span class="work-spacer"></span>
    <button class="icon-button" title="Run selected test case" onclick="runCode('run')">▶ &nbsp;Run Code</button>
    <button class="action-btn submit-btn" id="submitButton" onclick="runCode('submit')">☁ &nbsp;Submit</button>
</header>

<main class="workarea">
<section class="left-pane">
<div class="surface description-panel">
    <nav class="tabbar">
        <button class="tab-button active" data-panel="description">▤ &nbsp;Description</button>
        <button class="tab-button" data-panel="editorial">▧ &nbsp;Editorial & Approach</button>
        <button class="tab-button" data-panel="submissions">◷ &nbsp;My Submissions</button>
    </nav>
    <article class="pane-content active" id="description">
        <div class="statement-head">
            <h1><%=problemId-100%>. <%=html(title)%></h1>
            <span class="solved-tag" id="solvedTag"><%=isSolved ? "Solved ✓" : ""%></span>
        </div>
        <div class="tags">
            <span class="tag diff-<%=html(String.valueOf(problem.get("difficulty")))%>"><%=html(String.valueOf(problem.get("difficulty")))%></span>
            <span class="tag">⌁ &nbsp;<%=html(String.valueOf(problem.get("category")))%></span>
            <span class="tag"><%=html(String.valueOf(problem.get("points")))%> points</span>
        </div>
        <p><%=html(String.valueOf(problem.get("description")))%></p>
        
        <h2>Input format</h2>
        <p><%=html(String.valueOf(problem.get("inputFormat")))%></p>
        
        <h2>Output format</h2>
        <p><%=html(String.valueOf(problem.get("outputFormat")))%></p>
        
        <% if(firstSample != null) { %>
            <h2>Example 1</h2>
            <div class="example-card">Input:
<%=html(String.valueOf(firstSample.get("input")))%>

Output:
<%=html(String.valueOf(firstSample.get("output")))%></div>
        <% } %>
        
        <h2>Constraints</h2>
        <p><%=html(String.valueOf(problem.get("constraints")))%></p>
        
        <div class="description-callout">
            Reads from standard input (stdin) and writes output to standard output (stdout). Test custom inputs using the Testcase panel below.
        </div>
    </article>

    <article class="pane-content" id="editorial">
        <h1>Solution Approach & Editorial</h1>
        <div class="complexity-pills">
            <div class="comp-pill">Time Complexity: <strong><%=html(timeComp)%></strong></div>
            <div class="comp-pill">Space Complexity: <strong><%=html(spaceComp)%></strong></div>
        </div>
        <div class="editorial-box">
            <p><%=html(editorial)%></p>
        </div>
    </article>

    <article class="pane-content" id="submissions">
        <h1>My Submissions</h1>
        <% if(submissionHistory == null || submissionHistory.isEmpty()) { %>
            <div class="editorial-box" style="color: #999;">No submissions recorded yet for this session. Submit your code to see history here!</div>
        <% } else { %>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>Time</th>
                        <th>Language</th>
                        <th>Status</th>
                        <th>Runtime</th>
                        <th>Memory</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
                <% 
                for(Map<String,Object> sub : submissionHistory) { 
                    int pId = 0;
                    try { pId = ((Number)sub.get("problemId")).intValue(); } catch(Exception e){}
                    if(pId == problemId || sub.get("problemId") == null) {
                %>
                    <tr>
                        <td><%=html(String.valueOf(sub.get("submittedAt")))%></td>
                        <td><%=html(String.valueOf(sub.get("language")))%></td>
                        <td class="<%="ACCEPTED".equals(sub.get("status")) ? "submission-ok" : "submission-failed"%>">
                            <%=html(String.valueOf(sub.get("status")))%>
                        </td>
                        <td><%=sub.get("executionTimeMs") == null ? "0" : sub.get("executionTimeMs")%> ms</td>
                        <td><%=sub.get("memoryUsedMb") == null ? "0" : sub.get("memoryUsedMb")%> MB</td>
                        <td><%=html(String.valueOf(sub.get("message")))%></td>
                    </tr>
                <%  }
                } %>
                </tbody>
            </table>
        <% } %>
    </article>
</div>
</section>

<section class="right-pane">
<div class="surface editor-panel">
    <form id="codeForm" style="display:flex; flex-direction:column; height:100%;">
        <input type="hidden" name="problemId" value="<%=problemId%>">
        <div class="editor-toolbar">
            <span style="color:#56d18e;font-size:12px;font-weight:bold">‹/›</span>
            <select class="language-select" id="languageSelector" name="language">
                <option value="Python">Python 3</option>
                <option value="C++">C++</option>
                <option value="Java">Java</option>
                <option value="JavaScript">JavaScript (Node.js)</option>
            </select>
            <span class="editor-state">● &nbsp;Autosaved</span>
            <span class="editor-spacer"></span>
            <button type="button" class="tool-icon" title="Reset code draft" onclick="resetCode()">↺</button>
            <button type="button" class="tool-icon" title="Copy code" onclick="copyCode()">▢</button>
        </div>
        <div class="editor-shell">
            <pre class="gutter" id="gutter">1</pre>
            <textarea class="editor-area" id="sourceCode" name="sourceCode" spellcheck="false" autocapitalize="off" autocomplete="off"></textarea>
        </div>
    </form>
</div>

<section class="surface bottom-panel">
    <div class="bottom-tabs">
        <button class="bottom-tab active" data-bottom="testcase"><i class="tiny-green"></i> Testcase Panel</button>
        <button class="bottom-tab" data-bottom="result">▸ &nbsp;Judge Result</button>
        <span class="result-pill" id="resultPill"></span>
    </div>
    <div class="bottom-content active" id="testcasePanel">
        <div class="case-tabs" id="caseTabs"></div>
        <div class="case-field">
            <label>Input</label>
            <textarea class="case-input" id="caseInput" rows="2" placeholder="Enter test input here"></textarea>
        </div>
        <div class="case-field">
            <label>Expected Output</label>
            <textarea class="case-input" id="caseExpected" rows="1" readonly placeholder="—"></textarea>
        </div>
        <div class="run-case-row">
            <button class="small-run" onclick="runCode('run')">▶ &nbsp;Run selected case</button>
        </div>
    </div>
    <div class="bottom-content" id="resultPanel">
        <div class="editorial-box" style="color: #888;">Run a test case or click Submit to view judge execution results.</div>
    </div>
</section>
</section>
</main>

<script>
const visibleCases = <%=new com.google.gson.Gson().toJson(visibleCases)%>;
const templates = {
    "Python": <%=new com.google.gson.Gson().toJson(pyTemplate)%>,
    "C++": <%=new com.google.gson.Gson().toJson(cppTemplate)%>,
    "Java": <%=new com.google.gson.Gson().toJson(javaTemplate)%>,
    "JavaScript": <%=new com.google.gson.Gson().toJson(jsTemplate)%>
};
const problemId = <%=problemId%>;
const editor = document.getElementById('sourceCode');
const selector = document.getElementById('languageSelector');

let customCases = [], activeCase = 0, busy = false;

function allCases() { return visibleCases.concat(customCases); }
function cacheKey(lang) { return 'codearena:' + problemId + ':' + lang; }

function loadCode() {
    const saved = localStorage.getItem(cacheKey(selector.value));
    editor.value = (saved === null || !saved.trim()) ? templates[selector.value] : saved;
    updateGutter();
}

function updateGutter() {
    const lines = editor.value.split('\n').length;
    document.getElementById('gutter').textContent = Array.from({length: lines}, (_, i) => i + 1).join('\n');
}

editor.addEventListener('input', () => {
    localStorage.setItem(cacheKey(selector.value), editor.value);
    updateGutter();
});
editor.addEventListener('scroll', () => {
    document.getElementById('gutter').scrollTop = editor.scrollTop;
});
selector.addEventListener('change', loadCode);

function drawCases() {
    const tabs = document.getElementById('caseTabs');
    tabs.innerHTML = '';
    allCases().forEach((c, i) => {
        const b = document.createElement('button');
        b.className = 'case-tab' + (i === activeCase ? ' active' : '');
        b.textContent = c.custom ? c.label : 'Case ' + (i + 1);
        b.onclick = () => selectCase(i);
        tabs.appendChild(b);
    });
    const add = document.createElement('button');
    add.className = 'case-add';
    add.title = 'Add custom test case';
    add.textContent = '+';
    add.onclick = addCustomCase;
    tabs.appendChild(add);
    selectCase(Math.min(activeCase, Math.max(0, allCases().length - 1)), false);
}

function selectCase(i, redraw = true) {
    activeCase = i;
    const c = allCases()[i];
    if (!c) return;
    if (redraw) {
        document.querySelectorAll('.case-tab').forEach((b, n) => b.classList.toggle('active', n === i));
    }
    document.getElementById('caseInput').value = c.input || '';
    const expected = document.getElementById('caseExpected');
    expected.value = c.output || '';
    expected.readOnly = !c.custom;
    expected.placeholder = c.custom ? 'Enter expected output' : '—';
    expected.oninput = () => { if (c.custom) c.output = expected.value; };
}

function addCustomCase() {
    customCases.push({ custom: true, label: 'Custom ' + (customCases.length + 1), input: '', output: '' });
    activeCase = allCases().length - 1;
    drawCases();
    document.getElementById('caseInput').focus();
}

document.getElementById('caseInput').addEventListener('input', e => {
    const c = allCases()[activeCase];
    if (c) c.input = e.target.value;
});

function setBottom(name) {
    document.querySelectorAll('.bottom-tab').forEach(b => b.classList.toggle('active', b.dataset.bottom === name));
    document.querySelectorAll('.bottom-content').forEach(p => p.classList.toggle('active', p.id === (name === 'testcase' ? 'testcasePanel' : 'resultPanel')));
}
document.querySelectorAll('.bottom-tab').forEach(b => b.addEventListener('click', () => setBottom(b.dataset.bottom)));

document.querySelectorAll('.tab-button').forEach(b => b.addEventListener('click', () => {
    document.querySelectorAll('.tab-button').forEach(x => x.classList.toggle('active', x === b));
    document.querySelectorAll('.pane-content').forEach(p => p.classList.toggle('active', p.id === b.dataset.panel));
}));

function escapeHtml(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

async function runCode(action) {
    if (busy) return;
    const c = allCases()[activeCase];
    if (!c) {
        showResult({ status: 'NO_TEST_CASES', message: 'Add a custom test case or select a valid problem.' });
        return;
    }
    busy = true;
    const btn = document.getElementById('submitButton');
    btn.disabled = true;
    document.getElementById('resultPill').textContent = 'Evaluating…';
    setBottom('result');
    showResult({ status: 'RUNNING', message: 'Running program against judge test cases…' });

    const data = new URLSearchParams(new FormData(document.getElementById('codeForm')));
    data.set('action', action);
    data.set('testCaseIndex', c.custom ? '-1' : String(c.index));
    data.set('testInput', document.getElementById('caseInput').value);
    if (c.custom) data.set('customExpectedOutput', c.output || '');

    try {
        const response = await fetch('<%=ctx%>/submitCodeAjax', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: data
        });
        const result = await response.json();
        showResult(result);
        if (result.status === 'ACCEPTED' && action === 'submit') {
            document.getElementById('solvedTag').textContent = 'Solved ✓';
        }
    } catch (error) {
        showResult({ status: 'CONNECTION ERROR', message: 'Could not communicate with the judge backend server.' });
    } finally {
        busy = false;
        btn.disabled = false;
    }
}

function showResult(r) {
    const ok = r.status === 'ACCEPTED';
    const cls = ok ? 'status-accepted' : 'status-failed';
    let html = '<div class="result-summary"><span class="result-status ' + cls + '">' + escapeHtml(r.status || 'ERROR') + '</span><span class="result-cases">' + escapeHtml(r.message || '') + '</span></div>';
    
    if (r.passedTestCases || r.totalTestCases) {
        html += '<div class="result-cases" style="margin-bottom:12px; font-weight:600;">' + Number(r.passedTestCases || 0) + ' / ' + Number(r.totalTestCases || 0) + ' test cases passed &nbsp;·&nbsp; Runtime: ' + Number(r.executionTimeMs || 0) + ' ms &nbsp;·&nbsp; Memory: ' + Number(r.memoryUsedMb || 0) + ' MB</div>';
    }
    
    if (r.hiddenFailure) {
        html += '<div class="description-callout">Failed on a hidden judge case. Details are hidden to prevent hardcoding.</div>';
    } else if (['COMPILATION_ERROR', 'RUNTIME_ERROR', 'SYSTEM_ERROR', 'TIME_LIMIT_EXCEEDED'].includes(r.status)) {
        const diagnostic = r.actualOutput || r.message || 'Execution failed.';
        html += '<div class="result-block"><h4>DIAGNOSTICS & ERROR STACK</h4><pre class="result-value diff-actual">' + escapeHtml(diagnostic) + '</pre></div>';
    } else if (r.failedTestCase) {
        html += '<div class="result-block"><h4>INPUT (CASE ' + Number(r.failedTestCase) + ')</h4><div class="result-value">' + escapeHtml(r.testCaseInput) + '</div></div>' +
                '<div class="result-block"><h4>EXPECTED OUTPUT</h4><div class="result-value diff-expected">' + escapeHtml(r.expectedOutput) + '</div></div>' +
                '<div class="result-block"><h4>YOUR OUTPUT</h4><pre class="result-value diff-actual">' + escapeHtml(r.actualOutput) + '</pre></div>';
    } else if (r.status === 'ACCEPTED' && r.actualOutput) {
        html += '<div class="result-block"><h4>OUTPUT</h4><div class="result-value diff-expected">' + escapeHtml(r.actualOutput) + '</div></div>';
    }
    
    document.getElementById('resultPanel').innerHTML = html;
    document.getElementById('resultPill').textContent = r.status === 'ACCEPTED' ? '✓ Accepted' : (r.failedTestCase ? 'Case ' + r.failedTestCase + ' Failed' : r.status);
}

function resetCode() {
    if (confirm('Reset editor to starter solution template?')) {
        localStorage.removeItem(cacheKey(selector.value));
        loadCode();
    }
}

async function copyCode() {
    try {
        await navigator.clipboard.writeText(editor.value);
        document.querySelector('.editor-state').textContent = 'Copied to clipboard';
        setTimeout(() => document.querySelector('.editor-state').textContent = '● Autosaved', 2000);
    } catch(e) {
        document.querySelector('.editor-state').textContent = 'Clipboard write failed';
    }
}

drawCases();
loadCode();
</script>
</body>
</html>

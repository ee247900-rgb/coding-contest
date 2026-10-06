import urllib.request
import urllib.parse
import json

url = 'http://localhost:8080/coding-platform/submitCodeAjax'
data = urllib.parse.urlencode({
    'problemId': '101',
    'language': 'Python',
    'action': 'submit',
    'sourceCode': '''import sys

def solve():
    tokens = list(map(int, sys.stdin.read().split()))
    if len(tokens) < 2: return
    target = tokens[-1]
    nums = tokens[:-1]
    seen = {}
    for i, n in enumerate(nums):
        need = target - n
        if need in seen:
            print(f"{seen[need]} {i}")
            return
        seen[n] = i

solve()
'''
}).encode('utf-8')

req = urllib.request.Request(url, data=data)
try:
    with urllib.request.urlopen(req) as response:
        print(response.read().decode('utf-8'))
except Exception as e:
    print(e)

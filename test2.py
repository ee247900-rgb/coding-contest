import urllib.request
import urllib.parse
import json

url = 'http://localhost:8080/coding-platform/submitCodeAjax'
data = urllib.parse.urlencode({
    'problemId': '1',
    'language': 'C++',
    'action': 'submit',
    'sourceCode': 'class Solution { public: vector<int> twoSum(vector<int>& nums, int target) { return {0, 1}; } };'
}).encode('utf-8')

req = urllib.request.Request(url, data=data)
try:
    with urllib.request.urlopen(req) as response:
        print(response.read().decode('utf-8'))
except Exception as e:
    print(e)

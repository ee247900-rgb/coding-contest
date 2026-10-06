import urllib.request
import urllib.parse
import json

url = 'http://localhost:8080/coding-platform/submitCodeAjax'
data = urllib.parse.urlencode({
    'problemId': '1',
    'language': 'Python',
    'action': 'submit',
    'sourceCode': 'class Solution:\n    def twoSum(self, nums, target):\n        return [0, 1]'
}).encode('utf-8')

req = urllib.request.Request(url, data=data)
try:
    with urllib.request.urlopen(req) as response:
        print(response.read().decode('utf-8'))
except Exception as e:
    print(e)

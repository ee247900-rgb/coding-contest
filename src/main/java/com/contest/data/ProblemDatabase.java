package com.contest.data;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Complete in-memory problem catalog representing classic LeetCode problems.
 */
public final class ProblemDatabase {
    private static final List<Map<String, Object>> PROBLEMS = new ArrayList<Map<String, Object>>();
    private static final AtomicInteger IDS = new AtomicInteger(100);

    static {
        // 101. Two Sum
        List<Map<String, String>> twoSumCases = new ArrayList<Map<String, String>>();
        twoSumCases.add(test("2 7 11 15\n9", "0 1", false));
        twoSumCases.add(test("3 2 4\n6", "1 2", false));
        twoSumCases.add(test("3 3\n6", "0 1", true));
        addProblemFull("Two Sum",
            "Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.",
            "Space-separated or newline-separated integers representing `nums`, followed by `target` on the last line.",
            "Print two space-separated indices: `index1 index2`.",
            "2 <= nums.length <= 10^4\n-10^9 <= nums[i] <= 10^9\n-10^9 <= target <= 10^9\nExactly one valid answer exists.",
            "Easy", "10", "Arrays", "O(N)", "O(N)",
            "Use a Hash Map to store each number and its index. As you iterate through the array, check if `target - nums[i]` exists in the map.",
            twoSumCases);

        // 102. Add Two Numbers
        List<Map<String, String>> sumCases = new ArrayList<Map<String, String>>();
        sumCases.add(test("12 30", "42", false));
        sumCases.add(test("-8 3", "-5", false));
        sumCases.add(test("100 250", "370", true));
        addProblemFull("Add Two Numbers",
            "Read two integers and print their sum.",
            "Two space-separated integers `a` and `b`.",
            "Print the single integer representing `a + b`.",
            "-10^9 <= a, b <= 10^9",
            "Easy", "15", "Fundamentals", "O(1)", "O(1)",
            "Perform basic addition. Watch out for integer overflow if dealing with larger numbers.",
            sumCases);

        // 103. Valid Parentheses
        List<Map<String, String>> parenthesesCases = new ArrayList<Map<String, String>>();
        parenthesesCases.add(test("()[]{}", "true", false));
        parenthesesCases.add(test("(]", "false", false));
        parenthesesCases.add(test("([{}])", "true", true));
        parenthesesCases.add(test("((((", "false", true));
        addProblemFull("Valid Parentheses",
            "Given a string `s` containing just the characters `'('`, `')'`, `'{'`, `'}'`, `'['` and `']'`, determine if the input string is valid.\n\nAn input string is valid if:\n1. Open brackets must be closed by the same type of brackets.\n2. Open brackets must be closed in the correct order.\n3. Every close bracket has a corresponding open bracket of the same type.",
            "A single line containing the bracket string `s`.",
            "Print `true` if the string is valid, otherwise print `false`.",
            "1 <= s.length <= 10^4\n`s` consists of parentheses only `'()[]{}'`. ",
            "Easy", "20", "Stack", "O(N)", "O(N)",
            "Use a Stack data structure. Whenever an opening bracket is encountered, push it onto the stack. When a closing bracket is encountered, check if it matches the top of the stack.",
            parenthesesCases);

        // 104. Palindrome Number
        List<Map<String, String>> palindromeCases = new ArrayList<Map<String, String>>();
        palindromeCases.add(test("121", "true", false));
        palindromeCases.add(test("-121", "false", false));
        palindromeCases.add(test("10", "false", true));
        palindromeCases.add(test("12321", "true", true));
        addProblemFull("Palindrome Number",
            "Given an integer `x`, return `true` if `x` is a palindrome, and `false` otherwise.\n\nAn integer is a palindrome when it reads the same backward as forward.",
            "A single integer `x`.",
            "Print `true` if `x` is a palindrome, else `false`.",
            "-2^31 <= x <= 2^31 - 1",
            "Easy", "15", "Math", "O(log10 N)", "O(1)",
            "Negative numbers are not palindromes. You can reverse the digits mathematically using `% 10` and `/ 10` operations and check if the reversed number equals original.",
            palindromeCases);

        // 105. Reverse String
        List<Map<String, String>> reverseCases = new ArrayList<Map<String, String>>();
        reverseCases.add(test("hello", "olleh", false));
        reverseCases.add(test("CodeArena", "anerAedoC", false));
        reverseCases.add(test("a", "a", true));
        addProblemFull("Reverse String",
            "Write a program that reverses a given string.",
            "A single line containing the string `s`.",
            "Print the reversed string.",
            "1 <= s.length <= 10^5",
            "Easy", "10", "Strings", "O(N)", "O(1)",
            "Use two pointers technique starting from start and end of the string, swapping characters until they meet in the middle.",
            reverseCases);

        // 106. Best Time to Buy and Sell Stock
        List<Map<String, String>> stockCases = new ArrayList<Map<String, String>>();
        stockCases.add(test("7 1 5 3 6 4", "5", false));
        stockCases.add(test("7 6 4 3 1", "0", false));
        stockCases.add(test("1 2 3 4 5", "4", true));
        addProblemFull("Best Time to Buy and Sell Stock",
            "You are given an array `prices` where `prices[i]` is the price of a given stock on the `i-th` day.\n\nYou want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.\n\nReturn the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.",
            "Space-separated list of stock prices.",
            "Print one integer: the maximum achievable profit.",
            "1 <= prices.length <= 10^5\n0 <= prices[i] <= 10^4",
            "Easy", "20", "Dynamic Programming", "O(N)", "O(1)",
            "Track the minimum price seen so far as you iterate through the list, and update the max profit at each step (`max_profit = max(max_profit, current_price - min_price)`).",
            stockCases);

        // 107. Binary Search
        List<Map<String, String>> searchCases = new ArrayList<Map<String, String>>();
        searchCases.add(test("-1 0 3 5 9 12\n9", "4", false));
        searchCases.add(test("-1 0 3 5 9 12\n2", "-1", false));
        searchCases.add(test("5\n5", "0", true));
        addProblemFull("Binary Search",
            "Given an array of integers `nums` which is sorted in ascending order, and an integer `target`, write a function to search `target` in `nums`. If `target` exists, then return its 0-based index. Otherwise, return -1.",
            "Space-separated sorted integers on the first line, followed by the target on the second line.",
            "Print the 0-based index of target if found, else `-1`.",
            "1 <= nums.length <= 10^4\n-10^4 <= nums[i], target <= 10^4\nAll integers in `nums` are unique and sorted in ascending order.",
            "Easy", "15", "Binary Search", "O(log N)", "O(1)",
            "Maintain `low` and `high` pointers. Calculate `mid = low + (high - low) / 2`. Compare `nums[mid]` with `target` and narrow down the search window.",
            searchCases);

        // 108. Longest Substring Without Repeating Characters
        List<Map<String, String>> substringCases = new ArrayList<Map<String, String>>();
        substringCases.add(test("abcabcbb", "3", false));
        substringCases.add(test("bbbbb", "1", false));
        substringCases.add(test("pwwkew", "3", true));
        substringCases.add(test("abcdef", "6", true));
        addProblemFull("Longest Substring Without Repeating Characters",
            "Given a string `s`, find the length of the longest substring without repeating characters.",
            "A single string `s`.",
            "Print the length of the longest substring with unique characters.",
            "0 <= s.length <= 5 * 10^4",
            "Medium", "25", "Strings", "O(N)", "O(N)",
            "Use the Sliding Window algorithm with a hash set or array to keep track of characters in the current window. Expand the right boundary and shrink the left boundary whenever a duplicate is found.",
            substringCases);

        // 109. Maximum Subarray
        List<Map<String, String>> kadaneCases = new ArrayList<Map<String, String>>();
        kadaneCases.add(test("-2 1 -3 4 -1 2 1 -5 4", "6", false));
        kadaneCases.add(test("1", "1", false));
        kadaneCases.add(test("5 4 -1 7 8", "23", true));
        addProblemFull("Maximum Subarray",
            "Given an integer array `nums`, find the subarray with the largest sum, and return its sum.",
            "Space-separated integers for `nums`.",
            "Print the maximum subarray sum.",
            "1 <= nums.length <= 10^5\n-10^4 <= nums[i] <= 10^4",
            "Medium", "25", "Dynamic Programming", "O(N)", "O(1)",
            "Use Kadane's Algorithm: `current_max = max(nums[i], current_max + nums[i])`, `global_max = max(global_max, current_max)`.",
            kadaneCases);

        // 110. Climbing Stairs
        List<Map<String, String>> stairsCases = new ArrayList<Map<String, String>>();
        stairsCases.add(test("2", "2", false));
        stairsCases.add(test("3", "3", false));
        stairsCases.add(test("5", "8", true));
        stairsCases.add(test("10", "89", true));
        addProblemFull("Climbing Stairs",
            "You are climbing a staircase. It takes `n` steps to reach the top.\n\nEach time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?",
            "A single integer `n`.",
            "Print the total number of distinct ways to climb to the top.",
            "1 <= n <= 45",
            "Easy", "15", "Dynamic Programming", "O(N)", "O(1)",
            "This is equivalent to the Fibonacci Sequence problem! `dp[i] = dp[i-1] + dp[i-2]`. You only need two variables to keep track of previous states.",
            stairsCases);

        // 111. Merge Two Sorted Lists
        List<Map<String, String>> mergeCases = new ArrayList<Map<String, String>>();
        mergeCases.add(test("1 2 4\n1 3 4", "1 1 2 3 4 4", false));
        mergeCases.add(test("5 10\n2 3 8 9", "2 3 5 8 9 10", false));
        mergeCases.add(test("1\n2", "1 2", true));
        addProblemFull("Merge Two Sorted Lists",
            "You are given two sorted lists of integers. Merge the two lists into one sorted list and print the elements.",
            "Space-separated integers for list 1 on line 1, space-separated integers for list 2 on line 2.",
            "Print space-separated merged sorted integers.",
            "0 <= list1.length, list2.length <= 50",
            "Easy", "15", "Arrays", "O(N + M)", "O(N + M)",
            "Use a two-pointer approach comparing the smallest unmerged elements from list 1 and list 2, appending the smaller one to the result.",
            mergeCases);

        // 112. Valid Anagram
        List<Map<String, String>> anagramCases = new ArrayList<Map<String, String>>();
        anagramCases.add(test("anagram nagaram", "true", false));
        anagramCases.add(test("rat car", "false", false));
        anagramCases.add(test("listen silent", "true", true));
        addProblemFull("Valid Anagram",
            "Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise.\n\nAn Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.",
            "Two space-separated strings `s` and `t`.",
            "Print `true` if `t` is an anagram of `s`, else `false`.",
            "1 <= s.length, t.length <= 5 * 10^4",
            "Easy", "15", "Hash Table", "O(N)", "O(1)",
            "If lengths differ, return false. Count frequency of characters in `s` (+1) and `t` (-1) using a frequency array of size 26. Verify all counts equal 0.",
            anagramCases);
    }

    private ProblemDatabase() { }

    public static synchronized int addProblemFull(String title, String description, String inputFormat, String outputFormat,
            String constraints, String difficulty, String points, String category,
            String timeComplexity, String spaceComplexity, String editorial,
            List<Map<String, String>> testCases) {
        Map<String, Object> p = new LinkedHashMap<String, Object>();
        int id = IDS.incrementAndGet();
        p.put("id", id);
        p.put("title", title);
        p.put("description", description);
        p.put("inputFormat", inputFormat);
        p.put("outputFormat", outputFormat);
        p.put("constraints", constraints);
        p.put("difficulty", difficulty);
        p.put("points", points);
        p.put("category", category == null ? "General" : category);
        p.put("timeComplexity", timeComplexity == null ? "O(N)" : timeComplexity);
        p.put("spaceComplexity", spaceComplexity == null ? "O(1)" : spaceComplexity);
        p.put("editorial", editorial == null ? "Editorial coming soon." : editorial);
        p.put("source", "LeetCode Classic");
        p.put("testCases", new ArrayList<Map<String, String>>(testCases));
        PROBLEMS.add(p);
        return id;
    }

    public static synchronized int addProblem(String title, String description, String inputFormat, String outputFormat,
            String constraints, String difficulty, String points, String category, List<Map<String, String>> testCases) {
        return addProblemFull(title, description, inputFormat, outputFormat, constraints, difficulty, points, category, "O(N)", "O(1)", "Editorial coming soon.", testCases);
    }

    public static synchronized void addProblem(String title, String difficulty, String points, String source) {
        Map<String, String> tests = new HashMap<String, String>(); tests.put("input", ""); tests.put("output", ""); tests.put("hidden", "true");
        addProblem(title, "Solve the problem described by the contest host.", "See the sample input.", "Print the requested result.", "See problem statement.", difficulty, points, source, Collections.singletonList(tests));
        PROBLEMS.get(PROBLEMS.size() - 1).put("source", source);
    }

    public static synchronized List<Map<String, Object>> getAllProblems() { return new ArrayList<Map<String, Object>>(PROBLEMS); }
    public static synchronized Map<String, Object> getProblem(int id) {
        for (Map<String, Object> p : PROBLEMS) if (((Number)p.get("id")).intValue() == id) return p;
        return null;
    }
    public static synchronized boolean updateProblem(int id, String title, String description, String inputFormat,
            String outputFormat, String constraints, String difficulty, String points, String category,
            List<Map<String,String>> testCases) {
        Map<String,Object> p = getProblem(id);
        if (p == null) return false;
        p.put("title", title); p.put("description", description); p.put("inputFormat", inputFormat);
        p.put("outputFormat", outputFormat); p.put("constraints", constraints); p.put("difficulty", difficulty);
        p.put("points", points); p.put("category", category == null ? "General" : category);
        p.put("testCases", new ArrayList<Map<String,String>>(testCases));
        return true;
    }
    public static synchronized boolean deleteProblem(int id) {
        Iterator<Map<String,Object>> iterator = PROBLEMS.iterator();
        while (iterator.hasNext()) if (((Number)iterator.next().get("id")).intValue() == id) { iterator.remove(); return true; }
        return false;
    }
    public static synchronized List<Map<String, String>> getTestCases(int id) {
        Map<String,Object> p = getProblem(id);
        return p == null ? Collections.<Map<String,String>>emptyList() : (List<Map<String,String>>)p.get("testCases");
    }
    public static Map<String, String> test(String input, String output, boolean hidden) {
        Map<String, String> c = new LinkedHashMap<String, String>(); c.put("input", input); c.put("output", output); c.put("hidden", String.valueOf(hidden)); return c;
    }
}

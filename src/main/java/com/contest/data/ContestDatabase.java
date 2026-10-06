package com.contest.data;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/** Lightweight shared contest store for the no-configuration starter experience. */
public final class ContestDatabase {
    private static final Map<String, Map<String, Object>> CONTESTS = new ConcurrentHashMap<String, Map<String, Object>>();
    private static final AtomicInteger IDS = new AtomicInteger(0);
    static { 
        add("Sunday Sprint", "SPRINT26", "2026-09-28T00:00", "2026-12-31T23:59", 120, new int[] {101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112}); 
    }
    private ContestDatabase() { }
    public static synchronized void add(String title, String code, String start, String end, int duration) {
        add(title, code, start, end, duration, new int[0]);
    }
    public static synchronized void add(String title, String code, String start, String end, int duration, int[] problemIds) {
        Map<String, Object> contest = new HashMap<String, Object>();
        contest.put("id", IDS.incrementAndGet()); contest.put("title", title); contest.put("code", code.toUpperCase(Locale.ROOT));
        contest.put("start", start); contest.put("end", end); contest.put("duration", duration);
        List<Integer> ids = new ArrayList<Integer>();
        if (problemIds != null) for (int id : problemIds) ids.add(id);
        contest.put("problemIds", ids);
        CONTESTS.put(code.toUpperCase(Locale.ROOT), contest);
    }
    public static Map<String, Object> find(String code) { return code == null ? null : CONTESTS.get(code.trim().toUpperCase(Locale.ROOT)); }
    public static List<Map<String, Object>> all() { return new ArrayList<Map<String, Object>>(CONTESTS.values()); }
    public static synchronized void removeProblem(int problemId) {
        for (Map<String,Object> contest : CONTESTS.values()) {
            List<Integer> ids = (List<Integer>)contest.get("problemIds");
            if (ids != null) ids.remove(Integer.valueOf(problemId));
        }
    }
    public static List<Map<String, Object>> problems(String code) {
        Map<String,Object> contest = find(code);
        List<Map<String,Object>> selected = new ArrayList<Map<String,Object>>();
        if (contest == null) return selected;
        List<?> ids = (List<?>)contest.get("problemIds");
        if (ids != null) for (Object rawId : ids) {
            Map<String,Object> problem = ProblemDatabase.getProblem(((Number)rawId).intValue());
            if (problem != null) selected.add(problem);
        }
        return selected;
    }
}

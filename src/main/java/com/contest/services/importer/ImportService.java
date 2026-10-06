package com.contest.services.importer;

import java.util.Map;
import java.util.List;

public class ImportService {

    /**
     * Parse imported problem data from JSON, CSV, or API.
     */
    public boolean validateData(Map<String, Object> problemData) {
        if (!problemData.containsKey("title") || problemData.get("title").toString().isEmpty()) return false;
        
        // Populate defaults for missing fields to avoid nulls in preview
        if (!problemData.containsKey("difficulty")) problemData.put("difficulty", "Easy");
        if (!problemData.containsKey("points")) problemData.put("points", "10");
        
        return true;
    }

    public void previewProblem(Map<String, Object> problemData) {
        // Logic to generate preview DTO
    }

    public boolean checkDuplicate(String title, String source) {
        // DB check for duplicate
        return false;
    }

    public boolean importToDatabase(Map<String, Object> problemData) {
        String title = (String) problemData.get("title");
        String difficulty = (String) problemData.get("difficulty");
        String points = (String) problemData.get("points");
        String source = (String) problemData.get("source");
        com.contest.data.ProblemDatabase.addProblem(title, difficulty, points, source);
        return true;
    }
}

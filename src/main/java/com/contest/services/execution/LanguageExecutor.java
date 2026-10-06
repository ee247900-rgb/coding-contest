package com.contest.services.execution;

public interface LanguageExecutor {
    ExecutionResult executeCode(String sourceCode, String testInput, String expectedOutput);
}

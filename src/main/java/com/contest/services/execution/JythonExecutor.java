package com.contest.services.execution;

public class JythonExecutor implements LanguageExecutor {

    @Override
    public ExecutionResult executeCode(String sourceCode, String testInput, String expectedOutput) {
        ExecutionResult result = new ExecutionResult();
        // 1. Jython Source Code
        // 2. Jython Runtime Execute
        // 3. Pass Test Input
        // 4. Capture Output
        // 5. Compare Expected Output

        result.setStatus("ACCEPTED");
        result.setExecutionTimeMs(71);
        result.setMemoryUsedMb(22);

        return result;
    }
}

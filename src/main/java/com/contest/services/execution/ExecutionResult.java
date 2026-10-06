package com.contest.services.execution;

public class ExecutionResult {
    private String status;
    private long executionTimeMs;
    private long memoryUsedMb;
    private String message;
    private int failedTestCase;
    private int passedTestCases;
    private int totalTestCases;
    private String expectedOutput;
    private String actualOutput;
    private String testCaseInput;
    private boolean hiddenFailure;

    public ExecutionResult() {}

    public ExecutionResult(String status, long executionTimeMs, long memoryUsedMb) {
        this.status = status;
        this.executionTimeMs = executionTimeMs;
        this.memoryUsedMb = memoryUsedMb;
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public long getExecutionTimeMs() { return executionTimeMs; }
    public void setExecutionTimeMs(long executionTimeMs) { this.executionTimeMs = executionTimeMs; }

    public long getMemoryUsedMb() { return memoryUsedMb; }
    public void setMemoryUsedMb(long memoryUsedMb) { this.memoryUsedMb = memoryUsedMb; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public int getFailedTestCase() { return failedTestCase; }
    public void setFailedTestCase(int failedTestCase) { this.failedTestCase = failedTestCase; }
    public int getPassedTestCases() { return passedTestCases; }
    public void setPassedTestCases(int passedTestCases) { this.passedTestCases = passedTestCases; }
    public int getTotalTestCases() { return totalTestCases; }
    public void setTotalTestCases(int totalTestCases) { this.totalTestCases = totalTestCases; }
    public String getExpectedOutput() { return expectedOutput; }
    public void setExpectedOutput(String expectedOutput) { this.expectedOutput = expectedOutput; }
    public String getActualOutput() { return actualOutput; }
    public void setActualOutput(String actualOutput) { this.actualOutput = actualOutput; }
    public String getTestCaseInput() { return testCaseInput; }
    public void setTestCaseInput(String testCaseInput) { this.testCaseInput = testCaseInput; }
    public boolean isHiddenFailure() { return hiddenFailure; }
    public void setHiddenFailure(boolean hiddenFailure) { this.hiddenFailure = hiddenFailure; }
}

package com.contest.services.execution;

import java.util.Map;
import java.util.HashMap;

public class CodeExecutionService {

    private Map<String, LanguageExecutor> executors;

    public CodeExecutionService() {
        executors = new HashMap<>();
        JavaExecutor javaExec = new JavaExecutor();
        CppExecutor cppExec = new CppExecutor();
        PythonExecutor pyExec = new PythonExecutor();
        JsExecutor jsExec = new JsExecutor();

        executors.put("Java", javaExec);
        executors.put("java", javaExec);

        executors.put("C++", cppExec);
        executors.put("cpp", cppExec);
        executors.put("c_cpp", cppExec);

        executors.put("Python", pyExec);
        executors.put("Python 3", pyExec);
        executors.put("python", pyExec);

        executors.put("JavaScript", jsExec);
        executors.put("JS", jsExec);
        executors.put("javascript", jsExec);

        executors.put("Jython", new JythonExecutor());
    }

    public ExecutionResult execute(String language, String sourceCode, String testInput, String expectedOutput) {
        LanguageExecutor executor = executors.get(language);
        if (executor == null) {
            ExecutionResult result = new ExecutionResult();
            result.setStatus("SYSTEM ERROR: Language '" + language + "' not supported");
            return result;
        }
        return executor.executeCode(sourceCode, testInput, expectedOutput);
    }
}

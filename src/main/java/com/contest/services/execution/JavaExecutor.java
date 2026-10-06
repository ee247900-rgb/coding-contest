package com.contest.services.execution;

import java.io.*;
import java.nio.file.*;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

public class JavaExecutor implements LanguageExecutor {

    @Override
    public ExecutionResult executeCode(String sourceCode, String testInput, String expectedOutput) {
        ExecutionResult result = new ExecutionResult();
        String uuid = UUID.randomUUID().toString();
        String tempDir = System.getProperty("java.io.tmpdir");
        File dir = new File(tempDir, "contest_" + uuid);
        dir.mkdirs();

        File sourceFile = new File(dir, "Main.java");

        try {
            Files.write(sourceFile.toPath(), sourceCode.getBytes("UTF-8"));

            // Compile
            ProcessBuilder compilePb = new ProcessBuilder("javac", "Main.java");
            compilePb.directory(dir);
            Process compileProcess = compilePb.start();
            boolean compiled = compileProcess.waitFor(5, TimeUnit.SECONDS);

            if (!compiled || compileProcess.exitValue() != 0) {
                result.setStatus("COMPILATION_ERROR");
                result.setMessage(readStream(compileProcess.getErrorStream()));
                return result;
            }

            // Run
            long startTime = System.currentTimeMillis();
            ProcessBuilder runPb = new ProcessBuilder("java", "Main");
            runPb.directory(dir);
            Process runProcess = runPb.start();

            // Write input
            if (testInput != null && !testInput.isEmpty()) {
                try (OutputStream os = runProcess.getOutputStream()) {
                    os.write(testInput.getBytes());
                    os.flush();
                }
            }

            boolean finished = runProcess.waitFor(2, TimeUnit.SECONDS);
            long endTime = System.currentTimeMillis();

            if (!finished) {
                runProcess.destroyForcibly();
                result.setStatus("TIME_LIMIT_EXCEEDED");
                return result;
            }

            String output = readStream(runProcess.getInputStream());
            String error = readStream(runProcess.getErrorStream());

            if (runProcess.exitValue() != 0) {
                result.setStatus("RUNTIME_ERROR");
                result.setMessage(error);
                return result;
            }

            result.setExecutionTimeMs(endTime - startTime);
            result.setMemoryUsedMb(15); // Mock
            result.setMessage(output.trim());

            if (expectedOutput != null && !expectedOutput.trim().isEmpty()) {
                if (normalize(output).equals(normalize(expectedOutput))) {
                    result.setStatus("ACCEPTED");
                } else {
                    result.setStatus("WRONG_ANSWER");
                }
            } else {
                result.setStatus("ACCEPTED");
            }

            return result;

        } catch (Exception e) {
            result.setStatus("SYSTEM_ERROR");
            result.setMessage(e.getMessage());
            return result;
        } finally {
            // Cleanup
            sourceFile.delete();
            new File(dir, "Main.class").delete();
            new File(dir, "Solution.class").delete();
            dir.delete();
        }
    }

    private String readStream(InputStream is) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
        }
        return sb.toString();
    }
    private String normalize(String value) { return value == null ? "" : value.trim().replaceAll("\\s+", " "); }
}

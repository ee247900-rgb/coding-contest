package com.contest.services.execution;

import java.io.*;
import java.nio.file.*;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

public class JsExecutor implements LanguageExecutor {

    @Override
    public ExecutionResult executeCode(String sourceCode, String testInput, String expectedOutput) {
        ExecutionResult result = new ExecutionResult();
        String uuid = UUID.randomUUID().toString();
        String tempDir = System.getProperty("java.io.tmpdir");
        File dir = new File(tempDir, "contest_" + uuid);
        dir.mkdirs();

        File sourceFile = new File(dir, "solution.js");

        try {
            Files.write(sourceFile.toPath(), sourceCode.getBytes("UTF-8"));

            ProcessBuilder runPb = new ProcessBuilder("node", "solution.js");
            runPb.directory(dir);
            Process runProcess = null;
            try {
                runProcess = runPb.start();
            } catch (IOException e) {
                result.setStatus("SYSTEM_ERROR");
                result.setMessage("Node.js is not installed or not in PATH.");
                return result;
            }

            long startTime = System.currentTimeMillis();

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
            result.setMemoryUsedMb(10);
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
            sourceFile.delete();
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

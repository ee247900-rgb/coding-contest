package com.contest.selenium;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.Select;
import java.time.Duration;

public class SubmitCodeTest {

    public static void main(String[] args) {
        // Assume ChromeDriver is configured in PATH or set via property
        // System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");

        WebDriver driver = new ChromeDriver();
        try {
            // Implicit wait
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));

            // 1. Navigate to the local server coding page
            driver.get("http://localhost:8080/coding-platform/coding-page.jsp");

            // 2. Select Language
            Select languageDropdown = new Select(driver.findElement(By.id("languageSelector")));
            languageDropdown.selectByValue("Python");

            // 3. Enter Code
            WebElement codeEditor = driver.findElement(By.id("sourceCode"));
            codeEditor.clear();
            codeEditor.sendKeys("def solve():\n    print('0 1')\n\nif __name__ == '__main__':\n    solve()");

            // 4. Submit
            WebElement submitButton = driver.findElement(By.xpath("//button[text()='Submit']"));
            submitButton.click();

            // 5. Verify Result Page
            WebElement statusElement = driver.findElement(By.xpath("//strong[contains(text(), 'Status')]/following-sibling::span"));
            String status = statusElement.getText();
            
            if (status.contains("ACCEPTED")) {
                System.out.println("Test Passed: Code successfully accepted!");
            } else {
                System.out.println("Test Failed: Code status was " + status);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close browser
            driver.quit();
        }
    }
}

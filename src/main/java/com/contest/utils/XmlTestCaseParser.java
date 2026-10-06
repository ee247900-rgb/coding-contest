package com.contest.utils;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class XmlTestCaseParser {

    /**
     * Parses an XML file containing test cases using DOM and XPath.
     * Requirement: XML, DOM, XPath, XPath Queries
     */
    public List<TestCase> parseTestCases(String xmlFilePath) throws Exception {
        List<TestCase> testCases = new ArrayList<>();

        File xmlFile = new File(xmlFilePath);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(xmlFile);
        doc.getDocumentElement().normalize();

        XPath xPath = XPathFactory.newInstance().newXPath();

        // XPath Query: get all <testcase> elements inside <problem>
        String expression = "/problem/testcases/testcase";
        NodeList nodeList = (NodeList) xPath.compile(expression).evaluate(doc, XPathConstants.NODESET);

        for (int i = 0; i < nodeList.getLength(); i++) {
            Element element = (Element) nodeList.item(i);
            
            String input = xPath.compile("input").evaluate(element);
            String expected = xPath.compile("expected").evaluate(element);
            String hiddenStr = xPath.compile("@hidden").evaluate(element);
            boolean isHidden = "true".equalsIgnoreCase(hiddenStr);
            
            testCases.add(new TestCase(input, expected, isHidden));
        }

        return testCases;
    }
    
    public static class TestCase {
        public String input;
        public String expectedOutput;
        public boolean isHidden;
        
        public TestCase(String input, String expectedOutput, boolean isHidden) {
            this.input = input;
            this.expectedOutput = expectedOutput;
            this.isHidden = isHidden;
        }
    }
}

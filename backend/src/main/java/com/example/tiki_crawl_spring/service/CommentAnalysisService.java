package com.example.tiki_crawl_spring.service;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteException;
import org.apache.commons.exec.ExecuteWatchdog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tiki_crawl_spring.model.Comment;
import com.example.tiki_crawl_spring.model.Product;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

@Service
public class CommentAnalysisService {

    @Autowired
    private ProductService productService;
    
    private static final String PROJECT_DIR="D:\\nam3\\tiki_crawl_spring\\tiki_crawl_spring";
    private static final String PYTHON_SCRIPT_PATH = "D:\\sentiment_analysis\\main.py"; 
    private static final String TEMP_DIR = PROJECT_DIR + "\\temp";

    public String analyzeProductComments(String productId) {
        try {
            Product product = productService.getProductById(productId).orElse(null);
            if (product == null) {
                throw new RuntimeException("Product not found with id: " + productId);
            }

            Path tempDir = Paths.get(TEMP_DIR);
            if (!Files.exists(tempDir)) {
                Files.createDirectory(tempDir);
            }

            String inputFilePath = TEMP_DIR + "\\input_" + productId + ".txt";
            Path inputFile = Paths.get(inputFilePath);

            String outputFilePath = TEMP_DIR + "\\output_" + productId + ".json";
            Path outputFile = Paths.get(outputFilePath);

            if (Files.exists(outputFile)) {
                String jsonResult = new String(Files.readAllBytes(outputFile));
                
                ObjectMapper mapper = new ObjectMapper();
                ObjectNode rootNode = (ObjectNode) mapper.readTree(jsonResult);
                rootNode.put("product_name", product.getName());
                jsonResult = mapper.writeValueAsString(rootNode);
                
                return jsonResult;
            }

            if (!Files.exists(inputFile)) {
                List<Comment> comments = product.getComments();
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(inputFilePath))) {
                    for (Comment comment : comments) {
                        writer.write(comment.getContent());
                        writer.newLine();
                    }
                }
            }
            
            CommandLine cmdLine = new CommandLine("cmd");
            cmdLine.addArgument("/c");
            cmdLine.addArgument("set PYTHONIOENCODING=utf-8 && python");
            cmdLine.addArgument(PYTHON_SCRIPT_PATH);
            cmdLine.addArgument(inputFilePath);
            cmdLine.addArgument(outputFilePath);
            System.out.println("Executing command: " + cmdLine.toString());

            DefaultExecutor executor = new DefaultExecutor();
            executor.setWorkingDirectory(new java.io.File("D:\\sentiment_analysis"));
            
            ExecuteWatchdog watchdog = new ExecuteWatchdog(300000);
            executor.setWatchdog(watchdog);

            int exitCode = executor.execute(cmdLine);
            System.out.println("Exit code: " + exitCode);

            if (exitCode == 0) {
                String jsonResult = new String(Files.readAllBytes(Paths.get(outputFilePath)));
                
                ObjectMapper mapper = new ObjectMapper();
                ObjectNode rootNode = (ObjectNode) mapper.readTree(jsonResult);
                rootNode.put("product_name", product.getName());
                jsonResult = mapper.writeValueAsString(rootNode);
                
                return jsonResult;
            } else {
                throw new RuntimeException("Python script execution failed with exit code: " + exitCode);
            }

        } catch (ExecuteException e) {
            throw new RuntimeException("Error executing Python script: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new RuntimeException("Error analyzing comments: " + e.getMessage(), e);
        }
    }
} 
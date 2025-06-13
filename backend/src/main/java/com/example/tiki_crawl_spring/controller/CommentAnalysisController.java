package com.example.tiki_crawl_spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.tiki_crawl_spring.service.CommentAnalysisService;

@RestController
@RequestMapping("/api/comment-analysis")
public class CommentAnalysisController {

    @Autowired
    private CommentAnalysisService commentAnalysisService;

    @GetMapping("/{productId}")
    public ResponseEntity<String> analyzeProductComments(@PathVariable String productId) {
        try {
            String analysisResult = commentAnalysisService.analyzeProductComments(productId);
            return ResponseEntity.ok(analysisResult);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error analyzing comments: " + e.getMessage());
        }
    }
} 
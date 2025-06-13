package com.example.tiki_crawl_spring.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.tiki_crawl_spring.model.Category;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
} 
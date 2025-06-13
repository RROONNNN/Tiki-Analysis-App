package com.example.tiki_crawl_spring.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.tiki_crawl_spring.model.Product;
import com.example.tiki_crawl_spring.repository.ProductRepository;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Service
public class ProductService {
    
    @Autowired
    private ProductRepository productRepository;
    
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    
    @Transactional(readOnly = true)
    public List<Product> loadMoreProducts(int offset, int limit, Long categoryId) {
        Pageable pageable = PageRequest.of(offset / limit, limit);
        List<Product> products;
        if (categoryId != null) {
            products = productRepository.findByCategoryId(categoryId, pageable).getContent();
        } else {
            products = productRepository.findAll(pageable).getContent();
        }
        
        // Clear comments to avoid JSON nesting issues
        products.forEach(product -> {
            if (product.getComments() != null) {
                product.getComments().clear();
            }
        });
        
        return products;
    }
    
    public Optional<Product> getProductById(String id) {
        return productRepository.findById(id);
    }
    
    public Product createProduct(Product product) {
        return productRepository.save(product);
    }
    
    public Product updateProduct(String id, Product productDetails) {
        Product product = productRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
            
        product.setName(productDetails.getName());
        product.setUrlPath(productDetails.getUrlPath());
        product.setType(productDetails.getType());
        product.setAuthorName(productDetails.getAuthorName());
        product.setShortDescription(productDetails.getShortDescription());
        product.setPrice(productDetails.getPrice());
        product.setDiscount(productDetails.getDiscount());
        product.setDiscountRate(productDetails.getDiscountRate());
        product.setRatingAverage(productDetails.getRatingAverage());
        product.setReviewCount(productDetails.getReviewCount());
        product.setOrderCount(productDetails.getOrderCount());
        product.setFavouriteCount(productDetails.getFavouriteCount());
        product.setThumbnailUrl(productDetails.getThumbnailUrl());
        product.setThumbnailWidth(productDetails.getThumbnailWidth());
        product.setThumbnailHeight(productDetails.getThumbnailHeight());
        product.setQuantitySold(productDetails.getQuantitySold());
        product.setCategoryName(productDetails.getCategoryName());
        product.setCategory(productDetails.getCategory());
        
        return productRepository.save(product);
    }
    
    public void deleteProduct(String id) {
        Product product = productRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
        productRepository.delete(product);
    }
} 
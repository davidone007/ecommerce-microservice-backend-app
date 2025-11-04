package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.repository.CategoryRepository;
import com.selimhorri.app.service.ProductService;

@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Transactional
class ProductServiceIntegrationTest {

    @Autowired
    private ProductService productService;
    
    @Autowired
    private CategoryRepository categoryRepository;

    private ProductDto productDto;
    private Category testCategory;

    @BeforeEach
    void setUp() {
        // Create a test category in the database
        testCategory = Category.builder()
            .categoryTitle("Test Category")
            .imageUrl("http://example.com/cat.jpg")
            .build();
        testCategory = categoryRepository.save(testCategory);
        
        // Convert to DTO - Important: include the categoryId
        CategoryDto categoryDto = CategoryDto.builder()
            .categoryId(testCategory.getCategoryId())
            .categoryTitle(testCategory.getCategoryTitle())
            .imageUrl(testCategory.getImageUrl())
            .build();

        productDto = ProductDto.builder()
            .productTitle("Test Product")
            .imageUrl("http://example.com/image.jpg")
            .sku("TEST123")
            .priceUnit(99.99)
            .quantity(10)
            .categoryDto(categoryDto)
            .build();
    }

    @Test
    void testSaveAndFindByIdIntegration() {
        // When
        ProductDto saved = productService.save(productDto);
        ProductDto found = productService.findById(saved.getProductId());

        // Then
        assertNotNull(saved.getProductId());
        assertEquals(productDto.getProductTitle(), saved.getProductTitle());
        assertEquals(productDto.getSku(), saved.getSku());
        assertEquals(saved.getProductId(), found.getProductId());
    }

    @Test
    void testFindAllIntegration() {
        // Given - Create first product
        productService.save(productDto);
        
        // Create second product with a different category
        Category testCategory2 = Category.builder()
            .categoryTitle("Test Category 2")
            .imageUrl("http://example.com/cat2.jpg")
            .build();
        testCategory2 = categoryRepository.save(testCategory2);
        
        CategoryDto categoryDto2 = CategoryDto.builder()
            .categoryId(testCategory2.getCategoryId())
            .categoryTitle(testCategory2.getCategoryTitle())
            .imageUrl(testCategory2.getImageUrl())
            .build();
        
        ProductDto productDto2 = ProductDto.builder()
            .productTitle("Test Product 2")
            .sku("TEST456")
            .priceUnit(199.99)
            .quantity(5)
            .imageUrl("http://example.com/image2.jpg")
            .categoryDto(categoryDto2)
            .build();
        
        productService.save(productDto2);

        // When
        List<ProductDto> result = productService.findAll();

        // Then
        assertNotNull(result);
        assertTrue(result.size() >= 2, "Should have at least 2 products");
    }

    @Test
    void testUpdateIntegration() {
        // Given
        ProductDto saved = productService.save(productDto);
        
        CategoryDto updatedCategoryDto = CategoryDto.builder()
            .categoryId(testCategory.getCategoryId())
            .categoryTitle(testCategory.getCategoryTitle())
            .imageUrl(testCategory.getImageUrl())
            .build();
        
        ProductDto updatedDto = ProductDto.builder()
            .productId(saved.getProductId())
            .productTitle("Updated Product")
            .sku(saved.getSku())
            .priceUnit(149.99)
            .quantity(15)
            .imageUrl(saved.getImageUrl())
            .categoryDto(updatedCategoryDto)
            .build();

        // When
        ProductDto updated = productService.update(updatedDto);

        // Then
        assertEquals("Updated Product", updated.getProductTitle());
        assertEquals(149.99, updated.getPriceUnit());
        assertEquals(15, updated.getQuantity());
    }

    @Test
    void testDeleteByIdIntegration() {
        // Given
        ProductDto saved = productService.save(productDto);

        // When
        productService.deleteById(saved.getProductId());

        // Then
        assertThrows(Exception.class, () -> productService.findById(saved.getProductId()));
    }

    @Test
    void testUpdateWithIdIntegration() {
        // Given
        ProductDto saved = productService.save(productDto);

        // When
        CategoryDto updateCategoryDto = CategoryDto.builder()
            .categoryId(testCategory.getCategoryId())
            .categoryTitle(testCategory.getCategoryTitle())
            .imageUrl(testCategory.getImageUrl())
            .build();
        
        ProductDto updateDto = ProductDto.builder()
            .productId(saved.getProductId())
            .productTitle("Updated via ID")
            .priceUnit(300.0)
            .quantity(20)
            .sku(saved.getSku())
            .imageUrl(saved.getImageUrl())
            .categoryDto(updateCategoryDto)
            .build();
        
        ProductDto updated = productService.update(updateDto);

        // Then
        assertEquals("Updated via ID", updated.getProductTitle());
        assertEquals(300.0, updated.getPriceUnit());
        assertEquals(20, updated.getQuantity());
    }
}
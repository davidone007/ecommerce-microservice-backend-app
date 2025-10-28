package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;

import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.service.ProductService;

@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class ProductServiceIntegrationTest {

    @Autowired
    private ProductService productService;

    private ProductDto productDto;

    @BeforeEach
    void setUp() {
        CategoryDto categoryDto = new CategoryDto();
        categoryDto.setCategoryId(1);
        categoryDto.setCategoryTitle("Test Category");
        categoryDto.setImageUrl("http://example.com/cat.jpg");

        productDto = new ProductDto();
        productDto.setProductTitle("Test Product");
        productDto.setImageUrl("http://example.com/image.jpg");
        productDto.setSku("TEST123");
        productDto.setPriceUnit(99.99);
        productDto.setQuantity(10);
        productDto.setCategoryDto(categoryDto);
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
        // Given
        productService.save(productDto);
        CategoryDto categoryDto2 = new CategoryDto();
        categoryDto2.setCategoryId(2);
        categoryDto2.setCategoryTitle("Test Category 2");
        categoryDto2.setImageUrl("http://example.com/cat2.jpg");
        ProductDto productDto2 = new ProductDto();
        productDto2.setProductTitle("Test Product 2");
        productDto2.setSku("TEST456");
        productDto2.setPriceUnit(199.99);
        productDto2.setQuantity(5);
        productDto2.setCategoryDto(categoryDto2);
        productService.save(productDto2);

        // When
        List<ProductDto> result = productService.findAll();

        // Then
        assertNotNull(result);
        assertTrue(result.size() >= 2);
    }

    @Test
    void testUpdateIntegration() {
        // Given
        ProductDto saved = productService.save(productDto);
        CategoryDto updatedCategoryDto = new CategoryDto();
        updatedCategoryDto.setCategoryId(1);
        updatedCategoryDto.setCategoryTitle("Test Category");
        updatedCategoryDto.setImageUrl("http://example.com/cat.jpg");
        ProductDto updatedDto = new ProductDto();
        updatedDto.setProductId(saved.getProductId());
        updatedDto.setProductTitle("Updated Product");
        updatedDto.setSku(saved.getSku());
        updatedDto.setPriceUnit(149.99);
        updatedDto.setQuantity(15);
        updatedDto.setCategoryDto(updatedCategoryDto);

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
        CategoryDto updateCategoryDto = new CategoryDto();
        updateCategoryDto.setCategoryId(1);
        updateCategoryDto.setCategoryTitle("Test Category");
        updateCategoryDto.setImageUrl("http://example.com/cat.jpg");
        ProductDto updateDto = new ProductDto();
        updateDto.setProductId(saved.getProductId()); // Set the ID
        updateDto.setProductTitle("Updated via ID");
        updateDto.setPriceUnit(300.0);
        updateDto.setQuantity(20);
        updateDto.setCategoryDto(updateCategoryDto);
        ProductDto updated = productService.update(updateDto); // Use update(ProductDto)

        // Then
        assertEquals("Updated via ID", updated.getProductTitle());
        assertEquals(300.0, updated.getPriceUnit());
        assertEquals(20, updated.getQuantity());
    }
}
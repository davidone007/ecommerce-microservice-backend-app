package com.selimhorri.app.helper;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.domain.Product;
import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;

class ProductMappingHelperTest {

    @Test
    void testMapProductToDto() {
        // Given
        Category category = new Category();
        category.setCategoryId(1);
        category.setCategoryTitle("Test Category");
        category.setImageUrl("http://example.com/cat.jpg");
        Product product = new Product();
        product.setProductId(1);
        product.setProductTitle("Test Product");
        product.setImageUrl("http://example.com/image.jpg");
        product.setSku("TEST123");
        product.setPriceUnit(99.99);
        product.setQuantity(10);
        product.setCategory(category);

        // When
        ProductDto dto = ProductMappingHelper.map(product);

        // Then
        assertNotNull(dto);
        assertEquals(1, dto.getProductId());
        assertEquals("Test Product", dto.getProductTitle());
        assertEquals("http://example.com/image.jpg", dto.getImageUrl());
        assertEquals("TEST123", dto.getSku());
        assertEquals(99.99, dto.getPriceUnit());
        assertEquals(10, dto.getQuantity());
        assertNotNull(dto.getCategoryDto());
        assertEquals(1, dto.getCategoryDto().getCategoryId());
    }

    @Test
    void testMapDtoToProduct() {
        // Given
        CategoryDto categoryDto = new CategoryDto();
        categoryDto.setCategoryId(1);
        categoryDto.setCategoryTitle("Test Category");
        categoryDto.setImageUrl("http://example.com/cat.jpg");
        ProductDto dto = new ProductDto();
        dto.setProductId(1);
        dto.setProductTitle("Test Product");
        dto.setImageUrl("http://example.com/image.jpg");
        dto.setSku("TEST123");
        dto.setPriceUnit(99.99);
        dto.setQuantity(10);
        dto.setCategoryDto(categoryDto);

        // When
        Product product = ProductMappingHelper.map(dto);

        // Then
        assertNotNull(product);
        assertEquals(1, product.getProductId());
        assertEquals("Test Product", product.getProductTitle());
        assertEquals("http://example.com/image.jpg", product.getImageUrl());
        assertEquals("TEST123", product.getSku());
        assertEquals(99.99, product.getPriceUnit());
        assertEquals(10, product.getQuantity());
        assertNotNull(product.getCategory());
        assertEquals(1, product.getCategory().getCategoryId());
    }

    @Test
    void testMapProductToDtoWithNullValues() {
        // Given
        Product product = new Product();

        // When & Then - This will fail if category is required, but for now assume it handles null
        assertThrows(NullPointerException.class, () -> ProductMappingHelper.map(product));
    }

    @Test
    void testMapDtoToProductWithNullValues() {
        // Given
        ProductDto dto = new ProductDto();

        // When & Then
        assertThrows(NullPointerException.class, () -> ProductMappingHelper.map(dto));
    }

    @Test
    void testMapProductToDtoConsistency() {
        // Given
        Category category = new Category();
        category.setCategoryId(10);
        category.setCategoryTitle("Consistency Category");
        category.setImageUrl("http://test.com/cat.png");
        Product product = new Product();
        product.setProductId(10);
        product.setProductTitle("Consistency Test");
        product.setImageUrl("http://test.com/img.png");
        product.setSku("CONSIST");
        product.setPriceUnit(150.0);
        product.setQuantity(5);
        product.setCategory(category);

        // When
        ProductDto dto = ProductMappingHelper.map(product);
        Product backToProduct = ProductMappingHelper.map(dto);

        // Then
        assertEquals(product.getProductId(), backToProduct.getProductId());
        assertEquals(product.getProductTitle(), backToProduct.getProductTitle());
        assertEquals(product.getImageUrl(), backToProduct.getImageUrl());
        assertEquals(product.getSku(), backToProduct.getSku());
        assertEquals(product.getPriceUnit(), backToProduct.getPriceUnit());
        assertEquals(product.getQuantity(), backToProduct.getQuantity());
        assertEquals(product.getCategory().getCategoryId(), backToProduct.getCategory().getCategoryId());
    }
}
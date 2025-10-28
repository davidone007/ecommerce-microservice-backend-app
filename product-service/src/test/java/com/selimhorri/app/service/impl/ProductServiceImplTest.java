package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.domain.Product;
import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.ProductNotFoundException;
import com.selimhorri.app.repository.ProductRepository;

@ExtendWith(MockitoExtension.class)
class ProductServiceImplTest {

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private ProductServiceImpl productService;

    private Product product;
    private ProductDto productDto;

    @BeforeEach
    void setUp() {
        Category category = new Category();
        category.setCategoryId(1);
        category.setCategoryTitle("Test Category");
        category.setImageUrl("http://example.com/cat.jpg");

        product = new Product();
        product.setProductId(1);
        product.setProductTitle("Test Product");
        product.setImageUrl("http://example.com/image.jpg");
        product.setSku("TEST123");
        product.setPriceUnit(99.99);
        product.setQuantity(10);
        product.setCategory(category);

        CategoryDto categoryDto = new CategoryDto();
        categoryDto.setCategoryId(1);
        categoryDto.setCategoryTitle("Test Category");
        categoryDto.setImageUrl("http://example.com/cat.jpg");

        productDto = new ProductDto();
        productDto.setProductId(1);
        productDto.setProductTitle("Test Product");
        productDto.setImageUrl("http://example.com/image.jpg");
        productDto.setSku("TEST123");
        productDto.setPriceUnit(99.99);
        productDto.setQuantity(10);
        productDto.setCategoryDto(categoryDto);
    }

    @Test
    void testSave() {
        // Given
        when(productRepository.save(any(Product.class))).thenReturn(product);

        // When
        ProductDto result = productService.save(productDto);

        // Then
        assertNotNull(result);
        assertEquals(productDto.getProductId(), result.getProductId());
        assertEquals(productDto.getProductTitle(), result.getProductTitle());
        assertEquals(productDto.getImageUrl(), result.getImageUrl());
        assertEquals(productDto.getSku(), result.getSku());
        assertEquals(productDto.getPriceUnit(), result.getPriceUnit());
        assertEquals(productDto.getQuantity(), result.getQuantity());
        verify(productRepository, times(1)).save(any(Product.class));
    }

    @Test
    void testUpdate() {
        // Given
        when(productRepository.save(any(Product.class))).thenReturn(product);

        // When
        ProductDto result = productService.update(productDto);

        // Then
        assertNotNull(result);
        assertEquals(productDto.getProductId(), result.getProductId());
        verify(productRepository, times(1)).save(any(Product.class));
    }

    @Test
    void testUpdateWithId() {
        // Given
        when(productRepository.findById(1)).thenReturn(Optional.of(product));
        when(productRepository.save(any(Product.class))).thenReturn(product);

        // When
        ProductDto result = productService.update(1, productDto);

        // Then
        assertNotNull(result);
        verify(productRepository, times(1)).findById(1);
        verify(productRepository, times(1)).save(any(Product.class));
    }

    @Test
    void testDeleteById() {
        // Given
        when(productRepository.findById(1)).thenReturn(Optional.of(product));

        // When
        productService.deleteById(1);

        // Then
        verify(productRepository, times(1)).delete(any(Product.class));
    }

    @Test
    void testFindByIdThrowsExceptionWhenNotFound() {
        // Given
        when(productRepository.findById(1)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(ProductNotFoundException.class, () -> productService.findById(1));
        verify(productRepository, times(1)).findById(1);
    }
}
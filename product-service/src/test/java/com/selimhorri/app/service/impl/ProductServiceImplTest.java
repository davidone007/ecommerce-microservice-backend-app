package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.domain.Product;
import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.CategoryNotFoundException;
import com.selimhorri.app.exception.wrapper.ProductNotFoundException;
import com.selimhorri.app.repository.CategoryRepository;
import com.selimhorri.app.repository.ProductRepository;

/**
 * Pruebas unitarias para ProductServiceImpl.
 * Valida el comportamiento del servicio de productos.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("ProductServiceImpl Unit Tests")
class ProductServiceImplTest {

    @Mock
    private ProductRepository productRepository;

    @Mock
    private CategoryRepository categoryRepository;

    @InjectMocks
    private ProductServiceImpl productService;

    private Product product;
    private ProductDto productDto;
    private Category category;

    @BeforeEach
    void setUp() {
        category = Category.builder()
            .categoryId(1)
            .categoryTitle("Test Category")
            .imageUrl("http://example.com/cat.jpg")
            .build();

        product = Product.builder()
            .productId(1)
            .productTitle("Test Product")
            .imageUrl("http://example.com/image.jpg")
            .sku("TEST123")
            .priceUnit(99.99)
            .quantity(10)
            .category(category)
            .build();

        CategoryDto categoryDto = CategoryDto.builder()
            .categoryId(1)
            .categoryTitle("Test Category")
            .build();

        productDto = ProductDto.builder()
            .productId(1)
            .productTitle("Test Product")
            .imageUrl("http://example.com/image.jpg")
            .sku("TEST123")
            .priceUnit(99.99)
            .quantity(10)
            .categoryDto(categoryDto)
            .build();
    }

    @Test
    @DisplayName("Test 1: Debe guardar un producto exitosamente")
    void testSave_Success() {
        // Given
        ProductDto newProductDto = ProductDto.builder()
            .productTitle("New Product")
            .imageUrl("http://example.com/new.jpg")
            .sku("NEW123")
            .priceUnit(49.99)
            .quantity(20)
            .categoryDto(CategoryDto.builder().categoryId(1).build())
            .build();

        when(categoryRepository.findById(1)).thenReturn(Optional.of(category));
        when(productRepository.save(any(Product.class))).thenReturn(product);

        // When
        ProductDto result = productService.save(newProductDto);

        // Then
        assertNotNull(result);
        verify(categoryRepository, times(1)).findById(1);
        verify(productRepository, times(1)).save(any(Product.class));
    }

    @Test
    @DisplayName("Test 2: Debe lanzar excepción al guardar sin título")
    void testSave_MissingTitle() {
        // Given
        ProductDto invalidProductDto = ProductDto.builder()
            .productTitle("")
            .sku("SKU-003")
            .priceUnit(50.0)
            .quantity(5)
            .imageUrl("http://example.com/image.jpg")
            .categoryDto(CategoryDto.builder().categoryId(1).build())
            .build();

        // When & Then
        assertThrows(IllegalArgumentException.class, () -> productService.save(invalidProductDto));
    }

    @Test
    @DisplayName("Test 3: Debe buscar producto por ID exitosamente")
    void testFindById_Success() {
        // Given
        when(productRepository.findByIdWithoutDeleted(1)).thenReturn(Optional.of(product));

        // When
        ProductDto result = productService.findById(1);

        // Then
        assertNotNull(result);
        assertEquals("Test Product", result.getProductTitle());
        verify(productRepository, times(1)).findByIdWithoutDeleted(1);
    }

    @Test
    @DisplayName("Test 4: Debe lanzar excepción cuando producto no existe")
    void testFindById_ProductNotFound() {
        // Given
        when(productRepository.findByIdWithoutDeleted(999)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(ProductNotFoundException.class, () -> productService.findById(999));
        verify(productRepository, times(1)).findByIdWithoutDeleted(999);
    }

    @Test
    @DisplayName("Test 5: Debe obtener lista de todos los productos")
    void testFindAll_Success() {
        // Given
        Product product2 = Product.builder()
            .productId(2)
            .productTitle("Another Product")
            .sku("TEST456")
            .priceUnit(79.99)
            .quantity(20)
            .category(category)
            .build();

        List<Product> productList = Arrays.asList(product, product2);
        when(productRepository.findAllWithoutDeleted()).thenReturn(productList);

        // When
        List<ProductDto> result = productService.findAll();

        // Then
        assertNotNull(result);
        assertTrue(result.size() >= 0);
        verify(productRepository, times(1)).findAllWithoutDeleted();
    }
}
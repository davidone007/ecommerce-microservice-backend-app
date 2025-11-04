package com.selimhorri.app.integration;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.domain.Product;
import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.ProductNotFoundException;
import com.selimhorri.app.repository.CategoryRepository;
import com.selimhorri.app.repository.ProductRepository;
import com.selimhorri.app.service.ProductService;

/**
 * Pruebas de integración para Product Service.
 * Valida la gestión de productos y categorías, y manejo de errores.
 */
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Transactional
@DisplayName("Product Service Integration Tests")
class ProductServiceIntegrationTest {

	@Autowired
	private ProductService productService;

	@Autowired
	private ProductRepository productRepository;

	@Autowired
	private CategoryRepository categoryRepository;

	private Product testProduct;
	private Category testCategory;

	@BeforeEach
	void setUp() {
		// Crear categoría de prueba
		testCategory = new Category();
		testCategory.setCategoryTitle("Electronics");
		testCategory.setImageUrl("http://example.com/electronics.jpg");
		testCategory = categoryRepository.save(testCategory);

		// Crear producto de prueba
		testProduct = new Product();
		testProduct.setProductTitle("Test Laptop");
		testProduct.setSku("LAPTOP-001");
		testProduct.setImageUrl("http://example.com/laptop.jpg");
		testProduct.setPriceUnit(999.99);
		testProduct.setQuantity(10);
		testProduct.setCategory(testCategory);
		testProduct = productRepository.save(testProduct);
	}

	@Test
	@DisplayName("Integration Test 1: Debe crear producto con categoría asociada")
	void testCreateProduct_WithCategory() {
		// Arrange
		CategoryDto categoryDto = new CategoryDto();
		categoryDto.setCategoryId(testCategory.getCategoryId());
		
		ProductDto newProduct = new ProductDto();
		newProduct.setProductTitle("New Smartphone");
		newProduct.setSku("PHONE-001");
		newProduct.setImageUrl("http://example.com/phone.jpg");
		newProduct.setPriceUnit(599.99);
		newProduct.setQuantity(20);
		newProduct.setCategoryDto(categoryDto);

		// Act
		ProductDto saved = productService.save(newProduct);

		// Assert
		assertNotNull(saved);
		assertNotNull(saved.getProductId());
		assertEquals("New Smartphone", saved.getProductTitle());
		assertEquals(599.99, saved.getPriceUnit());
		assertNotNull(saved.getCategoryDto());
	}

	@Test
	@DisplayName("Integration Test 2: Debe recuperar producto por ID con categoría")
	void testFindProductById_IncludesCategory() {
		// Act
		ProductDto found = productService.findById(testProduct.getProductId());

		// Assert
		assertNotNull(found);
		assertEquals(testProduct.getProductId(), found.getProductId());
		assertEquals("Test Laptop", found.getProductTitle());
		assertEquals(999.99, found.getPriceUnit());
		assertNotNull(found.getCategoryDto());
		assertEquals("Electronics", found.getCategoryDto().getCategoryTitle());
	}

	@Test
	@DisplayName("Integration Test 3: Debe actualizar producto correctamente")
	void testUpdateProduct_PreservesCategory() {
		// Arrange
		CategoryDto categoryDto = new CategoryDto();
		categoryDto.setCategoryId(testCategory.getCategoryId());
		
		ProductDto updateDto = new ProductDto();
		updateDto.setProductId(testProduct.getProductId());
		updateDto.setProductTitle("Updated Laptop");
		updateDto.setSku("LAPTOP-001");
		updateDto.setPriceUnit(1299.99);
		updateDto.setQuantity(15);
		updateDto.setCategoryDto(categoryDto);

		// Act
		ProductDto updated = productService.update(updateDto);

		// Assert
		assertNotNull(updated);
		assertEquals("Updated Laptop", updated.getProductTitle());
		assertEquals(1299.99, updated.getPriceUnit());
		assertEquals(15, updated.getQuantity());
		
		// Verificar persistencia
		Product productInDb = productRepository.findById(testProduct.getProductId()).orElse(null);
		assertNotNull(productInDb);
		assertEquals("Updated Laptop", productInDb.getProductTitle());
	}

	@Test
	@DisplayName("Integration Test 4: Debe lanzar excepción cuando producto no existe")
	void testFindById_ThrowsExceptionWhenNotFound() {
		// Act & Assert
		assertThrows(ProductNotFoundException.class, 
			() -> productService.findById(99999),
			"Should throw ProductNotFoundException for non-existent ID");
	}

	@Test
	@DisplayName("Integration Test 5: Debe obtener lista de productos con categorías")
	void testFindAllProducts_IncludesCategories() {
		// Arrange - Crear múltiples productos
		Product product2 = new Product();
		product2.setProductTitle("Tablet");
		product2.setSku("TABLET-001");
		product2.setPriceUnit(399.99);
		product2.setQuantity(25);
		product2.setCategory(testCategory);
		productRepository.save(product2);

		// Act
		var allProducts = productService.findAll();

		// Assert
		assertNotNull(allProducts);
		assertTrue(allProducts.size() >= 2, "Should return at least 2 products");
		
		// Verificar que todos tienen categoría
		boolean allHaveCategory = allProducts.stream()
			.allMatch(p -> p.getCategoryDto() != null);
		assertTrue(allHaveCategory, "All products should have a category");
	}
}

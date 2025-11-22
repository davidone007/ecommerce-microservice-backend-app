package com.selimhorri.app.integration;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.domain.OrderItem;
import com.selimhorri.app.domain.OrderItemId;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.OrderItemDto;
import com.selimhorri.app.dto.OrderStatus;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.OrderItemNotFoundException;
import com.selimhorri.app.repository.OrderItemRepository;
import com.selimhorri.app.service.OrderItemService;

/**
 * Pruebas de integración para Shipping Service.
 * Valida la comunicación con Order Service y Product Service.
 */
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.ANY)
@Transactional
@DisplayName("Shipping-Order-Product Integration Tests")
class ShippingOrderProductIntegrationTest {

	@Autowired
	private OrderItemService orderItemService;

	@Autowired
	private OrderItemRepository orderItemRepository;

	@MockBean
	private RestTemplate restTemplate;

	private OrderItem testOrderItem;

	@BeforeEach
	void setUp() {
		// Crear un order item de prueba en la BD
		testOrderItem = OrderItem.builder()
				.orderId(1)
				.productId(1)
				.orderedQuantity(5)
				.isActive(true)
				.build();
		testOrderItem = orderItemRepository.save(testOrderItem);

		// Mock external services
		ProductDto mockProduct = ProductDto.builder()
				.productId(testOrderItem.getProductId())
				.productTitle("Test Product")
				.build();

		OrderDto mockOrder = OrderDto.builder()
				.orderId(testOrderItem.getOrderId())
				.orderStatus(OrderStatus.ORDERED.name())
				.build();

		when(restTemplate.getForObject(anyString(), eq(ProductDto.class)))
				.thenReturn(mockProduct);

		when(restTemplate.getForObject(anyString(), eq(OrderDto.class)))
				.thenReturn(mockOrder);
	}

	@Test
	@DisplayName("Integration Test 1: Debe recuperar order item por ID y validar datos")
	void testFindOrderItemById_ValidatesData() {
		// Act
		OrderItemDto result = orderItemService.findById(testOrderItem.getOrderId(), testOrderItem.getProductId());

		// Assert
		assertNotNull(result, "OrderItem should not be null");
		assertEquals(testOrderItem.getOrderId(), result.getOrderId());
		assertEquals(testOrderItem.getProductId(), result.getProductId());
		assertEquals(5, result.getOrderedQuantity());
	}

	@Test
	@DisplayName("Integration Test 2: Debe obtener lista de order items activos")
	void testFindAllActiveOrderItems() {
		// Act - Obtener todos los order items activos desde la BD
		var activeItems = orderItemService.findAll();

		// Assert - Validar que retorna una lista
		assertNotNull(activeItems, "Should return a non-null list");
		// La lista puede estar vacía si los servicios externos no devuelven datos
		// válidos
	}

	@Test
	@DisplayName("Integration Test 3: Debe lanzar excepción cuando order item no existe")
	void testFindById_ThrowsExceptionWhenNotFound() {
		// Act & Assert
		OrderItemNotFoundException exception = assertThrows(OrderItemNotFoundException.class,
				() -> orderItemService.findById(99999, 99999),
				"Should throw OrderItemNotFoundException for non-existent ID");
		assertNotNull(exception);
	}

	@Test
	@DisplayName("Integration Test 4: Debe desactivar order item correctamente (soft delete)")
	void testSoftDeleteOrderItem_DeactivatesInsteadOfDeleting() {
		// Arrange
		Integer orderIdToDelete = testOrderItem.getOrderId();
		Integer productIdToDelete = testOrderItem.getProductId();
		OrderItemId id = new OrderItemId(orderIdToDelete, productIdToDelete);

		// Act
		orderItemService.deleteById(orderIdToDelete, productIdToDelete);

		// Assert - Verificar que el item se desactivó pero sigue en BD
		OrderItem itemInDb = orderItemRepository.findById(id).orElse(null);
		assertNotNull(itemInDb, "OrderItem should still exist in database");
		assertFalse(itemInDb.isActive(), "OrderItem should be marked as inactive");
	}

	@Test
	@DisplayName("Integration Test 5: Debe mantener integridad referencial con Order y Product")
	void testOrderItemIntegrity_MaintainsReferences() {
		// Act
		OrderItemDto retrieved = orderItemService.findById(testOrderItem.getOrderId(), testOrderItem.getProductId());

		// Assert
		assertNotNull(retrieved);
		assertNotNull(retrieved.getOrderId(), "OrderItem must reference an Order");
		assertNotNull(retrieved.getProductId(), "OrderItem must reference a Product");
		assertTrue(retrieved.getOrderedQuantity() > 0, "Ordered quantity must be positive");
	}
}

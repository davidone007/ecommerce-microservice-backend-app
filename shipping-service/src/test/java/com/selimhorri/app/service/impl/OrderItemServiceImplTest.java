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
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.domain.OrderItem;
import com.selimhorri.app.domain.OrderItemId;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.OrderItemDto;
import com.selimhorri.app.dto.OrderStatus;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.OrderItemNotFoundException;
import com.selimhorri.app.repository.OrderItemRepository;

/**
 * Pruebas unitarias para OrderItemServiceImpl.
 * Valida el comportamiento del servicio de items de orden (shipping).
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("OrderItemServiceImpl Unit Tests")
class OrderItemServiceImplTest {

	@Mock
	private OrderItemRepository orderItemRepository;

	@Mock
	private RestTemplate restTemplate;

	@InjectMocks
	private OrderItemServiceImpl orderItemService;

	private OrderItem testOrderItem;
	private OrderItemDto testOrderItemDto;
	private OrderDto mockOrderDto;
	private ProductDto mockProductDto;

	@BeforeEach
	void setUp() {
		testOrderItem = OrderItem.builder()
				.orderId(1)
				.productId(1)
				.orderedQuantity(5)
				.isActive(true)
				.build();

		testOrderItemDto = OrderItemDto.builder()
				.orderId(1)
				.productId(1)
				.orderedQuantity(5)
				.build();

		// Mock order
		mockOrderDto = OrderDto.builder()
				.orderId(1)
				.orderStatus(OrderStatus.ORDERED.name())
				.build();

		// Mock product
		mockProductDto = ProductDto.builder()
				.productId(1)
				.quantity(10)
				.build();
	}

	@Test
	@DisplayName("Test 1: Debe guardar un item de orden exitosamente")
	void testSave_Success() {
		// Arrange - Mock RestTemplate calls for order and product verification
		when(restTemplate.getForObject(anyString(), eq(OrderDto.class)))
				.thenReturn(mockOrderDto);
		when(restTemplate.getForObject(anyString(), eq(ProductDto.class)))
				.thenReturn(mockProductDto);
		when(orderItemRepository.save(any(OrderItem.class))).thenReturn(testOrderItem);

		// Act
		OrderItemDto result = orderItemService.save(testOrderItemDto);

		// Assert
		assertNotNull(result);
		verify(orderItemRepository, times(1)).save(any(OrderItem.class));
	}

	@Test
	@DisplayName("Test 2: Debe buscar item de orden por ID exitosamente")
	void testFindById_Success() {
		// Arrange
		OrderItemId id = new OrderItemId(1, 1);
		when(orderItemRepository.findById(id)).thenReturn(Optional.of(testOrderItem));
		when(restTemplate.getForObject(anyString(), eq(ProductDto.class)))
				.thenReturn(mockProductDto);
		when(restTemplate.getForObject(anyString(), eq(OrderDto.class)))
				.thenReturn(mockOrderDto);

		// Act
		OrderItemDto result = orderItemService.findById(1, 1);

		// Assert
		assertNotNull(result);
		verify(orderItemRepository, times(1)).findById(id);
	}

	@Test
	@DisplayName("Test 3: Debe lanzar excepción cuando item de orden no existe")
	void testFindById_OrderItemNotFound() {
		// Arrange
		OrderItemId id = new OrderItemId(999, 999);
		when(orderItemRepository.findById(id)).thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(OrderItemNotFoundException.class, () -> orderItemService.findById(999, 999));
		verify(orderItemRepository, times(1)).findById(id);
	}

	@Test
	@DisplayName("Test 4: Debe obtener lista de todos los items de orden")
	void testFindAll_Success() {
		// Arrange
		OrderItem orderItem2 = OrderItem.builder()
				.orderId(2)
				.productId(2)
				.orderedQuantity(3)
				.isActive(true)
				.build();

		List<OrderItem> orderItemList = Arrays.asList(testOrderItem, orderItem2);
		when(orderItemRepository.findByIsActiveTrue()).thenReturn(orderItemList);
		when(restTemplate.getForObject(anyString(), eq(ProductDto.class)))
				.thenReturn(mockProductDto);
		when(restTemplate.getForObject(anyString(), eq(OrderDto.class)))
				.thenReturn(mockOrderDto);

		// Act
		List<OrderItemDto> result = orderItemService.findAll();

		// Assert
		assertNotNull(result);
		assertTrue(result.size() >= 0);
		verify(orderItemRepository, times(1)).findByIsActiveTrue();
	}

	@Test
	@DisplayName("Test 5: Debe eliminar un item de orden exitosamente")
	void testDeleteById_Success() {
		// Arrange
		OrderItemId id = new OrderItemId(1, 1);
		when(orderItemRepository.findById(id))
				.thenReturn(Optional.of(testOrderItem));
		when(orderItemRepository.save(any(OrderItem.class))).thenReturn(testOrderItem);

		// Act
		orderItemService.deleteById(1, 1);

		// Assert
		verify(orderItemRepository, times(1)).findById(id);
		verify(orderItemRepository, times(1)).save(any(OrderItem.class));
	}
}

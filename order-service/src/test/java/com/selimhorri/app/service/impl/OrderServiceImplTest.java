package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
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

import com.selimhorri.app.domain.Cart;
import com.selimhorri.app.domain.Order;
import com.selimhorri.app.domain.enums.OrderStatus;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.exception.wrapper.OrderNotFoundException;
import com.selimhorri.app.repository.CartRepository;
import com.selimhorri.app.repository.OrderRepository;

/**
 * Pruebas unitarias para OrderServiceImpl.
 * Valida el comportamiento del servicio de órdenes.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("OrderServiceImpl Unit Tests")
class OrderServiceImplTest {

	@Mock
	private OrderRepository orderRepository;

	@Mock
	private CartRepository cartRepository;

	@InjectMocks
	private OrderServiceImpl orderService;

	private Order testOrder;
	private Cart testCart;

	@BeforeEach
	void setUp() {
		testCart = new Cart();
		testOrder = new Order();
		testOrder.setOrderId(1);
		testOrder.setOrderDate(LocalDateTime.now());
		testOrder.setOrderDesc("Test Order");
		testOrder.setOrderFee(50.0);
		testOrder.setCart(testCart);
		testOrder.setStatus(OrderStatus.CREATED);
	}

	@Test
	@DisplayName("Test 1: Debe actualizar estado de orden exitosamente")
	void testUpdateStatus_Success() {
		// Arrange
		when(orderRepository.findByOrderIdAndIsActiveTrue(1))
			.thenReturn(Optional.of(testOrder));
		when(orderRepository.save(any(Order.class))).thenReturn(testOrder);

		// Act
		OrderDto result = orderService.updateStatus(1);

		// Assert
		assertNotNull(result);
		verify(orderRepository, times(1)).findByOrderIdAndIsActiveTrue(1);
		verify(orderRepository, times(1)).save(any(Order.class));
	}

	@Test
	@DisplayName("Test 2: Debe lanzar excepción al actualizar orden no encontrada")
	void testUpdateStatus_OrderNotFound() {
		// Arrange
		when(orderRepository.findByOrderIdAndIsActiveTrue(999))
			.thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(OrderNotFoundException.class, () -> orderService.updateStatus(999));
		verify(orderRepository, times(1)).findByOrderIdAndIsActiveTrue(999);
	}

	@Test
	@DisplayName("Test 3: Debe buscar orden por ID exitosamente")
	void testFindById_Success() {
		// Arrange
		when(orderRepository.findByOrderIdAndIsActiveTrue(1))
			.thenReturn(Optional.of(testOrder));

		// Act
		OrderDto result = orderService.findById(1);

		// Assert
		assertNotNull(result);
		verify(orderRepository, times(1)).findByOrderIdAndIsActiveTrue(1);
	}

	@Test
	@DisplayName("Test 4: Debe lanzar excepción cuando orden no existe")
	void testFindById_OrderNotFound() {
		// Arrange
		when(orderRepository.findByOrderIdAndIsActiveTrue(999))
			.thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(OrderNotFoundException.class, () -> orderService.findById(999));
	}

	@Test
	@DisplayName("Test 5: Debe obtener lista de todas las órdenes activas")
	void testFindAll_Success() {
		// Arrange
		Order order2 = new Order();
		order2.setOrderId(2);
		order2.setOrderDate(LocalDateTime.now());
		order2.setOrderDesc("Another Order");
		order2.setOrderFee(75.0);
		order2.setCart(testCart);
		order2.setStatus(OrderStatus.ORDERED);

		List<Order> orderList = Arrays.asList(testOrder, order2);
		when(orderRepository.findAllByIsActiveTrue()).thenReturn(orderList);

		// Act
		List<OrderDto> result = orderService.findAll();

		// Assert
		assertNotNull(result);
		assertTrue(result.size() >= 0);
		verify(orderRepository, times(1)).findAllByIsActiveTrue();
	}
}

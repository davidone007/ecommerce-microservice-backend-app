package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.selimhorri.app.domain.Cart;
import com.selimhorri.app.domain.Order;
import com.selimhorri.app.dto.CartDto;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.exception.wrapper.OrderNotFoundException;
import com.selimhorri.app.repository.OrderRepository;

@ExtendWith(MockitoExtension.class)
class OrderServiceImplTest {

    @Mock
    private OrderRepository orderRepository;

    @InjectMocks
    private OrderServiceImpl orderService;

    private Order order;
    private OrderDto orderDto;

    @BeforeEach
    void setUp() {
        LocalDateTime orderDate = LocalDateTime.now();
        Cart cart = Cart.builder().cartId(1).build();
        CartDto cartDto = CartDto.builder().cartId(1).build();
        order = Order.builder()
                .orderId(1)
                .orderDate(orderDate)
                .orderDesc("Test Order")
                .orderFee(100.0)
                .cart(cart)
                .build();
        orderDto = OrderDto.builder()
                .orderId(1)
                .orderDate(orderDate)
                .orderDesc("Test Order")
                .orderFee(100.0)
                .cartDto(cartDto)
                .build();
    }

    @Test
    void testSave() {
        // Given
        when(orderRepository.save(any(Order.class))).thenReturn(order);

        // When
        OrderDto result = orderService.save(orderDto);

        // Then
        assertNotNull(result);
        assertEquals(orderDto.getOrderId(), result.getOrderId());
        assertEquals(orderDto.getOrderDate(), result.getOrderDate());
        assertEquals(orderDto.getOrderDesc(), result.getOrderDesc());
        assertEquals(orderDto.getOrderFee(), result.getOrderFee());
        verify(orderRepository, times(1)).save(any(Order.class));
    }

    @Test
    void testUpdate() {
        // Given
        when(orderRepository.save(any(Order.class))).thenReturn(order);

        // When
        OrderDto result = orderService.update(orderDto);

        // Then
        assertNotNull(result);
        assertEquals(orderDto.getOrderId(), result.getOrderId());
        assertEquals(orderDto.getOrderDate(), result.getOrderDate());
        assertEquals(orderDto.getOrderDesc(), result.getOrderDesc());
        assertEquals(orderDto.getOrderFee(), result.getOrderFee());
        verify(orderRepository, times(1)).save(any(Order.class));
    }

    @Test
    void testUpdateWithId() {
        // Given
        when(orderRepository.findById(1)).thenReturn(Optional.of(order));
        when(orderRepository.save(any(Order.class))).thenReturn(order);

        // When
        OrderDto result = orderService.update(1, orderDto);

        // Then
        assertNotNull(result);
        assertEquals(orderDto.getOrderId(), result.getOrderId());
        verify(orderRepository, times(1)).findById(1);
        verify(orderRepository, times(1)).save(any(Order.class));
    }

    @Test
    void testDeleteById() {
        // Given
        when(orderRepository.findById(1)).thenReturn(Optional.of(order));

        // When
        orderService.deleteById(1);

        // Then
        verify(orderRepository, times(1)).delete(any(Order.class));
    }

    @Test
    void testFindByIdThrowsExceptionWhenNotFound() {
        // Given
        when(orderRepository.findById(1)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(OrderNotFoundException.class, () -> orderService.findById(1));
        verify(orderRepository, times(1)).findById(1);
    }
}
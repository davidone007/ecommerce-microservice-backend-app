package com.selimhorri.app.helper;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;

import com.selimhorri.app.domain.Cart;
import com.selimhorri.app.domain.Order;
import com.selimhorri.app.dto.CartDto;
import com.selimhorri.app.dto.OrderDto;

class OrderMappingHelperTest {

    @Test
    void testMapOrderToDto() {
        // Given
        LocalDateTime orderDate = LocalDateTime.now();
        Cart cart = Cart.builder().cartId(1).build();
        Order order = Order.builder()
                .orderId(1)
                .orderDate(orderDate)
                .orderDesc("Test Order")
                .orderFee(100.0)
                .cart(cart)
                .build();

        // When
        OrderDto dto = OrderMappingHelper.map(order);

        // Then
        assertNotNull(dto);
        assertEquals(1, dto.getOrderId());
        assertEquals(orderDate, dto.getOrderDate());
        assertEquals("Test Order", dto.getOrderDesc());
        assertEquals(100.0, dto.getOrderFee());
        assertNotNull(dto.getCartDto());
        assertEquals(1, dto.getCartDto().getCartId());
    }

    @Test
    void testMapDtoToOrder() {
        // Given
        LocalDateTime orderDate = LocalDateTime.now();
        CartDto cartDto = CartDto.builder().cartId(1).build();
        OrderDto dto = OrderDto.builder()
                .orderId(1)
                .orderDate(orderDate)
                .orderDesc("Test Order")
                .orderFee(100.0)
                .cartDto(cartDto)
                .build();

        // When
        Order order = OrderMappingHelper.map(dto);

        // Then
        assertNotNull(order);
        assertEquals(1, order.getOrderId());
        assertEquals(orderDate, order.getOrderDate());
        assertEquals("Test Order", order.getOrderDesc());
        assertEquals(100.0, order.getOrderFee());
        assertNotNull(order.getCart());
        assertEquals(1, order.getCart().getCartId());
    }

    @Test
    void testMapOrderToDtoWithNullValues() {
        // Given
        Cart cart = Cart.builder().cartId(1).build();
        Order order = Order.builder()
                .cart(cart)
                .build();

        // When
        OrderDto dto = OrderMappingHelper.map(order);

        // Then
        assertNotNull(dto);
        assertNull(dto.getOrderId());
        assertNull(dto.getOrderDate());
        assertNull(dto.getOrderDesc());
        assertNull(dto.getOrderFee());
        assertNotNull(dto.getCartDto());
        assertEquals(1, dto.getCartDto().getCartId());
    }

    @Test
    void testMapDtoToOrderWithNullValues() {
        // Given
        CartDto cartDto = CartDto.builder().cartId(1).build();
        OrderDto dto = OrderDto.builder()
                .cartDto(cartDto)
                .build();

        // When
        Order order = OrderMappingHelper.map(dto);

        // Then
        assertNotNull(order);
        assertNull(order.getOrderId());
        assertNull(order.getOrderDate());
        assertNull(order.getOrderDesc());
        assertNull(order.getOrderFee());
        assertNotNull(order.getCart());
        assertEquals(1, order.getCart().getCartId());
    }

    @Test
    void testMapOrderToDtoConsistency() {
        // Given
        LocalDateTime orderDate = LocalDateTime.of(2023, 10, 28, 12, 0);
        Cart cart = Cart.builder().cartId(10).build();
        Order order = Order.builder()
                .orderId(10)
                .orderDate(orderDate)
                .orderDesc("Consistency Test")
                .orderFee(250.0)
                .cart(cart)
                .build();

        // When
        OrderDto dto = OrderMappingHelper.map(order);
        Order backToOrder = OrderMappingHelper.map(dto);

        // Then
        assertEquals(order.getOrderId(), backToOrder.getOrderId());
        assertEquals(order.getOrderDate(), backToOrder.getOrderDate());
        assertEquals(order.getOrderDesc(), backToOrder.getOrderDesc());
        assertEquals(order.getOrderFee(), backToOrder.getOrderFee());
        assertNotNull(backToOrder.getCart());
        assertEquals(order.getCart().getCartId(), backToOrder.getCart().getCartId());
    }
}
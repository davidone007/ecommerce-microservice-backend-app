package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.context.SpringBootTest;

import com.selimhorri.app.domain.Cart;
import com.selimhorri.app.domain.Order;
import com.selimhorri.app.dto.CartDto;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.repository.OrderRepository;
import com.selimhorri.app.service.OrderService;

@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class OrderServiceIntegrationTest {

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderRepository orderRepository;

    private Order order;
    private OrderDto orderDto;

    @BeforeEach
    void setUp() {
        LocalDateTime orderDate = LocalDateTime.now();
        Cart cart = Cart.builder().cartId(1).build();
        CartDto cartDto = CartDto.builder().cartId(1).build();
        order = Order.builder()
                .orderDate(orderDate)
                .orderDesc("Test Order")
                .orderFee(100.0)
                .cart(cart)
                .build();
        orderDto = OrderDto.builder()
                .orderDate(orderDate)
                .orderDesc("Test Order")
                .orderFee(100.0)
                .cartDto(cartDto)
                .build();
    }

    @Test
    void testSaveAndFindByIdIntegration() {
        // When
        OrderDto saved = orderService.save(orderDto);
        OrderDto found = orderService.findById(saved.getOrderId());

        // Then
        assertNotNull(saved.getOrderId());
        assertEquals(orderDto.getOrderDate(), saved.getOrderDate());
        assertEquals(orderDto.getOrderDesc(), saved.getOrderDesc());
        assertEquals(orderDto.getOrderFee(), saved.getOrderFee());
        assertEquals(saved.getOrderId(), found.getOrderId());
        assertEquals(saved.getOrderDate(), found.getOrderDate());
    }

    @Test
    void testFindAllIntegration() {
        // Given
        orderService.save(orderDto);
        CartDto cartDto2 = CartDto.builder().cartId(2).build();
        OrderDto orderDto2 = OrderDto.builder()
                .orderDate(LocalDateTime.now())
                .orderDesc("Test Order 2")
                .orderFee(200.0)
                .cartDto(cartDto2)
                .build();
        orderService.save(orderDto2);

        // When
        List<OrderDto> result = orderService.findAll();

        // Then
        assertNotNull(result);
        assertTrue(result.size() >= 2);
    }

    @Test
    void testUpdateIntegration() {
        // Given
        OrderDto saved = orderService.save(orderDto);
        OrderDto updatedDto = OrderDto.builder()
                .orderId(saved.getOrderId())
                .orderDate(saved.getOrderDate())
                .orderDesc("Updated Order")
                .orderFee(150.0)
                .cartDto(saved.getCartDto())
                .build();

        // When
        OrderDto updated = orderService.update(updatedDto);

        // Then
        assertEquals("Updated Order", updated.getOrderDesc());
        assertEquals(150.0, updated.getOrderFee());
    }

    @Test
    void testDeleteByIdIntegration() {
        // Given
        OrderDto saved = orderService.save(orderDto);

        // When
        orderService.deleteById(saved.getOrderId());

        // Then
        assertThrows(Exception.class, () -> orderService.findById(saved.getOrderId()));
    }

    @Test
    void testUpdateWithIdIntegration() {
        // Given
        OrderDto saved = orderService.save(orderDto);

        // When
        OrderDto updated = orderService.update(saved.getOrderId(), OrderDto.builder()
                .orderDesc("Updated via ID")
                .orderFee(300.0)
                .cartDto(saved.getCartDto())
                .build());

        // Then
        assertEquals("Updated via ID", updated.getOrderDesc());
        assertEquals(300.0, updated.getOrderFee());
    }
}
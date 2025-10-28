package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import com.selimhorri.app.domain.OrderItem;
import com.selimhorri.app.domain.id.OrderItemId;
import com.selimhorri.app.dto.OrderItemDto;
import com.selimhorri.app.repository.OrderItemRepository;

@ActiveProfiles("test")
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class OrderItemServiceIntegrationTest {

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private TestEntityManager entityManager;

    @Test
    void testSave() {
        // Given
        OrderItem orderItem = OrderItem.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .build();

        // When
        OrderItem saved = orderItemRepository.save(orderItem);
        entityManager.flush();

        // Then
        assertNotNull(saved);
        assertEquals(1, saved.getProductId());
        assertEquals(2, saved.getOrderId());
        assertEquals(5, saved.getOrderedQuantity());
    }

    @Test
    void testFindAll() {
        // Given
        OrderItem orderItem1 = OrderItem.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(3)
                .build();
        OrderItem orderItem2 = OrderItem.builder()
                .productId(3)
                .orderId(4)
                .orderedQuantity(7)
                .build();

        orderItemRepository.save(orderItem1);
        orderItemRepository.save(orderItem2);
        entityManager.flush();

        // When
        List<OrderItem> orderItems = orderItemRepository.findAll();

        // Then
        assertNotNull(orderItems);
        assertTrue(orderItems.size() >= 2);
    }

    @Test
    void testFindById() {
        // Given
        OrderItem orderItem = OrderItem.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .build();

        OrderItem saved = orderItemRepository.save(orderItem);
        entityManager.flush();

        OrderItemId id = new OrderItemId(saved.getProductId(), saved.getOrderId());

        // When
        OrderItem found = orderItemRepository.findById(id).orElse(null);

        // Then
        assertNotNull(found);
        assertEquals(saved.getProductId(), found.getProductId());
        assertEquals(saved.getOrderId(), found.getOrderId());
        assertEquals(saved.getOrderedQuantity(), found.getOrderedQuantity());
    }

    @Test
    void testUpdate() {
        // Given
        OrderItem orderItem = OrderItem.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .build();

        OrderItem saved = orderItemRepository.save(orderItem);
        entityManager.flush();

        // When
        saved.setOrderedQuantity(10);
        OrderItem updated = orderItemRepository.save(saved);
        entityManager.flush();

        // Then
        assertNotNull(updated);
        assertEquals(10, updated.getOrderedQuantity());
    }

    @Test
    void testDeleteById() {
        // Given
        OrderItem orderItem = OrderItem.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .build();

        OrderItem saved = orderItemRepository.save(orderItem);
        entityManager.flush();

        OrderItemId id = new OrderItemId(saved.getProductId(), saved.getOrderId());

        // When
        orderItemRepository.deleteById(id);
        entityManager.flush();

        // Then
        assertFalse(orderItemRepository.findById(id).isPresent());
    }
}
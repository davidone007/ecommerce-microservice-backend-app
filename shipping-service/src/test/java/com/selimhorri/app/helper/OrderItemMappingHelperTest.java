package com.selimhorri.app.helper;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import com.selimhorri.app.domain.OrderItem;
import com.selimhorri.app.domain.id.OrderItemId;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.OrderItemDto;
import com.selimhorri.app.dto.ProductDto;

class OrderItemMappingHelperTest {

    @Test
    void testMapOrderItemToDto() {
        // Given
        OrderItem orderItem = OrderItem.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .build();

        // When
        OrderItemDto dto = OrderItemMappingHelper.map(orderItem);

        // Then
        assertNotNull(dto);
        assertEquals(1, dto.getProductId());
        assertEquals(2, dto.getOrderId());
        assertEquals(5, dto.getOrderedQuantity());
        assertNotNull(dto.getProductDto());
        assertEquals(1, dto.getProductDto().getProductId());
        assertNotNull(dto.getOrderDto());
        assertEquals(2, dto.getOrderDto().getOrderId());
    }

    @Test
    void testMapDtoToOrderItem() {
        // Given
        OrderItemDto dto = OrderItemDto.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .productDto(ProductDto.builder().productId(1).build())
                .orderDto(OrderDto.builder().orderId(2).build())
                .build();

        // When
        OrderItem orderItem = OrderItemMappingHelper.map(dto);

        // Then
        assertNotNull(orderItem);
        assertEquals(1, orderItem.getProductId());
        assertEquals(2, orderItem.getOrderId());
        assertEquals(5, orderItem.getOrderedQuantity());
    }

    @Test
    void testMapOrderItemToDtoWithNullValues() {
        // Given
        OrderItem orderItem = OrderItem.builder().build();

        // When
        OrderItemDto dto = OrderItemMappingHelper.map(orderItem);

        // Then
        assertNotNull(dto);
        assertNull(dto.getProductId());
        assertNull(dto.getOrderId());
        assertNull(dto.getOrderedQuantity());
    }

    @Test
    void testMapDtoToOrderItemWithNullValues() {
        // Given
        OrderItemDto dto = OrderItemDto.builder().build();

        // When
        OrderItem orderItem = OrderItemMappingHelper.map(dto);

        // Then
        assertNotNull(orderItem);
        assertNull(orderItem.getProductId());
        assertNull(orderItem.getOrderId());
        assertNull(orderItem.getOrderedQuantity());
    }

    @Test
    void testMapOrderItemToDtoConsistency() {
        // Given
        OrderItem orderItem = OrderItem.builder()
                .productId(10)
                .orderId(20)
                .orderedQuantity(3)
                .build();

        // When
        OrderItemDto dto = OrderItemMappingHelper.map(orderItem);
        OrderItem backToOrderItem = OrderItemMappingHelper.map(dto);

        // Then
        assertEquals(orderItem.getProductId(), backToOrderItem.getProductId());
        assertEquals(orderItem.getOrderId(), backToOrderItem.getOrderId());
        assertEquals(orderItem.getOrderedQuantity(), backToOrderItem.getOrderedQuantity());
    }
}
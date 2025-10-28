package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.domain.OrderItem;
import com.selimhorri.app.domain.id.OrderItemId;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.OrderItemDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.OrderItemNotFoundException;
import com.selimhorri.app.repository.OrderItemRepository;

@ExtendWith(MockitoExtension.class)
class OrderItemServiceImplTest {

    @Mock
    private OrderItemRepository orderItemRepository;

    @Mock
    private RestTemplate restTemplate;

    @InjectMocks
    private OrderItemServiceImpl orderItemService;

    private OrderItem orderItem;
    private OrderItemDto orderItemDto;
    private OrderItemId orderItemId;
    private ProductDto productDto;
    private OrderDto orderDto;

    @BeforeEach
    void setUp() {
        orderItemId = new OrderItemId(1, 2);
        productDto = ProductDto.builder().productId(1).build();
        orderDto = OrderDto.builder().orderId(2).build();

        orderItem = OrderItem.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .build();

        orderItemDto = OrderItemDto.builder()
                .productId(1)
                .orderId(2)
                .orderedQuantity(5)
                .productDto(productDto)
                .orderDto(orderDto)
                .build();
    }

    @Test
    void testSave() {
        // Given
        when(orderItemRepository.save(any(OrderItem.class))).thenReturn(orderItem);

        // When
        OrderItemDto result = orderItemService.save(orderItemDto);

        // Then
        assertNotNull(result);
        assertEquals(orderItemDto.getProductId(), result.getProductId());
        assertEquals(orderItemDto.getOrderId(), result.getOrderId());
        assertEquals(orderItemDto.getOrderedQuantity(), result.getOrderedQuantity());
        verify(orderItemRepository, times(1)).save(any(OrderItem.class));
    }

    @Test
    void testUpdate() {
        // Given
        when(orderItemRepository.save(any(OrderItem.class))).thenReturn(orderItem);

        // When
        OrderItemDto result = orderItemService.update(orderItemDto);

        // Then
        assertNotNull(result);
        assertEquals(orderItemDto.getProductId(), result.getProductId());
        assertEquals(orderItemDto.getOrderId(), result.getOrderId());
        verify(orderItemRepository, times(1)).save(any(OrderItem.class));
    }

    @Test
    void testDeleteById() {
        // When
        orderItemService.deleteById(orderItemId);

        // Then
        verify(orderItemRepository, times(1)).deleteById(orderItemId);
    }

    @Test
    void testFindByIdThrowsExceptionWhenNotFound() {
        // Given
        when(orderItemRepository.findById(orderItemId)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(OrderItemNotFoundException.class, () -> orderItemService.findById(orderItemId));
        verify(orderItemRepository, times(1)).findById(orderItemId);
    }

    @Test
    void testSaveWithNullDto() {
        // When & Then
        assertThrows(NullPointerException.class, () -> orderItemService.save(null));
    }
}
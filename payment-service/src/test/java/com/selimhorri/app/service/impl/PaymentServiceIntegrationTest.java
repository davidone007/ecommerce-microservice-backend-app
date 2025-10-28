package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.PaymentServiceApplication;
import com.selimhorri.app.domain.Payment;
import com.selimhorri.app.domain.PaymentStatus;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.PaymentDto;
import com.selimhorri.app.repository.PaymentRepository;
import com.selimhorri.app.service.PaymentService;

@SpringBootTest(classes = PaymentServiceApplication.class)
class PaymentServiceIntegrationTest {

    @Autowired
    private PaymentService paymentService;

    @MockBean
    private PaymentRepository paymentRepository;

    @MockBean
    private RestTemplate restTemplate;

    private Payment payment;
    private PaymentDto paymentDto;
    private OrderDto orderDto;

    @BeforeEach
    void setUp() {
        payment = Payment.builder()
                .paymentId(1)
                .orderId(2)
                .isPayed(true)
                .paymentStatus(PaymentStatus.COMPLETED)
                .build();
        paymentDto = PaymentDto.builder()
                .paymentId(1)
                .isPayed(true)
                .paymentStatus(PaymentStatus.COMPLETED)
                .build();
        orderDto = OrderDto.builder().orderId(2).build();
    }

    @Test
    void testFindAllIntegration() {
        // Given
        when(paymentRepository.findAll()).thenReturn(List.of(payment));
        when(restTemplate.getForObject(anyString(), eq(OrderDto.class))).thenReturn(orderDto);

        // When
        List<PaymentDto> result = paymentService.findAll();

        // Then
        assertNotNull(result);
        assertEquals(1, result.size());
        PaymentDto dto = result.get(0);
        assertEquals(1, dto.getPaymentId());
        assertNotNull(dto.getOrderDto());
        verify(paymentRepository, times(1)).findAll();
        verify(restTemplate, times(1)).getForObject(contains("order-service"), eq(OrderDto.class));
    }

    @Test
    void testFindByIdIntegration() {
        // Given
        when(paymentRepository.findById(1)).thenReturn(java.util.Optional.of(payment));
        when(restTemplate.getForObject(anyString(), eq(OrderDto.class))).thenReturn(orderDto);

        // When
        PaymentDto result = paymentService.findById(1);

        // Then
        assertNotNull(result);
        assertEquals(1, result.getPaymentId());
        assertNotNull(result.getOrderDto());
        verify(paymentRepository, times(1)).findById(1);
        verify(restTemplate, times(1)).getForObject(contains("order-service"), eq(OrderDto.class));
    }

    @Test
    void testFindAllWithEmptyList() {
        // Given
        when(paymentRepository.findAll()).thenReturn(List.of());

        // When
        List<PaymentDto> result = paymentService.findAll();

        // Then
        assertNotNull(result);
        assertTrue(result.isEmpty());
        verify(paymentRepository, times(1)).findAll();
        verify(restTemplate, never()).getForObject(anyString(), any());
    }

    @Test
    void testFindByIdWithRestTemplateFailure() {
        // Given
        when(paymentRepository.findById(1)).thenReturn(java.util.Optional.of(payment));
        when(restTemplate.getForObject(anyString(), eq(OrderDto.class))).thenThrow(new RuntimeException("Service unavailable"));

        // When & Then
        assertThrows(RuntimeException.class, () -> paymentService.findById(1));
        verify(paymentRepository, times(1)).findById(1);
        verify(restTemplate, times(1)).getForObject(anyString(), eq(OrderDto.class));
    }

    @Test
    void testFindAllWithMultiplePayments() {
        // Given
        Payment payment2 = Payment.builder()
                .paymentId(3)
                .orderId(4)
                .isPayed(false)
                .paymentStatus(PaymentStatus.NOT_STARTED)
                .build();
        when(paymentRepository.findAll()).thenReturn(List.of(payment, payment2));
        when(restTemplate.getForObject(contains("order-service"), eq(OrderDto.class))).thenReturn(orderDto, OrderDto.builder().orderId(4).build());

        // When
        List<PaymentDto> result = paymentService.findAll();

        // Then
        assertNotNull(result);
        assertEquals(2, result.size());
        verify(paymentRepository, times(1)).findAll();
        verify(restTemplate, times(2)).getForObject(contains("order-service"), eq(OrderDto.class));
    }
}
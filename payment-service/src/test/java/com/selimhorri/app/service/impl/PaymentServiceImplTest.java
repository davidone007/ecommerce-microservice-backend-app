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

import com.selimhorri.app.domain.Payment;
import com.selimhorri.app.domain.PaymentStatus;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.PaymentDto;
import com.selimhorri.app.exception.wrapper.PaymentNotFoundException;
import com.selimhorri.app.repository.PaymentRepository;

@ExtendWith(MockitoExtension.class)
class PaymentServiceImplTest {

    @Mock
    private PaymentRepository paymentRepository;

    @Mock
    private RestTemplate restTemplate;

    @InjectMocks
    private PaymentServiceImpl paymentService;

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
                .orderDto(orderDto)
                .build();
        orderDto = OrderDto.builder().orderId(2).build();
    }

    @Test
    void testSave() {
        // Given
        when(paymentRepository.save(any(Payment.class))).thenReturn(payment);

        // When
        PaymentDto result = paymentService.save(paymentDto);

        // Then
        assertNotNull(result);
        assertEquals(paymentDto.getPaymentId(), result.getPaymentId());
        assertEquals(paymentDto.getIsPayed(), result.getIsPayed());
        assertEquals(paymentDto.getPaymentStatus(), result.getPaymentStatus());
        verify(paymentRepository, times(1)).save(any(Payment.class));
    }

    @Test
    void testUpdate() {
        // Given
        when(paymentRepository.save(any(Payment.class))).thenReturn(payment);

        // When
        PaymentDto result = paymentService.update(paymentDto);

        // Then
        assertNotNull(result);
        assertEquals(paymentDto.getPaymentId(), result.getPaymentId());
        verify(paymentRepository, times(1)).save(any(Payment.class));
    }

    @Test
    void testDeleteById() {
        // When
        paymentService.deleteById(1);

        // Then
        verify(paymentRepository, times(1)).deleteById(1);
    }

    @Test
    void testFindByIdThrowsExceptionWhenNotFound() {
        // Given
        when(paymentRepository.findById(1)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(PaymentNotFoundException.class, () -> paymentService.findById(1));
        verify(paymentRepository, times(1)).findById(1);
    }

    @Test
    void testSaveWithNullDto() {
        // When & Then
        assertThrows(NullPointerException.class, () -> paymentService.save(null));
    }
}
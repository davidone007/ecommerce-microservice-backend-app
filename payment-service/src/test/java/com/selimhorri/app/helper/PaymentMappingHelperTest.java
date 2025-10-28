package com.selimhorri.app.helper;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import com.selimhorri.app.domain.Payment;
import com.selimhorri.app.domain.PaymentStatus;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.PaymentDto;

class PaymentMappingHelperTest {

    @Test
    void testMapPaymentToDto() {
        // Given
        Payment payment = Payment.builder()
                .paymentId(1)
                .orderId(2)
                .isPayed(true)
                .paymentStatus(PaymentStatus.COMPLETED)
                .build();

        // When
        PaymentDto dto = PaymentMappingHelper.map(payment);

        // Then
        assertNotNull(dto);
        assertEquals(1, dto.getPaymentId());
        assertEquals(true, dto.getIsPayed());
        assertEquals(PaymentStatus.COMPLETED, dto.getPaymentStatus());
        assertNotNull(dto.getOrderDto());
        assertEquals(2, dto.getOrderDto().getOrderId());
    }

    @Test
    void testMapDtoToPayment() {
        // Given
        PaymentDto dto = PaymentDto.builder()
                .paymentId(1)
                .isPayed(true)
                .paymentStatus(PaymentStatus.COMPLETED)
                .orderDto(OrderDto.builder().orderId(2).build())
                .build();

        // When
        Payment payment = PaymentMappingHelper.map(dto);

        // Then
        assertNotNull(payment);
        assertEquals(1, payment.getPaymentId());
        assertEquals(2, payment.getOrderId());
        assertEquals(true, payment.getIsPayed());
        assertEquals(PaymentStatus.COMPLETED, payment.getPaymentStatus());
    }

    @Test
    void testMapPaymentToDtoWithNullValues() {
        // Given
        Payment payment = Payment.builder().build();

        // When
        PaymentDto dto = PaymentMappingHelper.map(payment);

        // Then
        assertNotNull(dto);
        assertNull(dto.getPaymentId());
        assertNull(dto.getIsPayed());
        assertNull(dto.getPaymentStatus());
    }

    @Test
    void testMapDtoToPaymentWithNullValues() {
        // Given
        PaymentDto dto = PaymentDto.builder().build();

        // When
        Payment payment = PaymentMappingHelper.map(dto);

        // Then
        assertNotNull(payment);
        assertNull(payment.getPaymentId());
        assertNull(payment.getOrderId());
        assertNull(payment.getIsPayed());
        assertNull(payment.getPaymentStatus());
    }

    @Test
    void testMapPaymentToDtoConsistency() {
        // Given
        Payment payment = Payment.builder()
                .paymentId(10)
                .orderId(20)
                .isPayed(false)
                .paymentStatus(PaymentStatus.NOT_STARTED)
                .build();

        // When
        PaymentDto dto = PaymentMappingHelper.map(payment);
        Payment backToPayment = PaymentMappingHelper.map(dto);

        // Then
        assertEquals(payment.getPaymentId(), backToPayment.getPaymentId());
        assertEquals(payment.getOrderId(), backToPayment.getOrderId());
        assertEquals(payment.getIsPayed(), backToPayment.getIsPayed());
        assertEquals(payment.getPaymentStatus(), backToPayment.getPaymentStatus());
    }
}
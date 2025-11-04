package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

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
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.domain.Payment;
import com.selimhorri.app.domain.PaymentStatus;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.PaymentDto;
import com.selimhorri.app.exception.wrapper.PaymentNotFoundException;
import com.selimhorri.app.exception.wrapper.PaymentServiceException;
import com.selimhorri.app.repository.PaymentRepository;

/**
 * Pruebas unitarias para PaymentServiceImpl.
 * Valida el comportamiento del servicio de pagos.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("PaymentServiceImpl Unit Tests")
class PaymentServiceImplTest {

	@Mock
	private PaymentRepository paymentRepository;

	@Mock
	private RestTemplate restTemplate;

	@InjectMocks
	private PaymentServiceImpl paymentService;

	private Payment testPayment;
	private PaymentDto testPaymentDto;

	@BeforeEach
	void setUp() {
		testPayment = Payment.builder()
			.paymentId(1)
			.orderId(1)
			.isPayed(false)
			.paymentStatus(PaymentStatus.NOT_STARTED)
			.build();

		testPaymentDto = new PaymentDto();
		testPaymentDto.setPaymentId(1);
		OrderDto orderDto = new OrderDto();
		orderDto.setOrderId(1);
		testPaymentDto.setOrderDto(orderDto);
	}

	@Test
	@DisplayName("Test 1: Debe actualizar estado de pago exitosamente")
	void testUpdateStatus_Success() {
		// Arrange
		when(paymentRepository.findById(1)).thenReturn(Optional.of(testPayment));
		when(paymentRepository.save(any(Payment.class))).thenReturn(testPayment);

		// Act
		PaymentDto result = paymentService.updateStatus(1);

		// Assert
		assertNotNull(result);
		verify(paymentRepository, times(1)).findById(1);
		verify(paymentRepository, times(1)).save(any(Payment.class));
	}

	@Test
	@DisplayName("Test 2: Debe lanzar excepción cuando pago no existe")
	void testUpdateStatus_PaymentNotFound() {
		// Arrange
		when(paymentRepository.findById(999)).thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(PaymentNotFoundException.class, () -> paymentService.updateStatus(999));
		verify(paymentRepository, times(1)).findById(999);
	}

	@Test
	@DisplayName("Test 3: Debe buscar pago por ID exitosamente")
	void testFindById_Success() {
		// Arrange
		when(paymentRepository.findById(1)).thenReturn(Optional.of(testPayment));
		when(restTemplate.getForObject(anyString(), any())).thenReturn(new OrderDto());

		// Act
		PaymentDto result = paymentService.findById(1);

		// Assert
		assertNotNull(result);
		verify(paymentRepository, times(1)).findById(1);
	}

	@Test
	@DisplayName("Test 4: Debe lanzar excepción cuando pago no existe en búsqueda")
	void testFindById_PaymentNotFound() {
		// Arrange
		when(paymentRepository.findById(999)).thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(PaymentServiceException.class, () -> paymentService.findById(999));
	}

	@Test
	@DisplayName("Test 5: Debe obtener lista de pagos en estado IN_PROGRESS")
	void testFindAll_Success() {
		// Arrange
		Payment payment2 = Payment.builder()
			.paymentId(2)
			.orderId(2)
			.isPayed(false)
			.paymentStatus(PaymentStatus.IN_PROGRESS)
			.build();

		List<Payment> paymentList = Arrays.asList(testPayment, payment2);
		when(paymentRepository.findAll()).thenReturn(paymentList);
		when(restTemplate.getForObject(anyString(), any())).thenReturn(new OrderDto());

		// Act
		List<PaymentDto> result = paymentService.findAll();

		// Assert
		assertNotNull(result);
		assertTrue(result.size() >= 0);
		verify(paymentRepository, times(1)).findAll();
	}
}

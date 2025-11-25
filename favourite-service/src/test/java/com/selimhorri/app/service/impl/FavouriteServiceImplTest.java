package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.domain.Favourite;
import com.selimhorri.app.domain.id.FavouriteId;
import com.selimhorri.app.dto.FavouriteDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.dto.UserDto;
import com.selimhorri.app.exception.wrapper.DuplicateEntityException;
import com.selimhorri.app.exception.wrapper.FavouriteNotFoundException;
import com.selimhorri.app.exception.wrapper.ProductNotFoundException;
import com.selimhorri.app.exception.wrapper.UserNotFoundException;
import com.selimhorri.app.repository.FavouriteRepository;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;

/**
 * Pruebas unitarias para FavouriteServiceImpl.
 * Valida el comportamiento del servicio de favoritos.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("FavouriteServiceImpl Unit Tests")
class FavouriteServiceImplTest {

	@Mock
	private FavouriteRepository favouriteRepository;

	@Mock
	private RestTemplate restTemplate;

	@Mock
	private MeterRegistry meterRegistry;

	@Mock
	private Counter counter;

	@InjectMocks
	private FavouriteServiceImpl favouriteService;

	private Favourite testFavourite;
	private FavouriteDto testFavouriteDto;
	private FavouriteId testFavouriteId;

	@BeforeEach
	void setUp() {
		testFavouriteId = new FavouriteId(1, 1, LocalDateTime.now());

		testFavourite = new Favourite();
		testFavourite.setUserId(1);
		testFavourite.setProductId(1);
		testFavourite.setLikeDate(LocalDateTime.now());

		testFavouriteDto = new FavouriteDto();
		testFavouriteDto.setUserId(1);
		testFavouriteDto.setProductId(1);
		testFavouriteDto.setLikeDate(LocalDateTime.now());

		// Mock MeterRegistry to return a counter (lenient because not all tests use it)
		lenient().when(meterRegistry.counter(anyString())).thenReturn(counter);
	}

	@Test
	@DisplayName("Test 1: Debe guardar un favorito exitosamente")
	void testSave_Success() {
		// Arrange
		UserDto userDto = new UserDto();
		ProductDto productDto = new ProductDto();

		when(restTemplate.getForEntity(anyString(), eq(UserDto.class)))
				.thenReturn(new ResponseEntity<>(userDto, HttpStatus.OK));
		when(restTemplate.getForEntity(anyString(), eq(ProductDto.class)))
				.thenReturn(new ResponseEntity<>(productDto, HttpStatus.OK));
		when(favouriteRepository.existsByUserIdAndProductId(1, 1)).thenReturn(false);
		when(favouriteRepository.save(any(Favourite.class))).thenReturn(testFavourite);

		// Act
		FavouriteDto result = favouriteService.save(testFavouriteDto);

		// Assert
		assertNotNull(result);
		verify(favouriteRepository, times(1)).save(any(Favourite.class));
	}

	@Test
	@DisplayName("Test 2: Debe lanzar excepción si favorito es duplicado")
	void testSave_DuplicateFavourite() {
		// Arrange
		UserDto userDto = new UserDto();
		ProductDto productDto = new ProductDto();

		when(restTemplate.getForEntity(anyString(), eq(UserDto.class)))
				.thenReturn(new ResponseEntity<>(userDto, HttpStatus.OK));
		when(restTemplate.getForEntity(anyString(), eq(ProductDto.class)))
				.thenReturn(new ResponseEntity<>(productDto, HttpStatus.OK));
		when(favouriteRepository.existsByUserIdAndProductId(1, 1)).thenReturn(true);

		// Act & Assert
		assertThrows(DuplicateEntityException.class, () -> favouriteService.save(testFavouriteDto));
	}

	@Test
	@DisplayName("Test 3: Debe buscar favorito por ID exitosamente")
	void testFindById_Success() {
		// Arrange
		when(favouriteRepository.findByUserIdAndProductId(1, 1))
				.thenReturn(Optional.of(testFavourite));
		when(restTemplate.getForObject(anyString(), eq(UserDto.class)))
				.thenReturn(new UserDto());
		when(restTemplate.getForObject(anyString(), eq(ProductDto.class)))
				.thenReturn(new ProductDto());

		// Act
		FavouriteDto result = favouriteService.findById(testFavouriteId);

		// Assert
		assertNotNull(result);
		verify(favouriteRepository, times(1)).findByUserIdAndProductId(1, 1);
	}

	@Test
	@DisplayName("Test 4: Debe lanzar excepción cuando favorito no existe")
	void testFindById_FavouriteNotFound() {
		// Arrange
		FavouriteId nonExistentId = new FavouriteId(999, 999, LocalDateTime.now());
		when(favouriteRepository.findByUserIdAndProductId(999, 999))
				.thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(FavouriteNotFoundException.class, () -> {
			favouriteService.findById(nonExistentId);
		});
	}

	@Test
	@DisplayName("Test 5: Debe obtener lista de todos los favoritos")
	void testFindAll_Success() {
		// Arrange
		Favourite favourite2 = new Favourite();
		favourite2.setUserId(2);
		favourite2.setProductId(2);
		favourite2.setLikeDate(LocalDateTime.now());

		List<Favourite> favouriteList = Arrays.asList(testFavourite, favourite2);
		when(favouriteRepository.findAll()).thenReturn(favouriteList);
		when(restTemplate.getForObject(anyString(), any())).thenReturn(new UserDto());

		// Act
		List<FavouriteDto> result = favouriteService.findAll();

		// Assert
		assertNotNull(result);
		verify(favouriteRepository, times(1)).findAll();
	}
}

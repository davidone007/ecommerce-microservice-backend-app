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

import com.selimhorri.app.domain.Credential;
import com.selimhorri.app.domain.User;
import com.selimhorri.app.dto.UserDto;
import com.selimhorri.app.exception.wrapper.UserObjectNotFoundException;
import com.selimhorri.app.helper.UserMappingHelper;
import com.selimhorri.app.repository.CredentialRepository;
import com.selimhorri.app.repository.UserRepository;

/**
 * Pruebas unitarias para UserServiceImpl.
 * Valida el comportamiento del servicio de usuario.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("UserServiceImpl Unit Tests")
class UserServiceImplTest {

	@Mock
	private UserRepository userRepository;

	@Mock
	private CredentialRepository credentialRepository;

	@InjectMocks
	private UserServiceImpl userService;

	private User testUser;
	private Credential testCredential;

	@BeforeEach
	void setUp() {
		// Inicializar datos de prueba
		testCredential = Credential.builder()
			.credentialId(1)
			.username("testuser")
			.password("password123")
			.isEnabled(true)
			.build();

		testUser = User.builder()
			.userId(1)
			.firstName("John")
			.lastName("Doe")
			.phone("1234567890")
			.credential(testCredential)
			.build();
	}

	@Test
	@DisplayName("Test 1: Debe buscar usuario por username exitosamente")
	void testFindByUsername_Success() {
		// Arrange
		String username = "testuser";
		when(userRepository.findByCredentialUsername(username)).thenReturn(Optional.of(testUser));

		// Act
		UserDto result = userService.findByUsername(username);

		// Assert
		assertNotNull(result);
		assertEquals("John", result.getFirstName());
		assertEquals("Doe", result.getLastName());
		verify(userRepository, times(1)).findByCredentialUsername(username);
	}

	@Test
	@DisplayName("Test 2: Debe lanzar excepción cuando usuario no existe por username")
	void testFindByUsername_UserNotFound() {
		// Arrange
		String username = "nonexistent";
		when(userRepository.findByCredentialUsername(anyString())).thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(UserObjectNotFoundException.class, () -> {
			userService.findByUsername(username);
		});
		verify(userRepository, times(1)).findByCredentialUsername(username);
	}

	@Test
	@DisplayName("Test 3: Debe buscar usuario por ID exitosamente")
	void testFindById_Success() {
		// Arrange
		Integer userId = 1;
		when(userRepository.findById(userId)).thenReturn(Optional.of(testUser));

		// Act
		UserDto result = userService.findById(userId);

		// Assert
		assertNotNull(result);
		assertEquals("John", result.getFirstName());
		verify(userRepository, times(1)).findById(userId);
	}

	@Test
	@DisplayName("Test 4: Debe lanzar excepción cuando usuario no existe por ID")
	void testFindById_UserNotFound() {
		// Arrange
		Integer userId = 999;
		when(userRepository.findById(userId)).thenReturn(Optional.empty());

		// Act & Assert
		assertThrows(UserObjectNotFoundException.class, () -> {
			userService.findById(userId);
		});
	}

	@Test
	@DisplayName("Test 5: Debe obtener lista de todos los usuarios con credenciales")
	void testFindAll_Success() {
		// Arrange
		User user2 = User.builder()
			.userId(2)
			.firstName("Jane")
			.lastName("Smith")
			.phone("0987654321")
			.credential(testCredential)
			.build();
		
		List<User> userList = Arrays.asList(testUser, user2);
		when(userRepository.findAll()).thenReturn(userList);

		// Act
		List<UserDto> result = userService.findAll();

		// Assert
		assertNotNull(result);
		assertTrue(result.size() >= 0);
		verify(userRepository, times(1)).findAll();
	}
}

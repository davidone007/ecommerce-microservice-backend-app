package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Collections;
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
import com.selimhorri.app.domain.RoleBasedAuthority;
import com.selimhorri.app.domain.User;
import com.selimhorri.app.dto.CredentialDto;
import com.selimhorri.app.dto.UserDto;
import com.selimhorri.app.exception.wrapper.UserObjectNotFoundException;
import com.selimhorri.app.repository.UserRepository;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTest {
	
	@Mock
	private UserRepository userRepository;
	
	@InjectMocks
	private UserServiceImpl userService;
	
	private User user;
	private UserDto userDto;
	
	@BeforeEach
	void setUp() {
		final var credential = Credential.builder()
				.credentialId(1)
				.username("testuser")
				.password("password123")
				.roleBasedAuthority(RoleBasedAuthority.ROLE_USER)
				.isEnabled(true)
				.isAccountNonExpired(true)
				.isAccountNonLocked(true)
				.isCredentialsNonExpired(true)
				.build();
		
		this.user = User.builder()
				.userId(1)
				.firstName("John")
				.lastName("Doe")
				.imageUrl("http://example.com/image.jpg")
				.email("john.doe@example.com")
				.phone("1234567890")
				.credential(credential)
				.build();
		
		this.userDto = UserDto.builder()
				.userId(1)
				.firstName("John")
				.lastName("Doe")
				.imageUrl("http://example.com/image.jpg")
				.email("john.doe@example.com")
				.phone("1234567890")
				.credentialDto(CredentialDto.builder()
						.credentialId(1)
						.username("testuser")
						.password("password123")
						.roleBasedAuthority(RoleBasedAuthority.ROLE_USER)
						.isEnabled(true)
						.isAccountNonExpired(true)
						.isAccountNonLocked(true)
						.isCredentialsNonExpired(true)
						.build())
				.build();
	}
	
	@Test
	@DisplayName("Should return all users")
	void shouldReturnAllUsers() {
		// Given
		when(this.userRepository.findAll()).thenReturn(List.of(this.user));
		
		// When
		final var result = this.userService.findAll();
		
		// Then
		assertNotNull(result);
		assertEquals(1, result.size());
		verify(this.userRepository).findAll();
	}
	
	@Test
	@DisplayName("Should return user by id")
	void shouldReturnUserById() {
		// Given
		when(this.userRepository.findById(anyInt())).thenReturn(Optional.of(this.user));
		
		// When
		final var result = this.userService.findById(1);
		
		// Then
		assertNotNull(result);
		assertEquals(this.user.getUserId(), result.getUserId());
		verify(this.userRepository).findById(1);
	}
	
	@Test
	@DisplayName("Should throw exception when user not found by id")
	void shouldThrowExceptionWhenUserNotFoundById() {
		// Given
		when(this.userRepository.findById(anyInt())).thenReturn(Optional.empty());
		
		// When & Then
		assertThrows(UserObjectNotFoundException.class, () -> this.userService.findById(1));
		verify(this.userRepository).findById(1);
	}
	
	@Test
	@DisplayName("Should save user")
	void shouldSaveUser() {
		// Given
		when(this.userRepository.save(any(User.class))).thenReturn(this.user);
		
		// When
		final var result = this.userService.save(this.userDto);
		
		// Then
		assertNotNull(result);
		assertEquals(this.user.getUserId(), result.getUserId());
		verify(this.userRepository).save(any(User.class));
	}
	
	@Test
	@DisplayName("Should update user")
	void shouldUpdateUser() {
		// Given
		when(this.userRepository.save(any(User.class))).thenReturn(this.user);
		
		// When
		final var result = this.userService.update(this.userDto);
		
		// Then
		assertNotNull(result);
		assertEquals(this.user.getUserId(), result.getUserId());
		verify(this.userRepository).save(any(User.class));
	}
	
	@Test
	@DisplayName("Should update user by id")
	void shouldUpdateUserById() {
		// Given
		when(this.userRepository.findById(anyInt())).thenReturn(Optional.of(this.user));
		when(this.userRepository.save(any(User.class))).thenReturn(this.user);
		
		// When
		final var result = this.userService.update(1, this.userDto);
		
		// Then
		assertNotNull(result);
		assertEquals(this.user.getUserId(), result.getUserId());
		verify(this.userRepository).findById(1);
		verify(this.userRepository).save(any(User.class));
	}
	
	@Test
	@DisplayName("Should delete user by id")
	void shouldDeleteUserById() {
		// When
		this.userService.deleteById(1);
		
		// Then
		verify(this.userRepository).deleteById(1);
	}
	
	@Test
	@DisplayName("Should return user by username")
	void shouldReturnUserByUsername() {
		// Given
		when(this.userRepository.findByCredential_Username(anyString())).thenReturn(Optional.of(this.user));
		
		// When
		final var result = this.userService.findByUsername("testuser");
		
		// Then
		assertNotNull(result);
		assertEquals(this.user.getUserId(), result.getUserId());
		verify(this.userRepository).findByCredential_Username("testuser");
	}
	
	@Test
	@DisplayName("Should throw exception when user not found by username")
	void shouldThrowExceptionWhenUserNotFoundByUsername() {
		// Given
		when(this.userRepository.findByCredential_Username(anyString())).thenReturn(Optional.empty());
		
		// When & Then
		assertThrows(UserObjectNotFoundException.class, () -> this.userService.findByUsername("testuser"));
		verify(this.userRepository).findByCredential_Username("testuser");
	}
	
}
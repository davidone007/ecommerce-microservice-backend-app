package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.List;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase.Replace;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import com.selimhorri.app.domain.RoleBasedAuthority;
import com.selimhorri.app.dto.UserDto;
import com.selimhorri.app.exception.wrapper.UserObjectNotFoundException;

@SpringBootTest
@ActiveProfiles("test")
@AutoConfigureTestDatabase(replace = Replace.NONE)
class UserServiceIntegrationTest {
	
	@Autowired
	private UserServiceImpl userService;
	
	@Test
	@DisplayName("Should return all users from database")
	void testFindAll() {
		// When
		final var result = this.userService.findAll();
		
		// Then
		assertNotNull(result);
		// Debug: print users
		System.out.println("Users in database:");
		result.forEach(user -> System.out.println("ID: " + user.getUserId() + ", Username: " + user.getCredentialDto().getUsername()));
	}
	
	@Test
	@DisplayName("Should return user by id from database")
	void testFindById() {
		// When
		final var result = this.userService.findById(1);
		
		// Then
		assertNotNull(result);
		assertEquals(1, result.getUserId());
	}
	
	@Test
	@DisplayName("Should throw exception when user not found by id")
	void testFindByIdNotFound() {
		// When & Then
		assertThrows(UserObjectNotFoundException.class, () -> this.userService.findById(999));
	}
	
	@Test
	@DisplayName("Should save user to database")
	void testSave() {
		// Given
		final var credentialDto = com.selimhorri.app.dto.CredentialDto.builder()
				.username("newsuer")
				.password("password123")
				.roleBasedAuthority(RoleBasedAuthority.ROLE_USER)
				.isEnabled(true)
				.isAccountNonExpired(true)
				.isAccountNonLocked(true)
				.isCredentialsNonExpired(true)
				.build();
		
		final var userDto = UserDto.builder()
				.firstName("New")
				.lastName("User")
				.imageUrl("http://example.com/image.jpg")
				.email("new.user@example.com")
				.phone("1234567890")
				.credentialDto(credentialDto)
				.build();
		
		// When
		final var result = this.userService.save(userDto);
		
		// Then
		assertNotNull(result);
		assertNotNull(result.getUserId());
		assertEquals("New", result.getFirstName());
		assertEquals("User", result.getLastName());
	}
	
	@Test
	@DisplayName("Should update user in database")
	void testUpdate() {
		// Given
		final var existingUser = this.userService.findById(1);
		final var updatedUserDto = UserDto.builder()
				.userId(existingUser.getUserId())
				.firstName("Updated")
				.lastName("Name")
				.imageUrl(existingUser.getImageUrl())
				.email(existingUser.getEmail())
				.phone(existingUser.getPhone())
				.credentialDto(existingUser.getCredentialDto())
				.build();
		
		// When
		final var result = this.userService.update(updatedUserDto);
		
		// Then
		assertNotNull(result);
		assertEquals("Updated", result.getFirstName());
		assertEquals("Name", result.getLastName());
	}
	
	@Test
	@DisplayName("Should update user by id in database")
	void testUpdateById() {
		// Given
		final var updatedUserDto = UserDto.builder()
				.firstName("UpdatedById")
				.lastName("User")
				.imageUrl("http://example.com/image.jpg")
				.email("updated@example.com")
				.phone("1234567890")
				.build();
		
		// When
		final var result = this.userService.update(1, updatedUserDto);
		
		// Then
		assertNotNull(result);
		assertEquals(1, result.getUserId());
	}
	
	@Test
	@DisplayName("Should delete user by id from database")
	void testDeleteById() {
		// Given - assuming user with id 2 exists
		this.userService.findById(2); // This will throw if not exists
		
		// When
		this.userService.deleteById(2);
		
		// Then
		assertThrows(UserObjectNotFoundException.class, () -> this.userService.findById(2));
	}
	
	@Test
	@DisplayName("Should return user by username from database")
	void testFindByUsername() {
		// When
		final var result = this.userService.findByUsername("selimhorri");
		
		// Then
		assertNotNull(result);
		assertEquals("selimhorri", result.getCredentialDto().getUsername());
	}
	
	@Test
	@DisplayName("Should throw exception when user not found by username")
	void testFindByUsernameNotFound() {
		// When & Then
		assertThrows(UserObjectNotFoundException.class, () -> this.userService.findByUsername("nonexistent"));
	}
	
}
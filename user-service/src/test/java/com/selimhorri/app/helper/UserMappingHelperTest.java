package com.selimhorri.app.helper;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.selimhorri.app.domain.Credential;
import com.selimhorri.app.domain.RoleBasedAuthority;
import com.selimhorri.app.domain.User;
import com.selimhorri.app.dto.CredentialDto;
import com.selimhorri.app.dto.UserDto;

class UserMappingHelperTest {
	
	@Test
	@DisplayName("Should map User entity to UserDto")
	void shouldMapUserToUserDto() {
		// Given
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
		
		final var user = User.builder()
				.userId(1)
				.firstName("John")
				.lastName("Doe")
				.imageUrl("http://example.com/image.jpg")
				.email("john.doe@example.com")
				.phone("1234567890")
				.credential(credential)
				.build();
		
		// When
		final var userDto = UserMappingHelper.map(user);
		
		// Then
		assertNotNull(userDto);
		assertEquals(user.getUserId(), userDto.getUserId());
		assertEquals(user.getFirstName(), userDto.getFirstName());
		assertEquals(user.getLastName(), userDto.getLastName());
		assertEquals(user.getImageUrl(), userDto.getImageUrl());
		assertEquals(user.getEmail(), userDto.getEmail());
		assertEquals(user.getPhone(), userDto.getPhone());
		assertNotNull(userDto.getCredentialDto());
		assertEquals(credential.getCredentialId(), userDto.getCredentialDto().getCredentialId());
		assertEquals(credential.getUsername(), userDto.getCredentialDto().getUsername());
		assertEquals(credential.getPassword(), userDto.getCredentialDto().getPassword());
		assertEquals(credential.getRoleBasedAuthority(), userDto.getCredentialDto().getRoleBasedAuthority());
		assertEquals(credential.getIsEnabled(), userDto.getCredentialDto().getIsEnabled());
		assertEquals(credential.getIsAccountNonExpired(), userDto.getCredentialDto().getIsAccountNonExpired());
		assertEquals(credential.getIsAccountNonLocked(), userDto.getCredentialDto().getIsAccountNonLocked());
		assertEquals(credential.getIsCredentialsNonExpired(), userDto.getCredentialDto().getIsCredentialsNonExpired());
	}
	
	@Test
	@DisplayName("Should map UserDto to User entity")
	void shouldMapUserDtoToUser() {
		// Given
		final var credentialDto = CredentialDto.builder()
				.credentialId(1)
				.username("testuser")
				.password("password123")
				.roleBasedAuthority(RoleBasedAuthority.ROLE_USER)
				.isEnabled(true)
				.isAccountNonExpired(true)
				.isAccountNonLocked(true)
				.isCredentialsNonExpired(true)
				.build();
		
		final var userDto = UserDto.builder()
				.userId(1)
				.firstName("John")
				.lastName("Doe")
				.imageUrl("http://example.com/image.jpg")
				.email("john.doe@example.com")
				.phone("1234567890")
				.credentialDto(credentialDto)
				.build();
		
		// When
		final var user = UserMappingHelper.map(userDto);
		
		// Then
		assertNotNull(user);
		assertEquals(userDto.getUserId(), user.getUserId());
		assertEquals(userDto.getFirstName(), user.getFirstName());
		assertEquals(userDto.getLastName(), user.getLastName());
		assertEquals(userDto.getImageUrl(), user.getImageUrl());
		assertEquals(userDto.getEmail(), user.getEmail());
		assertEquals(userDto.getPhone(), user.getPhone());
		assertNotNull(user.getCredential());
		assertEquals(credentialDto.getCredentialId(), user.getCredential().getCredentialId());
		assertEquals(credentialDto.getUsername(), user.getCredential().getUsername());
		assertEquals(credentialDto.getPassword(), user.getCredential().getPassword());
		assertEquals(credentialDto.getRoleBasedAuthority(), user.getCredential().getRoleBasedAuthority());
		assertEquals(credentialDto.getIsEnabled(), user.getCredential().getIsEnabled());
		assertEquals(credentialDto.getIsAccountNonExpired(), user.getCredential().getIsAccountNonExpired());
		assertEquals(credentialDto.getIsAccountNonLocked(), user.getCredential().getIsAccountNonLocked());
		assertEquals(credentialDto.getIsCredentialsNonExpired(), user.getCredential().getIsCredentialsNonExpired());
	}
	
	@Test
	@DisplayName("Should handle null values in mapping")
	void shouldHandleNullValuesInMapping() {
		// Given
		final var user = User.builder()
				.userId(1)
				.firstName(null)
				.lastName(null)
				.imageUrl(null)
				.email(null)
				.phone(null)
				.credential(null)
				.build();
		
		// When
		final var userDto = UserMappingHelper.map(user);
		
		// Then
		assertNotNull(userDto);
		assertEquals(user.getUserId(), userDto.getUserId());
		assertEquals(user.getFirstName(), userDto.getFirstName());
		assertEquals(user.getLastName(), userDto.getLastName());
		assertEquals(user.getImageUrl(), userDto.getImageUrl());
		assertEquals(user.getEmail(), userDto.getEmail());
		assertEquals(user.getPhone(), userDto.getPhone());
		assertNull(userDto.getCredentialDto());
	}
	
}
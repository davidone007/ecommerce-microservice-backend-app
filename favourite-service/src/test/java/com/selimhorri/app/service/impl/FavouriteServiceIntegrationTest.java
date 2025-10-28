package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.FavouriteServiceApplication;
import com.selimhorri.app.domain.Favourite;
import com.selimhorri.app.domain.id.FavouriteId;
import com.selimhorri.app.dto.FavouriteDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.dto.UserDto;
import com.selimhorri.app.repository.FavouriteRepository;
import com.selimhorri.app.service.FavouriteService;

@SpringBootTest(classes = FavouriteServiceApplication.class)
class FavouriteServiceIntegrationTest {

    @Autowired
    private FavouriteService favouriteService;

    @MockBean
    private FavouriteRepository favouriteRepository;

    @MockBean
    private RestTemplate restTemplate;

    private Favourite favourite;
    private FavouriteDto favouriteDto;
    private FavouriteId favouriteId;
    private UserDto userDto;
    private ProductDto productDto;

    @BeforeEach
    void setUp() {
        LocalDateTime likeDate = LocalDateTime.now();
        favouriteId = new FavouriteId(1, 2, likeDate);
        favourite = Favourite.builder()
                .userId(1)
                .productId(2)
                .likeDate(likeDate)
                .build();
        favouriteDto = FavouriteDto.builder()
                .userId(1)
                .productId(2)
                .likeDate(likeDate)
                .build();
        userDto = UserDto.builder().userId(1).build();
        productDto = ProductDto.builder().productId(2).build();
    }

    @Test
    void testFindAllIntegration() {
        // Given
        when(favouriteRepository.findAll()).thenReturn(List.of(favourite));
        when(restTemplate.getForObject(anyString(), eq(UserDto.class))).thenReturn(userDto);
        when(restTemplate.getForObject(anyString(), eq(ProductDto.class))).thenReturn(productDto);

        // When
        List<FavouriteDto> result = favouriteService.findAll();

        // Then
        assertNotNull(result);
        assertEquals(1, result.size());
        FavouriteDto dto = result.get(0);
        assertEquals(1, dto.getUserId());
        assertEquals(2, dto.getProductId());
        assertNotNull(dto.getUserDto());
        assertNotNull(dto.getProductDto());
        verify(favouriteRepository, times(1)).findAll();
        verify(restTemplate, times(1)).getForObject(contains("user-service"), eq(UserDto.class));
        verify(restTemplate, times(1)).getForObject(contains("product-service"), eq(ProductDto.class));
    }

    @Test
    void testFindByIdIntegration() {
        // Given
        when(favouriteRepository.findById(favouriteId)).thenReturn(Optional.of(favourite));
        when(restTemplate.getForObject(anyString(), eq(UserDto.class))).thenReturn(userDto);
        when(restTemplate.getForObject(anyString(), eq(ProductDto.class))).thenReturn(productDto);

        // When
        FavouriteDto result = favouriteService.findById(favouriteId);

        // Then
        assertNotNull(result);
        assertEquals(1, result.getUserId());
        assertEquals(2, result.getProductId());
        assertNotNull(result.getUserDto());
        assertNotNull(result.getProductDto());
        verify(favouriteRepository, times(1)).findById(favouriteId);
        verify(restTemplate, times(1)).getForObject(contains("user-service"), eq(UserDto.class));
        verify(restTemplate, times(1)).getForObject(contains("product-service"), eq(ProductDto.class));
    }

    @Test
    void testFindAllWithEmptyList() {
        // Given
        when(favouriteRepository.findAll()).thenReturn(List.of());

        // When
        List<FavouriteDto> result = favouriteService.findAll();

        // Then
        assertNotNull(result);
        assertTrue(result.isEmpty());
        verify(favouriteRepository, times(1)).findAll();
        verify(restTemplate, never()).getForObject(anyString(), any());
    }

    @Test
    void testFindByIdWithRestTemplateFailure() {
        // Given
        when(favouriteRepository.findById(favouriteId)).thenReturn(Optional.of(favourite));
        when(restTemplate.getForObject(anyString(), eq(UserDto.class))).thenThrow(new RuntimeException("Service unavailable"));

        // When & Then
        assertThrows(RuntimeException.class, () -> favouriteService.findById(favouriteId));
        verify(favouriteRepository, times(1)).findById(favouriteId);
        verify(restTemplate, times(1)).getForObject(anyString(), eq(UserDto.class));
    }

    @Test
    void testFindAllWithMultipleFavourites() {
        // Given
        Favourite favourite2 = Favourite.builder()
                .userId(3)
                .productId(4)
                .likeDate(LocalDateTime.now())
                .build();
        when(favouriteRepository.findAll()).thenReturn(List.of(favourite, favourite2));
        when(restTemplate.getForObject(contains("user-service"), eq(UserDto.class))).thenReturn(userDto, UserDto.builder().userId(3).build());
        when(restTemplate.getForObject(contains("product-service"), eq(ProductDto.class))).thenReturn(productDto, ProductDto.builder().productId(4).build());

        // When
        List<FavouriteDto> result = favouriteService.findAll();

        // Then
        assertNotNull(result);
        assertEquals(2, result.size());
        verify(favouriteRepository, times(1)).findAll();
        verify(restTemplate, times(2)).getForObject(contains("user-service"), eq(UserDto.class));
        verify(restTemplate, times(2)).getForObject(contains("product-service"), eq(ProductDto.class));
    }
}
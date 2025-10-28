package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.domain.Favourite;
import com.selimhorri.app.domain.id.FavouriteId;
import com.selimhorri.app.dto.FavouriteDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.dto.UserDto;
import com.selimhorri.app.exception.wrapper.FavouriteNotFoundException;
import com.selimhorri.app.repository.FavouriteRepository;

@ExtendWith(MockitoExtension.class)
class FavouriteServiceImplTest {

    @Mock
    private FavouriteRepository favouriteRepository;

    @Mock
    private RestTemplate restTemplate;

    @InjectMocks
    private FavouriteServiceImpl favouriteService;

    private Favourite favourite;
    private FavouriteDto favouriteDto;
    private FavouriteId favouriteId;

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
    }

    @Test
    void testSave() {
        // Given
        when(favouriteRepository.save(any(Favourite.class))).thenReturn(favourite);

        // When
        FavouriteDto result = favouriteService.save(favouriteDto);

        // Then
        assertNotNull(result);
        assertEquals(favouriteDto.getUserId(), result.getUserId());
        assertEquals(favouriteDto.getProductId(), result.getProductId());
        assertEquals(favouriteDto.getLikeDate(), result.getLikeDate());
        verify(favouriteRepository, times(1)).save(any(Favourite.class));
    }

    @Test
    void testUpdate() {
        // Given
        when(favouriteRepository.save(any(Favourite.class))).thenReturn(favourite);

        // When
        FavouriteDto result = favouriteService.update(favouriteDto);

        // Then
        assertNotNull(result);
        assertEquals(favouriteDto.getUserId(), result.getUserId());
        assertEquals(favouriteDto.getProductId(), result.getProductId());
        assertEquals(favouriteDto.getLikeDate(), result.getLikeDate());
        verify(favouriteRepository, times(1)).save(any(Favourite.class));
    }

    @Test
    void testDeleteById() {
        // When
        favouriteService.deleteById(favouriteId);

        // Then
        verify(favouriteRepository, times(1)).deleteById(favouriteId);
    }

    @Test
    void testFindByIdThrowsExceptionWhenNotFound() {
        // Given
        when(favouriteRepository.findById(favouriteId)).thenReturn(Optional.empty());

        // When & Then
        assertThrows(FavouriteNotFoundException.class, () -> favouriteService.findById(favouriteId));
        verify(favouriteRepository, times(1)).findById(favouriteId);
    }

    @Test
    void testSaveWithNullDto() {
        // When & Then
        assertThrows(NullPointerException.class, () -> favouriteService.save(null));
    }
}
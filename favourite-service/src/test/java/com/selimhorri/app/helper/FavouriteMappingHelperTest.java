package com.selimhorri.app.helper;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;

import com.selimhorri.app.domain.Favourite;
import com.selimhorri.app.dto.FavouriteDto;

class FavouriteMappingHelperTest {

    @Test
    void testMapFavouriteToDto() {
        // Given
        LocalDateTime likeDate = LocalDateTime.now();
        Favourite favourite = Favourite.builder()
                .userId(1)
                .productId(2)
                .likeDate(likeDate)
                .build();

        // When
        FavouriteDto dto = FavouriteMappingHelper.map(favourite);

        // Then
        assertNotNull(dto);
        assertEquals(1, dto.getUserId());
        assertEquals(2, dto.getProductId());
        assertEquals(likeDate, dto.getLikeDate());
        assertNotNull(dto.getUserDto());
        assertEquals(1, dto.getUserDto().getUserId());
        assertNotNull(dto.getProductDto());
        assertEquals(2, dto.getProductDto().getProductId());
    }

    @Test
    void testMapDtoToFavourite() {
        // Given
        LocalDateTime likeDate = LocalDateTime.now();
        FavouriteDto dto = FavouriteDto.builder()
                .userId(1)
                .productId(2)
                .likeDate(likeDate)
                .build();

        // When
        Favourite favourite = FavouriteMappingHelper.map(dto);

        // Then
        assertNotNull(favourite);
        assertEquals(1, favourite.getUserId());
        assertEquals(2, favourite.getProductId());
        assertEquals(likeDate, favourite.getLikeDate());
    }

    @Test
    void testMapFavouriteToDtoWithNullValues() {
        // Given
        Favourite favourite = Favourite.builder().build();

        // When
        FavouriteDto dto = FavouriteMappingHelper.map(favourite);

        // Then
        assertNotNull(dto);
        assertNull(dto.getUserId());
        assertNull(dto.getProductId());
        assertNull(dto.getLikeDate());
    }

    @Test
    void testMapDtoToFavouriteWithNullValues() {
        // Given
        FavouriteDto dto = FavouriteDto.builder().build();

        // When
        Favourite favourite = FavouriteMappingHelper.map(dto);

        // Then
        assertNotNull(favourite);
        assertNull(favourite.getUserId());
        assertNull(favourite.getProductId());
        assertNull(favourite.getLikeDate());
    }

    @Test
    void testMapFavouriteToDtoConsistency() {
        // Given
        LocalDateTime likeDate = LocalDateTime.of(2023, 10, 28, 12, 0);
        Favourite favourite = Favourite.builder()
                .userId(10)
                .productId(20)
                .likeDate(likeDate)
                .build();

        // When
        FavouriteDto dto = FavouriteMappingHelper.map(favourite);
        Favourite backToFavourite = FavouriteMappingHelper.map(dto);

        // Then
        assertEquals(favourite.getUserId(), backToFavourite.getUserId());
        assertEquals(favourite.getProductId(), backToFavourite.getProductId());
        assertEquals(favourite.getLikeDate(), backToFavourite.getLikeDate());
    }
}
package com.selimhorri.app.helper;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.domain.Product;
import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;

public interface ProductMappingHelper {
	
	public static ProductDto map(final Product product) {
		return ProductDto.builder()
				.productId(product.getProductId())
				.productTitle(product.getProductTitle())
				.imageUrl(product.getImageUrl())
				.sku(product.getSku())
				.priceUnit(product.getPriceUnit())
				.quantity(product.getQuantity())
				.categoryDto(
						CategoryDto.builder()
							.categoryId(product.getCategory().getCategoryId())
							.categoryTitle(product.getCategory().getCategoryTitle())
							.imageUrl(product.getCategory().getImageUrl())
							.build())
				.build();
	}
	
	public static Product map(final ProductDto productDto) {
		Category.CategoryBuilder categoryBuilder = Category.builder()
				.categoryId(productDto.getCategoryDto().getCategoryId());
		
		// Solo agregar categoryTitle e imageUrl si no son null
		if (productDto.getCategoryDto().getCategoryTitle() != null) {
			categoryBuilder.categoryTitle(productDto.getCategoryDto().getCategoryTitle());
		}
		if (productDto.getCategoryDto().getImageUrl() != null) {
			categoryBuilder.imageUrl(productDto.getCategoryDto().getImageUrl());
		}
		
		return Product.builder()
				.productId(productDto.getProductId())
				.productTitle(productDto.getProductTitle())
				.imageUrl(productDto.getImageUrl())
				.sku(productDto.getSku())
				.priceUnit(productDto.getPriceUnit())
				.quantity(productDto.getQuantity())
				.category(categoryBuilder.build())
				.build();
	}
	
	
	
}











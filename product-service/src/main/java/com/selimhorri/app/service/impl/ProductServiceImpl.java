package com.selimhorri.app.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.domain.Product;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.CategoryNotFoundException;
import com.selimhorri.app.exception.wrapper.ProductNotFoundException;
import com.selimhorri.app.helper.ProductMappingHelper;
import com.selimhorri.app.repository.CategoryRepository;
import com.selimhorri.app.repository.ProductRepository;
import com.selimhorri.app.service.ProductService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Transactional
@Slf4j
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

	private final ProductRepository productRepository;
	private final CategoryRepository categoryRepository;

	@Override
	public List<ProductDto> findAll() {
		log.info("*** ProductDto List, service; fetch all products *");
		return this.productRepository.findAllWithoutDeleted()
				.stream()
				.map(ProductMappingHelper::map)
				.distinct()
				.collect(Collectors.toUnmodifiableList());
	}

	@Override
	public ProductDto findById(final Integer productId) {
		log.info("*** ProductDto, service; fetch product by id *");
		return this.productRepository.findByIdWithoutDeleted(productId)
				.map(ProductMappingHelper::map)
				.orElseThrow(
						() -> new ProductNotFoundException(String.format("Product with id: %d not found", productId)));
	}

	@Override
	public ProductDto save(final ProductDto productDto) {
		log.info("*** ProductDto, service; save product *");

		// Validación de campos obligatorios
		if (productDto.getProductTitle() == null || productDto.getProductTitle().isEmpty()) {
			throw new IllegalArgumentException("El título del producto es requerido");
		}

		if (productDto.getImageUrl() == null || productDto.getImageUrl().isEmpty()) {
			throw new IllegalArgumentException("La URL de la imagen es requerida");
		}

		if (productDto.getSku() == null || productDto.getSku().isEmpty()) {
			throw new IllegalArgumentException("El SKU es requerido");
		}

		if (productDto.getPriceUnit() == null) {
			throw new IllegalArgumentException("El precio unitario es requerido");
		}

		if (productDto.getQuantity() == null) {
			throw new IllegalArgumentException("La cantidad es requerida");
		}

		if (productDto.getCategoryDto() == null || productDto.getCategoryDto().getCategoryId() == null) {
			throw new IllegalArgumentException("La categoría es requerida");
		}

		// Validar que la categoría exista (usando Integer como ID)
		Integer categoryId = productDto.getCategoryDto().getCategoryId();
		categoryRepository.findById(categoryId)
				.orElseThrow(() -> new CategoryNotFoundException("Categoría no encontrada con ID: " + categoryId));

		productDto.setProductId(null);
		return ProductMappingHelper.map(this.productRepository
				.save(ProductMappingHelper.map(productDto)));
	}

	@Override
	public ProductDto update(final ProductDto productDto) {
		log.info("*** ProductDto, service; update product *");

		// Validar que el producto exista
		if (productDto.getProductId() == null || !productRepository.existsById(productDto.getProductId())) {
			throw new ProductNotFoundException("Producto no encontrado con ID: " + productDto.getProductId());
		}

		return ProductMappingHelper.map(this.productRepository
				.save(ProductMappingHelper.map(productDto)));
	}

	@Override
	public ProductDto update(final Integer productId, final ProductDto productDto) {
		log.info("*** ProductDto, service; update product with productId *");

		// Verificar que el producto exista
		Product existingProduct = productRepository.findById(productId)
				.orElseThrow(() -> new ProductNotFoundException("Producto no encontrado con ID: " + productId));

		// Actualizar los campos del producto existente
		if (productDto.getProductTitle() != null) {
			existingProduct.setProductTitle(productDto.getProductTitle());
		}
		if (productDto.getImageUrl() != null) {
			existingProduct.setImageUrl(productDto.getImageUrl());
		}
		if (productDto.getSku() != null) {
			existingProduct.setSku(productDto.getSku());
		}
		if (productDto.getPriceUnit() != null) {
			existingProduct.setPriceUnit(productDto.getPriceUnit());
		}
		if (productDto.getQuantity() != null) {
			existingProduct.setQuantity(productDto.getQuantity());
		}
		
		// Solo actualizar la categoría si se proporciona un categoryId diferente
		if (productDto.getCategoryDto() != null && productDto.getCategoryDto().getCategoryId() != null) {
			Integer newCategoryId = productDto.getCategoryDto().getCategoryId();
			if (!existingProduct.getCategory().getCategoryId().equals(newCategoryId)) {
				Category newCategory = categoryRepository.findById(newCategoryId)
						.orElseThrow(() -> new RuntimeException("Category with id: " + newCategoryId + " not found"));
				existingProduct.setCategory(newCategory);
			}
		}

		return ProductMappingHelper.map(this.productRepository.save(existingProduct));
	}

	@Override
	public void deleteById(final Integer productId) {
		log.info("*** Void, service; soft delete product by id *");

		// 1. Verificar si el producto existe
		Product product = this.productRepository.findByIdWithoutDeleted(productId)
				.orElseThrow(() -> new ProductNotFoundException("Product with id: " + productId + " not found"));

		// 2. Buscar la categoría "Deleted"
		Category deletedCategory = this.categoryRepository.findByCategoryTitle("Deleted")
				.orElseThrow(() -> new RuntimeException("Category 'Deleted' not found in database"));

		// 3. Actualizar la categoría del producto a "Deleted" (soft delete)
		product.setCategory(deletedCategory);
		this.productRepository.save(product);
	}
}

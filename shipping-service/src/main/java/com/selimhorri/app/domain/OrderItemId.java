package com.selimhorri.app.domain;

import java.io.Serializable;
import java.util.Objects;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class OrderItemId implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer orderId;
	private Integer productId;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;
		OrderItemId that = (OrderItemId) o;
		return Objects.equals(orderId, that.orderId) &&
				Objects.equals(productId, that.productId);
	}

	@Override
	public int hashCode() {
		return Objects.hash(orderId, productId);
	}

}

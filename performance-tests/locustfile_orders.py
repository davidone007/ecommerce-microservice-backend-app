"""
Pruebas de rendimiento para Order Service.
Simula flujo completo de creación y seguimiento de órdenes.
"""

from locust import HttpUser, task, between
from config import ORDER_SERVICE_URL, REQUEST_TIMEOUT
from utils import TestDataGenerator, ResponseValidator
import random


class OrderServiceUser(HttpUser):
    """Simula el comportamiento de usuarios creando y consultando órdenes."""

    wait_time = between(2, 5)  # Espera entre 2-5 segundos entre tareas

    def on_start(self):
        """Se ejecuta cuando el usuario comienza."""
        self.host = ORDER_SERVICE_URL
        self.order_ids = []
        self.user_id = random.randint(1, 100)
        self.product_id = random.randint(1, 50)

    @task(4)
    def create_order(self):
        """POST /orders - Crear una nueva orden."""
        order_data = TestDataGenerator.generate_order_data(
            user_id=self.user_id, product_id=self.product_id
        )
        with self.client.post(
            "/orders", json=order_data, timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_created_response(
                response
            ) or ResponseValidator.is_ok_response(response):
                try:
                    data = response.json()
                    if "orderId" in data:
                        self.order_ids.append(data["orderId"])
                    response.success()
                except:
                    response.failure("No se puede parsear JSON")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(3)
    def get_order_by_id(self):
        """GET /orders/{id} - Obtener detalle de una orden."""
        if not self.order_ids:
            return

        order_id = random.choice(self.order_ids)
        with self.client.get(
            f"/orders/{order_id}", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)
    def get_user_orders(self):
        """GET /orders/user/{userId} - Obtener órdenes de un usuario."""
        with self.client.get(
            f"/orders/user/{self.user_id}", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)
    def update_order_status(self):
        """PUT /orders/{id}/status - Actualizar estado de orden."""
        if not self.order_ids:
            return

        order_id = random.choice(self.order_ids)
        status_update = {
            "status": random.choice(["ORDERED", "IN_PAYMENT", "PAYMENT_CONFIRMED"])
        }
        with self.client.put(
            f"/orders/{order_id}/status",
            json=status_update,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(1)
    def cancel_order(self):
        """DELETE /orders/{id} - Cancelar una orden."""
        if not self.order_ids:
            return

        order_id = self.order_ids.pop(0)
        with self.client.delete(
            f"/orders/{order_id}", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

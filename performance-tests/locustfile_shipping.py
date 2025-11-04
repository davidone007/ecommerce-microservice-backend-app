"""
Pruebas de rendimiento para Shipping Service.
Simula creación y seguimiento de envíos.
"""

from locust import HttpUser, task, between
from config import SHIPPING_SERVICE_URL, REQUEST_TIMEOUT
from utils import TestDataGenerator, ResponseValidator
import random


class ShippingServiceUser(HttpUser):
    """Simula el comportamiento de usuarios con envíos."""

    wait_time = between(2, 4)

    def on_start(self):
        """Se ejecuta cuando el usuario comienza."""
        self.host = SHIPPING_SERVICE_URL
        self.shipping_ids = []
        self.order_id = random.randint(1, 100)

    @task(4)
    def create_shipping(self):
        """POST /shippings - Crear un nuevo envío."""
        shipping_data = TestDataGenerator.generate_shipping_data(order_id=self.order_id)
        with self.client.post(
            "/shippings",
            json=shipping_data,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_created_response(
                response
            ) or ResponseValidator.is_ok_response(response):
                try:
                    data = response.json()
                    if "shippingId" in data:
                        self.shipping_ids.append(data["shippingId"])
                    response.success()
                except:
                    response.failure("No se puede parsear JSON")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(3)
    def get_shipping_by_id(self):
        """GET /shippings/{id} - Obtener detalle de envío."""
        if not self.shipping_ids:
            return

        shipping_id = random.choice(self.shipping_ids)
        with self.client.get(
            f"/shippings/{shipping_id}", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)
    def get_order_shippings(self):
        """GET /shippings/order/{orderId} - Obtener envíos de una orden."""
        with self.client.get(
            f"/shippings/order/{self.order_id}",
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)
    def update_shipping_status(self):
        """PUT /shippings/{id}/status - Actualizar estado de envío."""
        if not self.shipping_ids:
            return

        shipping_id = random.choice(self.shipping_ids)
        status_update = {
            "shippingStatus": random.choice(["PENDING", "IN_TRANSIT", "DELIVERED"])
        }
        with self.client.put(
            f"/shippings/{shipping_id}/status",
            json=status_update,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(1)
    def get_all_shippings(self):
        """GET /shippings - Obtener todos los envíos."""
        with self.client.get(
            "/shippings", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

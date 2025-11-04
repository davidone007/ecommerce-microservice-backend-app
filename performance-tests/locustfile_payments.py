"""
Pruebas de rendimiento para Payment Service.
Simula procesamiento y confirmación de pagos.
"""

from locust import HttpUser, task, between
from config import PAYMENT_SERVICE_URL, REQUEST_TIMEOUT, PAYMENT_STATUSES
from utils import TestDataGenerator, ResponseValidator
import random


class PaymentServiceUser(HttpUser):
    """Simula el comportamiento de usuarios procesando pagos."""

    wait_time = between(2, 4)

    def on_start(self):
        """Se ejecuta cuando el usuario comienza."""
        self.host = PAYMENT_SERVICE_URL
        self.payment_ids = []
        self.order_id = 1

    @task(5)
    def create_payment(self):
        """POST /payments - Crear un nuevo pago."""
        payment_data = TestDataGenerator.generate_payment_data(order_id=self.order_id)
        with self.client.post(
            "/payments", json=payment_data, timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_created_response(
                response
            ) or ResponseValidator.is_ok_response(response):
                try:
                    data = response.json()
                    if "paymentId" in data:
                        self.payment_ids.append(data["paymentId"])
                    response.success()
                except:
                    response.failure("No se puede parsear JSON")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(3)
    def get_payment_by_id(self):
        """GET /payments/{id} - Obtener detalle de un pago."""
        if not self.payment_ids:
            return

        payment_id = random.choice(self.payment_ids)
        with self.client.get(
            f"/payments/{payment_id}", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)
    def get_all_payments(self):
        """GET /payments - Obtener listado de pagos."""
        with self.client.get(
            "/payments", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(3)
    def update_payment_status(self):
        """PUT /payments/{id}/status - Actualizar estado de pago."""
        if not self.payment_ids:
            return

        payment_id = random.choice(self.payment_ids)
        status_update = {"paymentStatus": random.choice(PAYMENT_STATUSES)}
        with self.client.put(
            f"/payments/{payment_id}/status",
            json=status_update,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(1)
    def verify_payment(self):
        """POST /payments/{id}/verify - Verificar un pago."""
        if not self.payment_ids:
            return

        payment_id = random.choice(self.payment_ids)
        with self.client.post(
            f"/payments/{payment_id}/verify",
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

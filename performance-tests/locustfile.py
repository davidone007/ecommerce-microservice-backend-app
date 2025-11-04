"""
Locustfile principal que combina pruebas de todos los servicios.
Este archivo simula un flujo completo de compra: búsqueda, creación de orden, pago y envío.
Ejecutar con: locust -f locustfile.py --host=http://localhost:8100
"""

from locust import HttpUser, task, between, events
from config import (
    API_GATEWAY_URL,
    REQUEST_TIMEOUT,
    TEST_USER_EMAIL,
    DEFAULT_USER_COUNT,
    DEFAULT_SPAWN_RATE,
)
from utils import TestDataGenerator, ResponseValidator
import random
import json


class EcommerceUser(HttpUser):
    """
    Simula un usuario completo del sistema de e-commerce.
    Flujo:
    1. Buscar productos
    2. Ver detalles de producto
    3. Agregar a favoritos
    4. Crear orden
    5. Realizar pago
    6. Ver estado de envío
    """

    wait_time = between(2, 5)

    def on_start(self):
        """Inicializa el usuario con datos de sesión."""
        self.host = API_GATEWAY_URL
        self.user_id = random.randint(1, 1000)
        self.product_ids = []
        self.order_ids = []
        self.payment_ids = []
        self.token = None

    @task(1)
    def browse_products(self):
        """Fase 1: Navegar y buscar productos."""
        search_terms = [
            "laptop",
            "phone",
            "tablet",
            "monitor",
            "keyboard",
            "mouse",
            "headphones",
        ]
        search_term = random.choice(search_terms)

        with self.client.get(
            f"/product-service/products/search?query={search_term}",
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                try:
                    data = response.json()
                    if isinstance(data, list) and len(data) > 0:
                        self.product_ids = [
                            p.get("productId") for p in data if "productId" in p
                        ]
                    response.success()
                except:
                    response.failure("Error parseando respuesta de productos")
            else:
                response.failure(f"Search fallido: {response.status_code}")

    @task(2)
    def view_product_details(self):
        """Fase 2: Ver detalles de un producto específico."""
        if not self.product_ids:
            return

        product_id = random.choice(self.product_ids)
        with self.client.get(
            f"/product-service/products/{product_id}",
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Get producto fallido: {response.status_code}")

    @task(1)
    def add_to_favorites(self):
        """Fase 3: Agregar producto a favoritos."""
        if not self.product_ids:
            return

        product_id = random.choice(self.product_ids)
        favourite_data = TestDataGenerator.generate_favourite_data(
            user_id=self.user_id, product_id=product_id
        )

        with self.client.post(
            "/favourite-service/favourites",
            json=favourite_data,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Add favorite fallido: {response.status_code}")

    @task(3)
    def create_order(self):
        """Fase 4: Crear una orden."""
        if not self.product_ids:
            return

        product_id = random.choice(self.product_ids)
        order_data = {
            "userId": self.user_id,
            "productId": product_id,
            "quantity": random.randint(1, 5),
            "orderDesc": "Test order from Locust",
            "orderFee": round(random.uniform(5, 50), 2),
        }

        with self.client.post(
            "/order-service/orders",
            json=order_data,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                try:
                    data = response.json()
                    if "orderId" in data:
                        self.order_ids.append(data["orderId"])
                    response.success()
                except:
                    response.failure("Error parseando respuesta de orden")
            else:
                response.failure(f"Create orden fallido: {response.status_code}")

    @task(2)
    def process_payment(self):
        """Fase 5: Procesar pago."""
        if not self.order_ids:
            return

        order_id = random.choice(self.order_ids)
        payment_data = TestDataGenerator.generate_payment_data(order_id=order_id)

        with self.client.post(
            "/payment-service/payments",
            json=payment_data,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                try:
                    data = response.json()
                    if "paymentId" in data:
                        self.payment_ids.append(data["paymentId"])
                    response.success()
                except:
                    response.failure("Error parseando respuesta de pago")
            else:
                response.failure(f"Create pago fallido: {response.status_code}")

    @task(1)
    def track_shipment(self):
        """Fase 6: Rastrear envío."""
        if not self.order_ids:
            return

        order_id = random.choice(self.order_ids)
        with self.client.get(
            f"/shipping-service/shippings/order/{order_id}",
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Get shipping fallido: {response.status_code}")


# Eventos de Locust para logging y reporting
@events.test_start.add_listener
def on_test_start(environment, **kwargs):
    """Se ejecuta cuando inician las pruebas."""
    print("\n" + "=" * 80)
    print("🚀 INICIANDO PRUEBAS DE RENDIMIENTO Y ESTRÉS DEL SISTEMA E-COMMERCE")
    print("=" * 80)
    print(f"Host: {environment.host}")
    print(
        "Simulando flujo completo de compra: Búsqueda → Favoritos → Orden → Pago → Envío"
    )
    print("=" * 80 + "\n")


@events.test_stop.add_listener
def on_test_stop(environment, **kwargs):
    """Se ejecuta cuando terminan las pruebas."""
    print("\n" + "=" * 80)
    print("✅ PRUEBAS COMPLETADAS")
    print("=" * 80 + "\n")

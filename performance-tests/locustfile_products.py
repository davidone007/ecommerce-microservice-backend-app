"""
Pruebas de rendimiento para Product Service.
Simula casos de uso reales: búsqueda, visualización y filtrado de productos.
"""

from locust import HttpUser, task, between, events
from config import PRODUCT_SERVICE_URL, REQUEST_TIMEOUT
from utils import TestDataGenerator, ResponseValidator
import random


class ProductServiceUser(HttpUser):
    """Simula el comportamiento de usuarios interactuando con Product Service."""

    wait_time = between(1, 3)  # Espera entre 1-3 segundos entre tareas

    def on_start(self):
        """Se ejecuta cuando el usuario comienza."""
        self.product_ids = []
        self.host = PRODUCT_SERVICE_URL

    @task(3)  # Peso 3: Se ejecuta 3 veces más frecuente que otras tareas
    def get_all_products(self):
        """GET /products - Obtener listado de productos."""
        with self.client.get(
            "/products", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                try:
                    data = response.json()
                    if isinstance(data, list) and len(data) > 0:
                        # Guardar IDs de productos para pruebas posteriores
                        self.product_ids = [
                            p.get("productId") for p in data if "productId" in p
                        ]
                    response.success()
                except:
                    response.failure("No se puede parsear JSON")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)  # Peso 2: Se ejecuta 2 veces más frecuente
    def get_product_by_id(self):
        """GET /products/{id} - Obtener un producto específico."""
        if not self.product_ids:
            return

        product_id = random.choice(self.product_ids)
        with self.client.get(
            f"/products/{product_id}", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_ok_response(response):
                response.success()
            elif response.status_code == 404:
                response.failure("Producto no encontrado")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(1)
    def create_product(self):
        """POST /products - Crear un nuevo producto."""
        product_data = TestDataGenerator.generate_product_data()
        with self.client.post(
            "/products", json=product_data, timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_created_response(response):
                try:
                    data = response.json()
                    if "productId" in data:
                        self.product_ids.append(data["productId"])
                    response.success()
                except:
                    response.failure("No se puede parsear JSON")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)
    def search_products(self):
        """GET /products/search - Buscar productos."""
        search_term = random.choice(
            ["laptop", "phone", "tablet", "monitor", "keyboard"]
        )
        with self.client.get(
            f"/products/search?query={search_term}",
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(1)
    def update_product(self):
        """PUT /products/{id} - Actualizar un producto."""
        if not self.product_ids:
            return

        product_id = random.choice(self.product_ids)
        update_data = {
            "productPrice": round(random.uniform(10, 1000), 2),
            "productQuantity": random.randint(1, 100),
        }
        with self.client.put(
            f"/products/{product_id}",
            json=update_data,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

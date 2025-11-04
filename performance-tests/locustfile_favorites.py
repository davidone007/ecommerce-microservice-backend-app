"""
Pruebas de rendimiento para Favourite Service.
Simula marcado y consulta de productos favoritos.
"""

from locust import HttpUser, task, between
from config import FAVOURITE_SERVICE_URL, REQUEST_TIMEOUT
from utils import TestDataGenerator, ResponseValidator
import random


class FavouriteServiceUser(HttpUser):
    """Simula el comportamiento de usuarios marcando favoritos."""

    wait_time = between(1, 3)

    def on_start(self):
        """Se ejecuta cuando el usuario comienza."""
        self.host = FAVOURITE_SERVICE_URL
        self.favourite_ids = []
        self.user_id = random.randint(1, 100)
        self.product_ids = list(range(1, 51))  # Simular 50 productos

    @task(4)
    def add_to_favorites(self):
        """POST /favourites - Agregar producto a favoritos."""
        product_id = random.choice(self.product_ids)
        favourite_data = TestDataGenerator.generate_favourite_data(
            user_id=self.user_id, product_id=product_id
        )
        with self.client.post(
            "/favourites",
            json=favourite_data,
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_created_response(
                response
            ) or ResponseValidator.is_ok_response(response):
                try:
                    data = response.json()
                    self.favourite_ids.append(data)
                    response.success()
                except:
                    response.failure("No se puede parsear JSON")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(3)
    def get_user_favorites(self):
        """GET /favourites/user/{userId} - Obtener favoritos del usuario."""
        with self.client.get(
            f"/favourites/user/{self.user_id}",
            timeout=REQUEST_TIMEOUT,
            catch_response=True,
        ) as response:
            if ResponseValidator.is_success_response(response):
                try:
                    data = response.json()
                    if isinstance(data, list):
                        self.favourite_ids = data
                    response.success()
                except:
                    response.failure("No se puede parsear JSON")
            else:
                response.failure(f"Status: {response.status_code}")

    @task(2)
    def get_all_favorites(self):
        """GET /favourites - Obtener todos los favoritos."""
        with self.client.get(
            "/favourites", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

    @task(1)
    def remove_from_favorites(self):
        """DELETE /favourites/{id} - Remover de favoritos."""
        if not self.favourite_ids:
            return

        # Simular ID de favorito (normalmente vendría del endpoint anterior)
        favourite_id = random.randint(1, 100)
        with self.client.delete(
            f"/favourites/{favourite_id}", timeout=REQUEST_TIMEOUT, catch_response=True
        ) as response:
            if ResponseValidator.is_success_response(response):
                response.success()
            else:
                response.failure(f"Status: {response.status_code}")

"""
Utilidades y helpers para las pruebas de rendimiento.
Incluye generadores de datos de prueba y funciones auxiliares.
"""

from faker import Faker
import random
import string

fake = Faker()


class TestDataGenerator:
    """Generador de datos de prueba realistas para pruebas de carga."""

    @staticmethod
    def generate_user_data():
        """Genera datos de usuario realistas."""
        return {
            "firstName": fake.first_name(),
            "lastName": fake.last_name(),
            "email": fake.email(),
            "password": "Test123!@#",
            "phone": fake.phone_number(),
            "address": fake.address(),
        }

    @staticmethod
    def generate_product_data():
        """Genera datos de producto realistas."""
        return {
            "productName": fake.word() + " " + fake.word(),
            "productDesc": fake.sentence(),
            "productPrice": round(random.uniform(10, 1000), 2),
            "productQuantity": random.randint(1, 100),
            "isActive": True,
        }

    @staticmethod
    def generate_order_data(user_id=1, product_id=1):
        """Genera datos de orden realistas."""
        return {
            "userId": user_id,
            "productId": product_id,
            "quantity": random.randint(1, 5),
            "orderDesc": fake.sentence(),
            "orderFee": round(random.uniform(5, 50), 2),
        }

    @staticmethod
    def generate_payment_data(order_id=1):
        """Genera datos de pago realistas."""
        return {"orderId": order_id, "isPayed": False, "paymentStatus": "NOT_STARTED"}

    @staticmethod
    def generate_favourite_data(user_id=1, product_id=1):
        """Genera datos de favorito realistas."""
        return {
            "userId": user_id,
            "productId": product_id,
            "likeDate": fake.date_time_this_year().isoformat(),
        }

    @staticmethod
    def generate_shipping_data(order_id=1):
        """Genera datos de envío realistas."""
        return {
            "orderId": order_id,
            "shippingAddress": fake.address(),
            "shippingCost": round(random.uniform(5, 30), 2),
            "estimatedDelivery": fake.date_time_this_month().isoformat(),
        }


class ResponseValidator:
    """Validador de respuestas para las pruebas."""

    @staticmethod
    def is_success_response(response):
        """Verifica si la respuesta es exitosa (200-299)."""
        return 200 <= response.status_code < 300

    @staticmethod
    def is_created_response(response):
        """Verifica si la respuesta indica creación (201)."""
        return response.status_code == 201

    @staticmethod
    def is_ok_response(response):
        """Verifica si la respuesta es OK (200)."""
        return response.status_code == 200

    @staticmethod
    def is_error_response(response):
        """Verifica si la respuesta es error (4xx-5xx)."""
        return response.status_code >= 400

    @staticmethod
    def validate_json_response(response, expected_fields=None):
        """Valida que la respuesta sea JSON válido con campos esperados."""
        try:
            data = response.json()
            if expected_fields:
                return all(field in data for field in expected_fields)
            return True
        except:
            return False


def calculate_response_time_metrics(response_times):
    """Calcula métricas estadísticas de tiempos de respuesta."""
    if not response_times:
        return {}

    sorted_times = sorted(response_times)
    length = len(sorted_times)

    return {
        "min": min(sorted_times),
        "max": max(sorted_times),
        "avg": sum(sorted_times) / length,
        "p50": sorted_times[length // 2],
        "p95": sorted_times[int(length * 0.95)],
        "p99": sorted_times[int(length * 0.99)],
    }

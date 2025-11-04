"""
Configuración centralizada para las pruebas de rendimiento con Locust.
Define URLs, constantes y utilidades compartidas.
"""

import os
from dotenv import load_dotenv

load_dotenv()

# URLs base de los servicios
API_GATEWAY_URL = os.getenv("API_GATEWAY_URL", "http://localhost:8100")
PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL", "http://localhost:8200")
USER_SERVICE_URL = os.getenv("USER_SERVICE_URL", "http://localhost:8500")
ORDER_SERVICE_URL = os.getenv("ORDER_SERVICE_URL", "http://localhost:8300")
PAYMENT_SERVICE_URL = os.getenv("PAYMENT_SERVICE_URL", "http://localhost:8400")
FAVOURITE_SERVICE_URL = os.getenv("FAVOURITE_SERVICE_URL", "http://localhost:8800")
SHIPPING_SERVICE_URL = os.getenv("SHIPPING_SERVICE_URL", "http://localhost:8600")

# Configuración de timeouts
REQUEST_TIMEOUT = 30
CONNECT_TIMEOUT = 5

# Datos de prueba
TEST_USER_EMAIL = "test@example.com"
TEST_USER_PASSWORD = "TestPassword123!"

# Estados esperados
ORDER_STATUSES = [
    "CREATED",
    "ORDERED",
    "IN_PAYMENT",
    "PAYMENT_CONFIRMED",
    "SHIPPED",
    "DELIVERED",
]
PAYMENT_STATUSES = ["NOT_STARTED", "IN_PROGRESS", "COMPLETED", "FAILED"]

# Configuración de carga
DEFAULT_USER_COUNT = 10
DEFAULT_SPAWN_RATE = 2
DEFAULT_RUN_TIME = "5m"

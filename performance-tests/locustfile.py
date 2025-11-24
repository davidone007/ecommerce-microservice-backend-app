"""
Pruebas de Rendimiento y Estrés para E-commerce Microservices
===============================================================

Este archivo contiene escenarios realistas que simulan el comportamiento de usuarios
en un sistema de e-commerce, midiendo métricas clave como:
- Tiempo de respuesta (response time)
- Throughput (requests por segundo)
- Tasa de errores (error rate)
- Percentiles (p50, p95, p99)

Autor: Performance Testing Suite
Fecha: 2024-11-04
"""

import random
import json
import time
from locust import HttpUser, TaskSet, task, between, events
from locust.contrib.fasthttp import FastHttpUser
import logging

# Configuración de logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

MAX_ERROR_DETAIL_CHARS = 400


def format_error_detail(response):
    """Extrae un mensaje de error legible desde la respuesta HTTP."""
    detail = response.text or ""

    try:
        body = response.json()
        if isinstance(body, dict):
            detail = body.get("message") or body.get("error") or body.get("errors") or body
        elif isinstance(body, list):
            detail = body
    except ValueError:
        # La respuesta no es JSON; conservamos el texto crudo
        pass

    if isinstance(detail, (dict, list)):
        detail = json.dumps(detail, ensure_ascii=False)

    detail = (detail or "sin cuerpo de respuesta").strip()

    if len(detail) > MAX_ERROR_DETAIL_CHARS:
        detail = f"{detail[:MAX_ERROR_DETAIL_CHARS]}..."

    return f"HTTP {response.status_code} - {detail}"


def register_failure(response, context):
    """Registra y reporta un fallo detallado para una petición."""
    message = f"{context}: {format_error_detail(response)}"
    response.failure(message)
    logger.error(message)
    return message


class AuthenticationMixin:
    """Mixin para manejar la autenticación JWT"""

    def __init__(self):
        self.token = None
        self.user_id = None
        self.admin_user_id = None

    def authenticate_admin(self):
        """Autentica como usuario admin y obtiene el token JWT"""
        try:
            # Crear usuario admin
            with self.client.post(
                "/app/api/users",
                json={
                    "firstName": f"Admin",
                    "lastName": f"Test{random.randint(1000, 9999)}",
                    "imageUrl": "https://example.com/admin-avatar.jpg",
                    "email": f"admin.test{random.randint(1000, 9999)}@ecommerce.com",
                    "phone": f"+346{random.randint(10000000, 99999999)}",
                },
                catch_response=True,
                name="/app/api/users [CREATE ADMIN]",
            ) as response:
                if response.status_code == 200:
                    data = response.json()
                    self.admin_user_id = data.get("userId")
                    logger.info(f"Admin user created with ID: {self.admin_user_id}")
                else:
                    logger.error(f"Failed to create admin user: {response.status_code}")
                    return False

            # Pequeña pausa
            time.sleep(0.5)

            # Crear credenciales
            username = f"admin{random.randint(1000, 9999)}"
            password = "Admin123!"

            with self.client.post(
                "/app/api/credentials",
                json={
                    "username": username,
                    "password": password,
                    "roleBasedAuthority": "ROLE_ADMIN",
                    "isEnabled": True,
                    "isAccountNonExpired": True,
                    "isAccountNonLocked": True,
                    "isCredentialsNonExpired": True,
                    "user": {"userId": self.admin_user_id},
                },
                catch_response=True,
                name="/app/api/credentials [CREATE ADMIN CREDS]",
            ) as response:
                if response.status_code != 200:
                    logger.error(
                        f"Failed to create admin credentials: {response.status_code}"
                    )
                    return False

            # Pequeña pausa
            time.sleep(0.5)

            # Autenticar y obtener token
            with self.client.post(
                "/app/api/authenticate",
                json={"username": username, "password": password},
                catch_response=True,
                name="/app/api/authenticate [ADMIN]",
            ) as response:
                if response.status_code == 200:
                    data = response.json()
                    self.token = data.get("jwtToken")
                    logger.info(f"Admin authenticated successfully")
                    return True
                else:
                    logger.error(
                        f"Failed to authenticate admin: {response.status_code}"
                    )
                    return False

        except Exception as e:
            logger.error(f"Authentication error: {str(e)}")
            return False

    def get_headers(self):
        """Retorna los headers con el token de autenticación"""
        if self.token:
            return {
                "Authorization": f"Bearer {self.token}",
                "Content-Type": "application/json",
            }
        return {"Content-Type": "application/json"}


class UserBehavior(TaskSet, AuthenticationMixin):
    """
    Comportamiento de un usuario navegando por el e-commerce
    Simula acciones realistas como: navegar productos, ver detalles, agregar al carrito
    """

    def on_start(self):
        """Se ejecuta cuando el usuario inicia su sesión"""
        AuthenticationMixin.__init__(self)
        # Autenticar al inicio
        if not self.authenticate_admin():
            logger.error("Failed to authenticate, stopping user")
            self.interrupt()

        # Datos de sesión del usuario
        self.user_id = None
        self.product_ids = []
        self.category_id = None
        self.cart_id = None
        self.order_id = None

    @task(10)
    def browse_products(self):
        """Usuario navega por los productos (acción muy frecuente)"""
        with self.client.get(
            "/app/api/products",
            headers=self.get_headers(),
            catch_response=True,
            name="/app/api/products [BROWSE]",
        ) as response:
            if response.status_code == 200:
                response.success()
            else:
                register_failure(response, "/app/api/products [BROWSE]")

    @task(8)
    def view_product_details(self):
        """Usuario ve detalles de un producto específico"""
        if self.product_ids:
            product_id = random.choice(self.product_ids)
            with self.client.get(
                f"/app/api/products/{product_id}",
                headers=self.get_headers(),
                catch_response=True,
                name="/app/api/products/[id] [VIEW DETAILS]",
            ) as response:
                if response.status_code == 200:
                    response.success()
                else:
                    register_failure(response, "/app/api/products/[id] [VIEW DETAILS]")

    @task(3)
    def create_user_account(self):
        """Usuario crea una cuenta nueva"""
        random_num = random.randint(10000, 99999)
        user_data = {
            "firstName": f"User{random_num}",
            "lastName": f"Test{random_num}",
            "imageUrl": "https://example.com/avatar.jpg",
            "email": f"user{random_num}@test.com",
            "phone": f"+346{random.randint(10000000, 99999999)}",
        }

        with self.client.post(
            "/app/api/users",
            headers=self.get_headers(),
            json=user_data,
            catch_response=True,
            name="/app/api/users [CREATE]",
        ) as response:
            if response.status_code == 200:
                data = response.json()
                self.user_id = data.get("userId")
                response.success()
            else:
                register_failure(response, "/app/api/users [CREATE]")

    @task(5)
    def create_product(self):
        """Admin crea un nuevo producto"""
        if not self.category_id:
            self._create_category()

        if self.category_id:
            product_data = {
                "productTitle": f"Product {random.randint(1000, 9999)}",
                "imageUrl": "https://example.com/product.jpg",
                "sku": f"SKU-{random.randint(1000, 9999)}",
                "priceUnit": round(random.uniform(10.0, 999.0), 2),
                "quantity": random.randint(1, 100),
                "category": {"categoryId": self.category_id},
            }

            with self.client.post(
                "/app/api/products",
                headers=self.get_headers(),
                json=product_data,
                catch_response=True,
                name="/app/api/products [CREATE]",
            ) as response:
                if response.status_code == 200:
                    data = response.json()
                    product_id = data.get("productId")
                    if product_id:
                        self.product_ids.append(product_id)
                    response.success()
                else:
                    register_failure(response, "/app/api/products [CREATE]")

    @task(2)
    def add_to_favorites(self):
        """Usuario agrega un producto a favoritos"""
        if self.user_id and self.product_ids:
            favorite_data = {
                "userId": self.user_id,
                "productId": random.choice(self.product_ids),
                "likeDate": time.strftime("%d-%m-%Y__%H:%M:%S:000000"),
            }

            with self.client.post(
                "/app/api/favourites",
                headers=self.get_headers(),
                json=favorite_data,
                catch_response=True,
                name="/app/api/favourites [ADD]",
            ) as response:
                if response.status_code in [200, 201]:
                    response.success()
                else:
                    register_failure(response, "/app/api/favourites [ADD]")

    @task(1)
    def view_favorites(self):
        """Usuario ve sus productos favoritos"""
        with self.client.get(
            "/app/api/favourites",
            headers=self.get_headers(),
            catch_response=True,
            name="/app/api/favourites [VIEW]",
        ) as response:
            if response.status_code == 200:
                response.success()
            else:
                register_failure(response, "/app/api/favourites [VIEW]")

    def _create_category(self):
        """Método auxiliar para crear una categoría"""
        category_data = {
            "categoryTitle": f"Category {random.randint(1000, 9999)}",
            "imageUrl": "https://example.com/category.jpg",
        }

        with self.client.post(
            "/app/api/categories",
            headers=self.get_headers(),
            json=category_data,
            catch_response=True,
            name="/app/api/categories [CREATE]",
        ) as response:
            if response.status_code == 200:
                data = response.json()
                self.category_id = data.get("categoryId")


class PurchaseFlowBehavior(TaskSet, AuthenticationMixin):
    """
    Flujo completo de compra
    Simula el proceso completo: crear carrito, agregar productos, crear orden, pagar
    """

    def on_start(self):
        """Inicializa el flujo de compra"""
        AuthenticationMixin.__init__(self)
        if not self.authenticate_admin():
            logger.error("Failed to authenticate for purchase flow")
            self.interrupt()

        self.user_id = None
        self.product_ids = []
        self.category_id = None
        self.cart_id = None
        self.order_id = None

        # Setup inicial: crear usuario y productos
        self._setup_purchase_scenario()

    def _setup_purchase_scenario(self):
        """Configura el escenario de compra creando usuario y productos"""
        # Crear usuario
        random_num = random.randint(10000, 99999)
        user_data = {
            "firstName": f"Buyer{random_num}",
            "lastName": f"Test{random_num}",
            "imageUrl": "https://example.com/avatar.jpg",
            "email": f"buyer{random_num}@test.com",
            "phone": f"+346{random.randint(10000000, 99999999)}",
        }

        response = self.client.post(
            "/app/api/users",
            headers=self.get_headers(),
            json=user_data,
            name="/app/api/users [SETUP]",
        )

        if response.status_code == 200:
            self.user_id = response.json().get("userId")

        # Crear categoría
        category_data = {
            "categoryTitle": f"PurchaseCategory {random.randint(1000, 9999)}",
            "imageUrl": "https://example.com/category.jpg",
        }

        response = self.client.post(
            "/app/api/categories",
            headers=self.get_headers(),
            json=category_data,
            name="/app/api/categories [SETUP]",
        )

        if response.status_code == 200:
            self.category_id = response.json().get("categoryId")

        # Crear algunos productos
        if self.category_id:
            for i in range(3):
                product_data = {
                    "productTitle": f"Product {random.randint(1000, 9999)}",
                    "imageUrl": "https://example.com/product.jpg",
                    "sku": f"SKU-{random.randint(1000, 9999)}",
                    "priceUnit": round(random.uniform(10.0, 999.0), 2),
                    "quantity": random.randint(10, 100),
                    "category": {"categoryId": self.category_id},
                }

                response = self.client.post(
                    "/app/api/products",
                    headers=self.get_headers(),
                    json=product_data,
                    name="/app/api/products [SETUP]",
                )

                if response.status_code == 200:
                    product_id = response.json().get("productId")
                    if product_id:
                        self.product_ids.append(product_id)

    @task(1)
    def complete_purchase_flow(self):
        """Ejecuta el flujo completo de compra"""
        if not self.user_id or not self.product_ids:
            logger.warning("Cannot complete purchase: missing user or products")
            return

        # 1. Crear carrito
        cart_data = {"userId": self.user_id}
        with self.client.post(
            "/app/api/carts",
            headers=self.get_headers(),
            json=cart_data,
            catch_response=True,
            name="/app/api/carts [CREATE]",
        ) as response:
            if response.status_code in [200, 201]:
                self.cart_id = response.json().get("cartId")
                response.success()
            else:
                register_failure(response, "/app/api/carts [CREATE]")
                return

        time.sleep(0.5)

        # 2. Crear orden
        if self.cart_id:
            order_data = {
                "orderDate": time.strftime("%d-%m-%Y__%H:%M:%S:000000"),
                "orderDesc": "Test purchase order",
                "orderFee": round(random.uniform(50.0, 500.0), 2),
                "orderStatus": "CREATED",
                "isActive": True,
                "cart": {"cartId": self.cart_id},
            }

            with self.client.post(
                "/app/api/orders",
                headers=self.get_headers(),
                json=order_data,
                catch_response=True,
                name="/app/api/orders [CREATE]",
            ) as response:
                if response.status_code == 200:
                    self.order_id = response.json().get("orderId")
                    response.success()
                else:
                    register_failure(response, "/app/api/orders [CREATE]")
                    return

        time.sleep(0.5)

        # 3. Actualizar orden a ORDERED
        if self.order_id:
            order_update = {
                "orderId": self.order_id,
                "orderDate": time.strftime("%d-%m-%Y__%H:%M:%S:000000"),
                "orderDesc": "Test purchase order",
                "orderFee": round(random.uniform(50.0, 500.0), 2),
                "orderStatus": "ORDERED",
                "isActive": True,
                "cart": {"cartId": self.cart_id},
            }

            with self.client.put(
                f"/app/api/orders/{self.order_id}",
                headers=self.get_headers(),
                json=order_update,
                catch_response=True,
                name="/app/api/orders/[id] [UPDATE]",
            ) as response:
                if response.status_code == 200:
                    response.success()
                else:
                    register_failure(response, "/app/api/orders/[id] [UPDATE]")
                    return

        time.sleep(0.5)

        # 4. Crear pago
        if self.order_id:
            payment_data = {
                "isPayed": False,
                "paymentStatus": "NOT_STARTED",
                "order": {"orderId": self.order_id},
            }

            with self.client.post(
                "/app/api/payments",
                headers=self.get_headers(),
                json=payment_data,
                catch_response=True,
                name="/app/api/payments [CREATE]",
            ) as response:
                if response.status_code == 200:
                    payment_id = response.json().get("paymentId")
                    response.success()

                    # 5. Completar pago
                    if payment_id:
                        time.sleep(0.5)
                        with self.client.put(
                            f"/app/api/payments/{payment_id}",
                            headers=self.get_headers(),
                            catch_response=True,
                            name="/app/api/payments/[id] [COMPLETE]",
                        ) as pay_response:
                            if pay_response.status_code == 200:
                                pay_response.success()
                                logger.info(
                                    f"Purchase completed successfully for order {self.order_id}"
                                )
                            else:
                                register_failure(pay_response, "/app/api/payments/[id] [COMPLETE]")
                else:
                    register_failure(response, "/app/api/payments [CREATE]")


class BrowsingUser(FastHttpUser):
    """
    Usuario que principalmente navega por el sitio
    Simula usuarios que visitan el sitio, ven productos pero no compran
    """

    tasks = [UserBehavior]
    wait_time = between(1, 3)  # Espera entre 1 y 3 segundos entre tareas
    weight = 3  # Peso relativo: habrá 3 usuarios navegando por cada comprador


class BuyingUser(FastHttpUser):
    """
    Usuario que completa flujos de compra
    Simula usuarios que realmente realizan compras
    """

    tasks = [PurchaseFlowBehavior]
    wait_time = between(2, 5)  # Espera entre 2 y 5 segundos entre tareas
    weight = 1  # Peso relativo: menos usuarios compradores que navegadores


# Event handlers para métricas personalizadas
@events.test_start.add_listener
def on_test_start(environment, **kwargs):
    """Se ejecuta al iniciar las pruebas"""
    logger.info("=" * 80)
    logger.info("INICIANDO PRUEBAS DE RENDIMIENTO Y ESTRÉS")
    logger.info("=" * 80)
    logger.info(f"Host: {environment.host}")
    logger.info(
        f"Usuarios objetivo: {environment.runner.target_user_count if hasattr(environment.runner, 'target_user_count') else 'N/A'}"
    )
    logger.info("=" * 80)


@events.test_stop.add_listener
def on_test_stop(environment, **kwargs):
    """Se ejecuta al finalizar las pruebas"""
    logger.info("=" * 80)
    logger.info("PRUEBAS FINALIZADAS")
    logger.info("=" * 80)

    # Obtener estadísticas
    stats = environment.stats

    logger.info("\n📊 RESUMEN DE MÉTRICAS:")
    logger.info(f"   Total de requests: {stats.total.num_requests}")
    logger.info(f"   Requests fallidos: {stats.total.num_failures}")
    logger.info(f"   Tasa de error: {stats.total.fail_ratio * 100:.2f}%")
    logger.info(
        f"   Tiempo promedio de respuesta: {stats.total.avg_response_time:.2f}ms"
    )
    logger.info(
        f"   Tiempo mediano (p50): {stats.total.get_response_time_percentile(0.50):.2f}ms"
    )
    logger.info(
        f"   Percentil 95 (p95): {stats.total.get_response_time_percentile(0.95):.2f}ms"
    )
    logger.info(
        f"   Percentil 99 (p99): {stats.total.get_response_time_percentile(0.99):.2f}ms"
    )
    logger.info(f"   RPS actual: {stats.total.current_rps:.2f}")
    logger.info("=" * 80)


# Configuración de escenarios para diferentes tipos de pruebas
"""
ESCENARIOS DE PRUEBA RECOMENDADOS:

1. Prueba de Carga (Load Test):
   locust -f locustfile.py --host=http://localhost:8080 --users 50 --spawn-rate 5 --run-time 5m

2. Prueba de Estrés (Stress Test):
   locust -f locustfile.py --host=http://localhost:8080 --users 200 --spawn-rate 10 --run-time 10m

3. Prueba de Picos (Spike Test):
   locust -f locustfile.py --host=http://localhost:8080 --users 500 --spawn-rate 50 --run-time 2m

4. Prueba de Resistencia (Soak Test):
   locust -f locustfile.py --host=http://localhost:8080 --users 100 --spawn-rate 5 --run-time 30m

5. Modo Web UI (para monitoreo en tiempo real):
   locust -f locustfile.py --host=http://localhost:8080
   # Acceder a http://localhost:8089
"""

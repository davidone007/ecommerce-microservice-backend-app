# Arquitectura y Diseño del Sistema

## 📐 Visión General de la Arquitectura

Este documento describe en detalle la arquitectura del sistema de e-commerce basado en microservicios, los patrones de diseño implementados y las decisiones arquitectónicas tomadas durante el proceso de containerización y orquestación.

## 🏛️ Arquitectura de Microservicios

### Principios Arquitectónicos Aplicados

El sistema sigue los principios de la **arquitectura Cloud-Native** y la metodología [**twelve-factor app**](https://12factor.net/), implementando:

1. **Separación de Responsabilidades**: Cada microservicio tiene una responsabilidad única y bien definida
2. **Descubrimiento de Servicios**: Uso de Eureka para registro y descubrimiento dinámico
3. **Configuración Externalizada**: Spring Cloud Config para gestión centralizada de configuraciones
4. **Resiliencia**: Circuit Breakers con Resilience4j
5. **Observabilidad**: Distributed tracing con Zipkin y métricas con Actuator/Prometheus
6. **API Gateway**: Punto único de entrada con Spring Cloud Gateway

### Diagrama de Arquitectura Completo

![Arquitectura del Sistema](../app-architecture.drawio.png)

## 🔧 Componentes del Sistema

### 1. Service Discovery (Eureka Server)

**Puerto**: 8761  
**Propósito**: Registro y descubrimiento dinámico de microservicios

#### Características Implementadas

- **Registro automático**: Los servicios se registran automáticamente al iniciar
- **Health checks**: Verificación periódica del estado de servicios
- **Load balancing**: Distribución de carga entre instancias
- **Self-preservation mode**: Protección contra particiones de red

#### Configuración Docker

```dockerfile
FROM eclipse-temurin:11-jre
ARG PROJECT_VERSION=0.1.0
RUN mkdir -p /home/app
WORKDIR /home/app
ENV SPRING_PROFILES_ACTIVE dev
COPY service-discovery/ .
ADD service-discovery/target/service-discovery-v${PROJECT_VERSION}.jar service-discovery.jar
EXPOSE 8761
ENTRYPOINT ["java", "-Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}", "-jar", "service-discovery.jar"]
```

### 2. Cloud Config Server

**Puerto**: 9296  
**Propósito**: Gestión centralizada de configuraciones

#### Características

- Configuración centralizada para todos los microservicios
- Soporte para múltiples perfiles (dev, stage, prod)
- Actualización dinámica de configuraciones
- Almacenamiento en repositorio Git (opcional)

### 3. API Gateway

**Puerto**: 8080  
**Propósito**: Punto único de entrada y enrutamiento de peticiones

#### Funcionalidades

- **Enrutamiento dinámico**: Basado en el registro de Eureka
- **Load balancing**: Distribución de peticiones
- **Circuit breaker**: Protección ante fallos
- **Rate limiting**: Control de tráfico
- **CORS**: Configuración de políticas de acceso

#### Rutas Configuradas

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-service
          uri: lb://user-service
          predicates:
            - Path=/app/api/users/**
        
        - id: product-service
          uri: lb://product-service
          predicates:
            - Path=/app/api/products/**
            
        - id: order-service
          uri: lb://order-service
          predicates:
            - Path=/app/api/orders/**
```

### 4. Proxy Client (Authentication Service)

**Puerto**: 8900  
**Propósito**: Autenticación y autorización con JWT

#### Seguridad Implementada

- **JWT Tokens**: Autenticación basada en tokens
- **Roles y Permisos**: ROLE_USER, ROLE_ADMIN
- **Swagger UI**: Documentación interactiva de APIs
- **OAuth2 Ready**: Preparado para integración OAuth2

### 5. Servicios de Negocio

#### User Service (Puerto 8700)

- Gestión de usuarios (clientes y administradores)
- Manejo de credenciales
- Perfiles de usuario
- Base de datos: H2/MySQL

#### Product Service (Puerto 8500)

- CRUD de productos
- Gestión de categorías
- Control de inventario (cantidad, SKU)
- Imágenes de productos

#### Favourite Service (Puerto 8800)

- Lista de productos favoritos por usuario
- Fecha de agregado a favoritos
- Relación user-product

#### Order Service (Puerto 8300)

- Creación y gestión de órdenes
- Estados de orden (CREATED, ORDERED, COMPLETED, CANCELLED)
- Integración con carritos de compra
- Cálculo de totales

#### Payment Service (Puerto 8400)

- Procesamiento de pagos
- Estados de pago (NOT_STARTED, IN_PROGRESS, COMPLETED, FAILED)
- Integración con órdenes
- Registro de transacciones

#### Shipping Service (Puerto 8600)

- Gestión de envíos
- Tracking de paquetes
- Estados de envío
- Integración con órdenes

### 6. Observabilidad (Zipkin)

**Puerto**: 9411  
**Propósito**: Distributed tracing y monitoreo

#### Métricas Capturadas

- Tiempo de respuesta de cada servicio
- Latencia entre servicios
- Trace completo de requests
- Identificación de cuellos de botella

![Zipkin Dashboard](../img/zipkinBueno.png)

## 🔄 Patrones de Diseño Implementados

### 1. API Gateway Pattern

- Punto único de entrada para todas las peticiones
- Simplifica el lado del cliente
- Enrutamiento inteligente basado en paths
- Agregación de respuestas

### 2. Service Registry Pattern

- Descubrimiento dinámico de servicios
- Health checking automático
- No requiere configuración estática de endpoints

### 3. Circuit Breaker Pattern

**Implementación con Resilience4j**:

```java
@CircuitBreaker(name = "proxyService", fallbackMethod = "fallbackMethod")
public ResponseEntity<Product> getProduct(Long id) {
    return productService.findById(id);
}

public ResponseEntity<Product> fallbackMethod(Long id, Exception ex) {
    return ResponseEntity.ok(getCachedProduct(id));
}
```

**Estados del Circuit Breaker**:

- **CLOSED**: Funcionamiento normal
- **OPEN**: Fallo detectado, se ejecuta fallback
- **HALF_OPEN**: Prueba de recuperación

### 4. Centralized Configuration Pattern

- Configuración en un único lugar
- Cambios sin redeploying
- Gestión por entorno (dev, stage, prod)

### 5. Database per Service Pattern

Cada microservicio tiene su propia base de datos:

- **Ventajas**:
  - Independencia entre servicios
  - Escalabilidad individual
  - Tecnología específica por servicio
  
- **Desafíos Resueltos**:
  - Consistencia eventual
  - Transacciones distribuidas
  - Joins entre servicios via API calls

### 6. Distributed Tracing Pattern

- Trace IDs únicos por request
- Propagación de contexto entre servicios
- Visualización end-to-end en Zipkin

## 🗄️ Modelo de Datos

### Diagrama Entidad-Relación

![ERD del Sistema](../ecommerce-ERD.drawio.png)

### Entidades Principales

#### User

```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String imageUrl;
}
```

#### Product

```java
@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer productId;
    private String productTitle;
    private String imageUrl;
    private String sku;
    private Double priceUnit;
    private Integer quantity;
    
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
}
```

#### Order

```java
@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer orderId;
    private String orderDate;
    private String orderDesc;
    private Double orderFee;
    
    @Enumerated(EnumType.STRING)
    private OrderStatus orderStatus;
    
    @OneToOne
    @JoinColumn(name = "cart_id")
    private Cart cart;
}
```

## 🌐 Comunicación entre Servicios

### Comunicación Síncrona (REST)

**Ejemplo**: User Service -> Product Service

```java
@FeignClient(name = "product-service")
public interface ProductServiceClient {
    
    @GetMapping("/app/api/products/{id}")
    ResponseEntity<Product> getProductById(@PathVariable Long id);
    
    @GetMapping("/app/api/products")
    ResponseEntity<List<Product>> getAllProducts();
}
```

**Ventajas**:

- Simple y directo
- Bien soportado por Spring Cloud
- Debugging más fácil

**Desventajas**:

- Acoplamiento temporal
- Requiere Circuit Breaker para resiliencia

### Load Balancing con Ribbon

```java
@LoadBalanced
@Bean
public RestTemplate restTemplate() {
    return new RestTemplate();
}
```

## 🔒 Seguridad

### Autenticación JWT

**Flow de Autenticación**:

1. Usuario envía credenciales a `/api/authenticate`
2. Proxy-client valida credenciales
3. Se genera JWT token con claims (username, roles, exp)
4. Cliente incluye token en header: `Authorization: Bearer <token>`
5. API Gateway valida token en cada request
6. Request es enrutado al microservicio correspondiente

### Roles y Permisos

- **ROLE_USER**: Acceso a operaciones de usuario normal
- **ROLE_ADMIN**: Acceso completo a todas las operaciones

## 📊 Métricas y Monitoreo

### Spring Boot Actuator

**Endpoints Expuestos**:

- `/actuator/health`: Estado de salud del servicio
- `/actuator/info`: Información del servicio
- `/actuator/metrics`: Métricas de rendimiento
- `/actuator/prometheus`: Métricas en formato Prometheus

### Prometheus Metrics

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  metrics:
    export:
      prometheus:
        enabled: true
```

**Métricas Capturadas**:

- `http.server.requests`: Requests HTTP por endpoint
- `jvm.memory.used`: Uso de memoria
- `jvm.gc.pause`: Pausas de Garbage Collection
- `resilience4j.circuitbreaker.*`: Métricas del Circuit Breaker

## 🚀 Escalabilidad

### Horizontal Scaling

**Kubernetes facilita el escalado**:

```bash
# Escalar un deployment a 3 réplicas
kubectl scale deployment product-service-container --replicas=3

# Auto-scaling basado en CPU
kubectl autoscale deployment product-service-container \
  --min=2 --max=5 --cpu-percent=70
```

### Stateless Services

Todos los microservicios son **stateless**:

- No almacenan sesión en memoria
- Estado en base de datos o cache distribuido
- Permite escalado horizontal sin problemas

## 🔧 Configuración por Entorno

### Perfiles de Spring

```yaml
---
spring:
  config:
    activate:
      on-profile: dev
  datasource:
    url: jdbc:h2:mem:testdb

---
spring:
  config:
    activate:
      on-profile: prod
  datasource:
    url: jdbc:mysql://mysql-prod:3306/ecommerce
```

### Variables de Entorno en Docker/Kubernetes

```yaml
env:
  - name: SPRING_PROFILES_ACTIVE
    value: "prod"
  - name: EUREKA_CLIENT_SERVICEURL_DEFAULTZONE
    value: "http://service-discovery:8761/eureka/"
```

## 📈 Decisiones Arquitectónicas

### ¿Por qué Microservicios?

1. **Escalabilidad Independiente**: Cada servicio escala según su carga
2. **Desarrollo Independiente**: Equipos pueden trabajar en paralelo
3. **Tecnología Heterogénea**: Libertad de elegir stack por servicio
4. **Resiliencia**: Fallo de un servicio no afecta a todos
5. **Despliegue Continuo**: Deploy independiente de cada servicio

### ¿Por qué Spring Cloud?

1. **Ecosystem Maduro**: Soluciones probadas
2. **Integración Nativa**: Spring Boot + Spring Cloud
3. **Comunidad Grande**: Soporte y documentación
4. **Herramientas Completas**: Config, Gateway, Discovery, etc.

### ¿Por qué Docker + Kubernetes?

1. **Portabilidad**: "Build once, run anywhere"
2. **Consistencia**: Mismo comportamiento en dev/stage/prod
3. **Orquestación**: K8s maneja scheduling, scaling, health
4. **Rolling Updates**: Deploys sin downtime
5. **Self-healing**: Reinicio automático de pods fallidos

## 🎯 Próximas Mejoras

### Posibles Evoluciones

1. **Event-Driven Architecture**: Integrar Kafka/RabbitMQ para comunicación asíncrona
2. **API Versioning**: Versionado de APIs para backward compatibility
3. **GraphQL Gateway**: Alternativa a REST para queries complejas
4. **Service Mesh**: Istio para gestión avanzada de tráfico
5. **Monitoring Avanzado**: Grafana + Prometheus stack completo
6. **ELK Stack**: ElasticSearch + Logstash + Kibana para logs centralizados
7. **Cache Distribuido**: Redis para mejorar performance
8. **CQRS Pattern**: Separar writes y reads para alta escala

---

**Nota**: Esta arquitectura fue diseñada considerando best practices de Cloud-Native applications y está lista para evolucionar según las necesidades del negocio.

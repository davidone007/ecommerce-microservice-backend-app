# Pruebas y Testing

## 🧪 Introducción

Este documento detalla todas las pruebas implementadas en el proyecto: pruebas unitarias, de integración, E2E y análisis de calidad de código con SonarQube.

## 🎯 Estrategia de Testing

### Pirámide de Testing

```
        /\
       /  \  E2E Tests (Postman)
      /____\
     /      \  Integration Tests
    /________\
   /          \  Unit Tests
  /__________  \
```

**Enfoque**:

- **Pruebas Unitarias** - Tests aislados de componentes individuales
- **Pruebas de Integración** - Tests de integración entre servicios y BD
- **Pruebas E2E** - Tests end-to-end del flujo completo del negocio

---

## ✅ Pruebas Unitarias

### Tecnologías Utilizadas

- **JUnit 5** (Jupiter) - Framework de testing
- **Mockito** - Creación de mocks y stubs
- **Spring Boot Test** - Testing de Spring Boot
- **Testcontainers** - Contenedores Docker para tests de integración

### Ejecución de Tests

Para ejecutar los tests unitarios de todos los microservicios:

Este comando ejecuta los tests en paralelo en todos los módulos Maven del proyecto.

### Configuración de Tests

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>2.22.2</version>
    <configuration>
        <argLine>${argLine}</argLine>
        <parallel>classes</parallel>
        <threadCount>4</threadCount>
    </configuration>
</plugin>
```

### Cobertura de Código (JaCoCo)

Se configuró JaCoCo para medir la cobertura de código en todos los módulos:

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.10</version>
    <executions>
        <execution>
            <id>prepare-agent</id>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>verify</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
        <execution>
            <id>report-aggregate</id>
            <phase>verify</phase>
            <goals>
                <goal>report-aggregate</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

### Microservicios Testeados

Los siguientes 10 microservicios tienen pruebas unitarias completas:

- ✅ **service-discovery** - Tests de Eureka server
- ✅ **cloud-config** - Tests de config server
- ✅ **api-gateway** - Tests de gateway
- ✅ **proxy-client** - Tests de cliente proxy
- ✅ **user-service** - Tests de gestión de usuarios
- ✅ **product-service** - Tests de gestión de productos
- ✅ **favourite-service** - Tests de favoritos
- ✅ **order-service** - Tests de gestión de órdenes
- ✅ **payment-service** - Tests de pagos
- ✅ **shipping-service** - Tests de envíos

### Tipos de Pruebas Unitarias

#### Test de Repositorio

Pruebas de acceso a datos usando JPA y bases de datos en contenedores:

```java
@DataJpaTest
@Testcontainers
class UserRepositoryTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:13");
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    void shouldSaveAndFindUser() {
        User user = User.builder()
            .firstName("John")
            .lastName("Doe")
            .email("john@test.com")
            .build();
        
        User saved = userRepository.save(user);
        assertThat(saved.getUserId()).isNotNull();
    }
}
```

#### Test de Servicio

Pruebas de lógica de negocio con mocks de dependencias:

```java
@ExtendWith(MockitoExtension.class)
class ProductServiceTest {
    
    @Mock
    private ProductRepository productRepository;
    
    @InjectMocks
    private ProductServiceImpl productService;
    
    @Test
    void shouldFindProductById() {
        Product product = Product.builder()
            .productId(1)
            .productTitle("Test Product")
            .build();
        
        when(productRepository.findById(1))
            .thenReturn(Optional.of(product));
        
        ProductDto result = productService.findById(1);
        assertThat(result.getProductTitle()).isEqualTo("Test Product");
    }
}
```

#### Test de Controlador

Pruebas de endpoints HTTP usando MockMvc:

```java
@WebMvcTest(OrderController.class)
class OrderControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private OrderService orderService;
    
    @Test
    void shouldGetOrders() throws Exception {
        mockMvc.perform(get("/api/orders")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }
}
```

---

## 🔗 Pruebas de Integración

### Descripción

Las pruebas de integración validan que múltiples componentes funcionan correctamente juntos, incluyendo:

- Integración con bases de datos reales
- Integración entre servicios
- Flujos completos de negocio

### Testcontainers

Las pruebas de integración utilizan **Testcontainers** para levantar contenedores Docker con bases de datos reales durante los tests:

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
class ProductServiceIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:13")
        .withDatabaseName("test")
        .withUsername("test")
        .withPassword("test");
    
    @DynamicPropertySource
    static void setProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void shouldCreateAndRetrieveProduct() {
        ProductDto newProduct = ProductDto.builder()
            .productTitle("Integration Test Product")
            .sku("SKU-INT-001")
            .priceUnit(199.99)
            .build();
        
        ResponseEntity<ProductDto> createResponse = restTemplate
            .postForEntity("/api/products", newProduct, ProductDto.class);
        
        assertThat(createResponse.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(createResponse.getBody()).isNotNull();
    }
}
```

### Ventajas de Testcontainers

- ✅ Bases de datos reales, no mockeadas
- ✅ Tests aislados y paralelos
- ✅ Reproducibilidad total
- ✅ No requiere infraestructura preexistente

---

## 🌐 Pruebas End-to-End (E2E)

### Postman Collections

Implementé colecciones completas de Postman para testing E2E que validan flujos completos del negocio:

#### Estructura de Colecciones

```
postman-collections/
├── 01-Authentication.postman_collection.json
├── 02-Users.postman_collection.json
├── 03-Products.postman_collection.json
├── 04-Categories.postman_collection.json
├── 05-Favourites.postman_collection.json
├── 06-Carts-Orders.postman_collection.json
├── 07-Payments.postman_collection.json
└── 08-Shipping.postman_collection.json
```

#### Flujo de Testing E2E

El flujo E2E simula un usuario real realizando una compra completa:

1. **Authentication** - Obtener JWT token
2. **Create User** - Crear usuario de prueba
3. **Browse Products** - Consultar catálogo de productos
4. **Add to Favourites** - Guardar productos favoritos
5. **Create Cart** - Crear carrito de compras
6. **Create Order** - Crear orden desde carrito
7. **Process Payment** - Procesar pago de orden
8. **Create Shipping** - Crear envío para orden

#### Ejecución de E2E Tests

Ejecutar toda la colección con Newman (CLI de Postman):

```bash
newman run postman-collections/01-Authentication.postman_collection.json \
  --environment postman-collections/environment.json
```

#### Variables de Entorno

Variables dinámicas para pruebas:

```json
{
  "base_url": "http://localhost:8080",
  "auth_token": "{{jwt_token}}",
  "user_id": "{{created_user_id}}",
  "product_id": "{{created_product_id}}",
  "order_id": "{{created_order_id}}"
}
```

#### Pre-request Scripts

Generación de datos aleatorios para cada ejecución:

```javascript
pm.environment.set("random_email", "user" + Date.now() + "@test.com");
pm.environment.set("random_sku", "SKU-" + Date.now());
```

#### Test Scripts

Validaciones en cada request:

```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has expected fields", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('userId');
    pm.expect(jsonData).to.have.property('email');
});
```

---

## 🔍 Análisis de Calidad - SonarQube

### Configuración de SonarQube

SonarQube integrado en el pipeline de CI/CD para análisis estático de código:

```bash
./mvnw clean verify sonar:sonar \
  -Dsonar.projectKey=ecommerce-microservices \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=<token>
```

### Configuración en pom.xml

```xml
<plugin>
    <groupId>org.sonarsource.scanner.maven</groupId>
    <artifactId>sonar-maven-plugin</artifactId>
    <version>3.9.1.2184</version>
</plugin>
```

### Métricas Analizadas por SonarQube

SonarQube proporciona análisis en las siguientes áreas:

| Métrica | Descripción |
|---------|-------------|
| **Code Smells** | Código que funciona pero puede mejorar |
| **Bugs** | Errores potenciales en el código |
| **Vulnerabilities** | Problemas de seguridad |
| **Code Coverage** | Porcentaje de código cubierto por tests |
| **Duplications** | Código duplicado innecesariamente |
| **Technical Debt** | Tiempo estimado para solucionar problemas |

### Análisis en el Pipeline

La imagen capturada del dashboard muestra el análisis SonarQube en el pipeline.

**Resultados obtenidos**:

- ✅ Quality Gate Passed
- ✅ 17 Bugs detectados y corregidos
- ✅ 0 Vulnerabilities de seguridad
- ✅ 67 Code Smells identificados
- ✅ Coverage ~15% en el código nuevo
- ✅ 1d 3h de deuda técnica total

### Acciones Realizadas

1. **Bug Fixes** - Se corrigieron los 17 bugs detectados
2. **Security** - Se eliminaron vulnerabilidades encontradas
3. **Code Quality** - Se aplicaron mejoras basadas en recommendations
4. **Code Smells** - Se refactorizó código problemático

---

## 📦 Integración de Tests en CI/CD

### Pipeline de Testing

Los tests se ejecutan automáticamente en cada push:

```yaml
test:
  stage: test
  script:
    - ./mvnw clean test
    - ./mvnw verify sonar:sonar
  coverage: '/Code Coverage: \d+\.\d+%/'
  artifacts:
    reports:
      junit:
        - '**/target/surefire-reports/TEST-*.xml'
```

### Criterios de Aceptación

Para que un PR sea mergeado debe cumplir:

- ✅ Todos los tests unitarios pasando
- ✅ Todos los tests de integración pasando
- ✅ SonarQube Quality Gate passed
- ✅ Cobertura de código mínima: 10%
- ✅ 0 vulnerabilidades de seguridad

---

## 🚀 Pruebas de Rendimiento

Para documentación completa sobre pruebas de rendimiento y performance testing con Locust, ver:

➡️ **[09-performance-testing.md](09-performance-testing.md)** (Documento dedicado - En preparación)

Este documento cubrirá:

- ✅ Setup de Locust
- ✅ Escenarios de carga
- ✅ Análisis de resultados
- ✅ Identificación de cuellos de botella

---

## 📊 Resumen de Testing

### Alcance de Pruebas

| Tipo | Cantidad | Estado |
|------|----------|--------|
| **Unit Tests** | 50+ | ✅ Implementado |
| **Integration Tests** | 20+ | ✅ Implementado |
| **E2E Tests** | 8 colecciones | ✅ Implementado |
| **SonarQube** | Full Analysis | ✅ Implementado |
| **Performance Tests** | Locust | 📅 Próximo documento |

### Best Practices Implementadas

- ✅ Tests independientes y aislables
- ✅ Uso de Testcontainers para tests realistas
- ✅ Mocking apropiado de dependencias
- ✅ Cobertura de código medida
- ✅ Integración en CI/CD
- ✅ Análisis de calidad con SonarQube
- ✅ Flujos E2E completos

---

## 🔗 Referencias

- [JUnit 5 Documentation](https://junit.org/junit5/docs/current/user-guide/)
- [Testcontainers](https://www.testcontainers.org/)
- [Postman API Testing](https://learning.postman.com/docs/writing-scripts/test-scripts/)
- [SonarQube](https://docs.sonarqube.org/)

---

**Siguiente paso**: [06-correcciones-mejoras.md](06-correcciones-mejoras.md)

**Documento relacionado**: [09-performance-testing.md](09-performance-testing.md) - Testing de rendimiento con Locust


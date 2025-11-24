# Scripts y Automatización

## 🤖 Introducción

Este documento detalla todos los scripts de automatización implementados para facilitar el desarrollo, construcción, despliegue y mantenimiento del proyecto.

## 📁 Estructura de Scripts

```
scripts/
├── build-images.sh                          # Construir todas las imágenes Docker
├── deploy-k8s.sh                            # Desplegar en Kubernetes
├── load-images-minikube.sh                  # Cargar imágenes en Minikube
├── minikube-setup.sh                        # Configuración inicial de Minikube
├── port-forward-all-services-nohup.sh      # Port-forwarding de todos los servicios
├── rebuild-service.sh                       # Reconstruir un servicio específico
├── start-minikube.sh                        # Iniciar Minikube
└── stop-port-forward-all-services-nohup.sh  # Detener port-forwarding
```

## 🔧 Scripts Principales

### 1. start-minikube.sh

**Propósito**: Iniciar Minikube con configuración optimizada

```bash
#!/bin/bash

echo "🚀 Iniciando Minikube..."

# Verificar si Minikube ya está corriendo
if minikube status | grep -q "Running"; then
    echo "✅ Minikube ya está corriendo"
    minikube status
    exit 0
fi

# Iniciar Minikube con recursos apropiados
minikube start \
  --cpus=4 \
  --memory=8192 \
  --disk-size=20g \
  --driver=docker

# Verificar inicio exitoso
if [ $? -ne 0 ]; then
    echo "❌ Error al iniciar Minikube"
    exit 1
fi

# Habilitar addons útiles
echo ""
echo "📦 Habilitando addons..."
minikube addons enable metrics-server
minikube addons enable dashboard

echo ""
echo "✅ Minikube iniciado correctamente"
echo ""
echo "📊 Estado del clúster:"
kubectl cluster-info
echo ""
echo "📈 Nodos disponibles:"
kubectl get nodes
echo ""
echo "🎯 Para acceder al dashboard:"
echo "   minikube dashboard"
```

**Uso**:

```bash
./scripts/start-minikube.sh
```

**Características**:

- ✅ Verifica si ya está corriendo
- ✅ Configuración optimizada (4 CPU, 8GB RAM)
- ✅ Habilita addons útiles
- ✅ Muestra estado del clúster

### 2. build-images.sh

**Propósito**: Construir todas las imágenes Docker automáticamente

**Script completo** (ya documentado en [02-containerizacion-docker.md](02-containerizacion-docker.md))

**Características principales**:

- ✅ Build en dos fases (Maven + Docker)
- ✅ Validaciones exhaustivas
- ✅ Reporte detallado de resultados
- ✅ Manejo de errores sin detener todo el proceso
- ✅ Estadísticas de construcción

**Uso**:

```bash
./scripts/build-images.sh
```

**Variables de entorno**:

```bash
# Cambiar tag de imágenes
export BRANCH_TAG=dev
./scripts/build-images.sh

# Cambiar registry
export REGISTRY=my-registry.io/username
./scripts/build-images.sh
```

### 3. load-images-minikube.sh

**Propósito**: Cargar imágenes Docker en el registro de Minikube

```bash
#!/bin/bash

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SERVICES=(
    "service-discovery"
    "cloud-config"
    "api-gateway"
    "proxy-client"
    "user-service"
    "product-service"
    "favourite-service"
    "order-service"
    "payment-service"
    "shipping-service"
)

REGISTRY="ghcr.io/davidone007"
TAG="${1:-latest}"

echo -e "${BLUE}📦 Cargando imágenes en Minikube...${NC}"
echo "🏷️  Tag: $TAG"
echo ""

# Verificar que Minikube está corriendo
if ! minikube status | grep -q "Running"; then
    echo -e "${RED}❌ Minikube no está corriendo${NC}"
    echo "Inicia Minikube primero: ./scripts/start-minikube.sh"
    exit 1
fi

LOADED=0
FAILED=0

for service in "${SERVICES[@]}"; do
    IMAGE="${REGISTRY}/${service}:${TAG}"
    echo -e "${YELLOW}⏳ Cargando: $IMAGE${NC}"
    
    # Verificar que la imagen existe localmente
    if ! docker image inspect "$IMAGE" &> /dev/null; then
        echo -e "${RED}❌ Imagen no encontrada: $IMAGE${NC}"
        echo "   Construye la imagen primero: ./scripts/build-images.sh"
        ((FAILED++))
        echo ""
        continue
    fi
    
    # Cargar imagen en Minikube
    minikube image load "$IMAGE" 2>&1 | grep -v "Loaded image"
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo -e "${GREEN}✅ $service cargado${NC}"
        ((LOADED++))
    else
        echo -e "${RED}❌ Error cargando $service${NC}"
        ((FAILED++))
    fi
    echo ""
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo "Resumen:"
echo -e "${GREEN}✅ Cargadas: ${LOADED}/${#SERVICES[@]}${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}❌ Fallidas: ${FAILED}/${#SERVICES[@]}${NC}"
fi
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

# Mostrar imágenes en Minikube
echo "📊 Imágenes en Minikube:"
minikube image ls | grep davidone007
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✨ Todas las imágenes cargadas exitosamente${NC}"
    echo ""
    echo "📚 Próximo paso:"
    echo "   ./scripts/deploy-k8s.sh $TAG"
else
    echo -e "${RED}⚠️  Algunas imágenes no se pudieron cargar${NC}"
    exit 1
fi
```

**Uso**:

```bash
# Con tag por defecto (latest)
./scripts/load-images-minikube.sh

# Con tag específico
./scripts/load-images-minikube.sh dev
```

### 4. deploy-k8s.sh

**Script completo** ya documentado en [03-orquestacion-kubernetes.md](03-orquestacion-kubernetes.md)

**Características principales**:

- ✅ Reemplazo dinámico de ${BRANCH_TAG}
- ✅ Agrega imagePullPolicy automáticamente
- ✅ Validaciones pre-despliegue
- ✅ Preview de cambios antes de aplicar
- ✅ Confirmación interactiva

### 5. port-forward-all-services-nohup.sh

**Propósito**: Habilitar acceso a todos los servicios desde localhost

**Script completo** ya documentado en [03-orquestacion-kubernetes.md](03-orquestacion-kubernetes.md)

**Características**:

- ✅ Port-forward de 11 servicios simultáneamente
- ✅ Ejecuta en background con nohup
- ✅ Logs individuales por servicio
- ✅ Guarda PIDs para poder detenerlos
- ✅ Colores y formato amigable

**Uso**:

```bash
# Iniciar port-forwarding
./scripts/port-forward-all-services-nohup.sh

# Ver logs de un servicio
tail -f scripts/port-forward-logs/api-gateway-container.log

# Detener todos los port-forwards
./scripts/stop-port-forward-all-services-nohup.sh
```

### 6. stop-port-forward-all-services-nohup.sh

**Propósito**: Detener todos los port-forwards activos

```bash
#!/bin/bash

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID_FILE="$BASE_DIR/scripts/port-forward-pids.txt"

if [ ! -f "$PID_FILE" ]; then
    echo -e "${YELLOW}⚠️  No hay port-forwards activos${NC}"
    exit 0
fi

if [ ! -s "$PID_FILE" ]; then
    echo -e "${YELLOW}⚠️  Archivo de PIDs vacío${NC}"
    rm -f "$PID_FILE"
    exit 0
fi

echo "🛑 Deteniendo port-forwards..."
echo ""

STOPPED=0
NOT_FOUND=0

while IFS= read -r line; do
    PID=$(echo "$line" | awk '{print $1}')
    SERVICE=$(echo "$line" | awk '{print $2}')
    PORT=$(echo "$line" | awk '{print $3}')
    
    echo -e "${YELLOW}⏳ Deteniendo $SERVICE (PID: $PID, Puerto: $PORT)${NC}"
    
    # Verificar si el proceso existe
    if ps -p "$PID" > /dev/null 2>&1; then
        kill "$PID" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Detenido${NC}"
            ((STOPPED++))
        else
            echo -e "${RED}❌ Error al detener (puede requerir permisos)${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Proceso no encontrado (ya detenido?)${NC}"
        ((NOT_FOUND++))
    fi
    echo ""
done < "$PID_FILE"

# Limpiar archivo de PIDs
> "$PID_FILE"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo "Resumen:"
echo -e "${GREEN}✅ Detenidos: $STOPPED${NC}"
if [ $NOT_FOUND -gt 0 ]; then
    echo -e "${YELLOW}⚠️  No encontrados: $NOT_FOUND${NC}"
fi
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Port-forwarding detenido${NC}"

# Limpiar logs viejos (opcional)
LOG_DIR="$BASE_DIR/scripts/port-forward-logs"
if [ -d "$LOG_DIR" ]; then
    echo ""
    read -p "¿Eliminar logs antiguos? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -f "$LOG_DIR"/*.log
        echo -e "${GREEN}✅ Logs eliminados${NC}"
    fi
fi
```

### 7. rebuild-service.sh

**Propósito**: Reconstruir y redesplegar un servicio específico rápidamente

```bash
#!/bin/bash

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Validar argumentos
if [ $# -lt 1 ]; then
    echo "Uso: $0 <service-name> [tag]"
    echo ""
    echo "Servicios disponibles:"
    echo "  - service-discovery"
    echo "  - cloud-config"
    echo "  - api-gateway"
    echo "  - proxy-client"
    echo "  - user-service"
    echo "  - product-service"
    echo "  - order-service"
    echo "  - payment-service"
    echo "  - shipping-service"
    echo "  - favourite-service"
    exit 1
fi

SERVICE="$1"
TAG="${2:-latest}"
REGISTRY="ghcr.io/davidone007"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${BLUE}🔨 Reconstruyendo servicio: $SERVICE${NC}"
echo "🏷️  Tag: $TAG"
echo ""

# Validar que el servicio existe
if [ ! -d "$BASE_DIR/$SERVICE" ]; then
    echo -e "${RED}❌ Servicio no encontrado: $SERVICE${NC}"
    exit 1
fi

# Paso 1: Compilar con Maven
echo -e "${BLUE}📦 Paso 1: Compilando con Maven...${NC}"
cd "$BASE_DIR/$SERVICE"

./mvnw clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error en compilación${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Compilación exitosa${NC}"
echo ""

# Paso 2: Construir imagen Docker
echo -e "${BLUE}🐳 Paso 2: Construyendo imagen Docker...${NC}"
cd "$BASE_DIR"

IMAGE_NAME="${REGISTRY}/${SERVICE}:${TAG}"
docker build -t "$IMAGE_NAME" \
    --build-arg PROJECT_VERSION="0.1.0" \
    -f "$SERVICE/Dockerfile" \
    .

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error en build de Docker${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Imagen construida${NC}"
echo ""

# Paso 3: Cargar en Minikube
echo -e "${BLUE}📦 Paso 3: Cargando en Minikube...${NC}"
minikube image load "$IMAGE_NAME"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error cargando en Minikube${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Imagen cargada en Minikube${NC}"
echo ""

# Paso 4: Reiniciar deployment
echo -e "${BLUE}🔄 Paso 4: Reiniciando deployment en Kubernetes...${NC}"
kubectl rollout restart deployment/${SERVICE}-container

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error reiniciando deployment${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Deployment reiniciado${NC}"
echo ""

# Paso 5: Esperar a que esté listo
echo -e "${BLUE}⏳ Esperando a que el pod esté listo...${NC}"
kubectl rollout status deployment/${SERVICE}-container

echo ""
echo -e "${GREEN}✨ Servicio reconstruido y desplegado exitosamente${NC}"
echo ""
echo "📊 Estado del pod:"
kubectl get pods | grep "$SERVICE"
```

**Uso**:

```bash
# Reconstruir servicio con tag por defecto
./scripts/rebuild-service.sh api-gateway

# Con tag específico
./scripts/rebuild-service.sh api-gateway dev
```

**Cuándo usar**:

- Desarrollo activo en un servicio específico
- Debugging de un servicio
- Evita reconstruir todos los servicios

## 🎯 Flujos de Trabajo Completos

### Flujo 1: Setup Inicial

```bash
# 1. Iniciar Minikube
./scripts/start-minikube.sh

# 2. Construir todas las imágenes
./scripts/build-images.sh

# 3. Cargar imágenes en Minikube
./scripts/load-images-minikube.sh latest

# 4. Desplegar en Kubernetes
./scripts/deploy-k8s.sh latest

# 5. Habilitar port-forwarding
./scripts/port-forward-all-services-nohup.sh

# 6. Verificar que todo está corriendo
kubectl get pods
```

### Flujo 2: Actualizar un Servicio

```bash
# Opción rápida: usar rebuild-service.sh
./scripts/rebuild-service.sh user-service

# Opción completa:
# 1. Hacer cambios en el código
# 2. Reconstruir solo ese servicio
cd user-service
./mvnw clean package

# 3. Build Docker
docker build -t ghcr.io/davidone007/user-service:dev \
    --build-arg PROJECT_VERSION="0.1.0" \
    -f Dockerfile \
    ..

# 4. Cargar en Minikube
minikube image load ghcr.io/davidone007/user-service:dev

# 5. Reiniciar deployment
kubectl rollout restart deployment/user-service-container
```

### Flujo 3: Limpiar Todo

```bash
# 1. Detener port-forwards
./scripts/stop-port-forward-all-services-nohup.sh

# 2. Eliminar recursos de Kubernetes
kubectl delete -f k8s/

# 3. Detener Minikube
minikube stop

# 4. Eliminar Minikube (si quieres empezar desde cero)
minikube delete
```

## 📊 Tiempos de Ejecución

| Script | Tiempo | Descripción |
|--------|--------|-------------|
| start-minikube.sh | ~2-3min | Primera vez, ~10s si ya está corriendo |
| build-images.sh | ~5-7min | Build completo de 10 servicios |
| load-images-minikube.sh | ~2-3min | Cargar 10 imágenes |
| deploy-k8s.sh | ~1-2min | Aplicar todos los manifiestos |
| rebuild-service.sh | ~1-2min | Un servicio individual |
| port-forward... | ~5-10s | Iniciar todos los forwards |

## ✅ Best Practices Implementadas

### 1. Validaciones

Todos los scripts validan:

- ✅ Que las herramientas necesarias estén instaladas
- ✅ Que los archivos/directorios necesarios existan
- ✅ Que comandos previos fueron exitosos
- ✅ Estado de Minikube antes de operar

### 2. Manejo de Errores

```bash
# Verificar éxito de comando
if [ $? -ne 0 ]; then
    echo "Error"
    exit 1
fi

# Set -e para detener en cualquier error (cuando apropiado)
set -e
```

### 3. Salida Coloreada

```bash
GREEN='\033[0;32m'
RED='\033[0;31m'
echo -e "${GREEN}✅ Éxito${NC}"
echo -e "${RED}❌ Error${NC}"
```

### 4. Confirmaciones Interactivas

```bash
read -p "¿Continuar? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    exit 0
fi
```

### 5. Logging

```bash
# Logs a archivo
command > logfile.log 2>&1

# Logs con timestamp
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Mensaje" >> log.txt
```

## 🎓 Lessons Learned

### ✅ Lo que Funcionó Bien

1. **Scripts modulares**: Un script por tarea específica
2. **Validaciones exhaustivas**: Previene errores comunes
3. **Feedback visual**: Colores y emojis hacen output más claro
4. **Variables de entorno**: Configuración flexible

### 🔧 Lo que Mejoraría

1. **Makefile**: Centralizar todos los comandos
2. **CI/CD integration**: Auto-ejecutar scripts en pipelines
3. **Logs centralizados**: Todos los logs en un directorio
4. **Unit tests para scripts**: Validar comportamiento

## 📚 Makefile Propuesto (Futuro)

```makefile
.PHONY: setup build deploy clean rebuild logs

setup:
	./scripts/start-minikube.sh

build:
	./scripts/build-images.sh

load:
	./scripts/load-images-minikube.sh latest

deploy:
	./scripts/deploy-k8s.sh latest

port-forward:
	./scripts/port-forward-all-services-nohup.sh

rebuild-%:
	./scripts/rebuild-service.sh $*

clean:
	./scripts/stop-port-forward-all-services-nohup.sh
	kubectl delete -f k8s/

logs-%:
	kubectl logs -f deployment/$*-container

all: setup build load deploy port-forward
```

**Uso con Makefile**:

```bash
make setup         # Iniciar Minikube
make build         # Build imágenes
make deploy        # Deploy completo
make rebuild-api-gateway  # Rebuild servicio específico
make logs-user-service   # Ver logs
make clean         # Limpiar todo
make all           # Setup completo
```

## ✅ Conclusión

Los scripts de automatización implementados permiten:

- ✅ Setup completo en ~15 minutos
- ✅ Rebuild de servicio individual en ~2 minutos
- ✅ Deploy sin errores manuales
- ✅ Experiencia de desarrollo fluida
- ✅ Onboarding fácil para nuevos desarrolladores

**Siguiente y último documento**: [08-release-notes.md](08-release-notes.md)

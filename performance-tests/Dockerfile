# Dockerfile para Pruebas de Rendimiento con Locust
# ================================================

FROM python:3.11-slim

LABEL maintainer="Performance Testing Team"
LABEL description="Container para ejecutar pruebas de rendimiento con Locust en E-commerce Microservices"

# Variables de entorno
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    LOCUST_MODE=standalone

# Directorio de trabajo
WORKDIR /performance-tests

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    libev-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar archivos de requirements
COPY requirements.txt .

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar archivos de pruebas
COPY locustfile.py .
COPY config/ ./config/
COPY scripts/ ./scripts/

# Exponer puerto de Locust Web UI
EXPOSE 8089

# Crear directorio para resultados
RUN mkdir -p /performance-tests/results

# Script de entrada por defecto
ENTRYPOINT ["locust"]

# Argumentos por defecto (pueden ser sobrescritos)
CMD ["--web-host", "0.0.0.0", "--web-port", "8089"]

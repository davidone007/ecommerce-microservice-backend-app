# Pasos para Despliegue de Producción con IP Estática

## PASO 0: Crear la IP Pública Estática (SOLO UNA VEZ)

Antes de hacer el despliegue de Terraform, debes crear manualmente la IP pública estática que nunca se destruirá:

### 0.1. Crear el Resource Group para recursos estáticos
```bash
az group create \
  --name ecommerce-static-resources \
  --location eastus
```

### 0.2. Crear la IP Pública Estática
```bash
az network public-ip create \
  --resource-group ecommerce-static-resources \
  --name ecommerce-prod-ip \
  --sku Standard \
  --allocation-method Static \
  --location eastus
```

### 0.3. Obtener la IP asignada (para configurar tu DNS)
```bash
az network public-ip show \
  --resource-group ecommerce-static-resources \
  --name ecommerce-prod-ip \
  --query ipAddress \
  --output tsv
```

**Guarda esta IP** - la necesitarás para configurar tu dominio en el DNS.

---

## PASO 1: Despliegue de Terraform

Una vez creada la IP estática, procede con el despliegue normal:

### 1.1. Inicializar Terraform
```bash
cd terraform/environments/prod
terraform init
```

### 1.2. Desplegar AKS primero
```bash
terraform apply -target=module.aks -auto-approve
```

### 1.3. Desplegar el resto con el secreto JWT
```bash
terraform apply -var="jwt_secret_value=secret123" -auto-approve
```

---

## PASO 2: Verificar la IP del Ingress

Al finalizar el despliegue, Terraform mostrará la IP pública:

```bash
terraform output ingress_public_ip
```

Esta IP debe coincidir con la que creaste en el PASO 0.

---

## PASO 3: Configurar DNS

Apunta tu dominio a la IP obtenida. Por ejemplo:

```
A record: ecommerce.tudominio.com -> [IP_PUBLICA]
```

---

## IMPORTANTE: Destrucción de Infraestructura

Si haces `terraform destroy`, la IP pública **NO se destruirá** porque está en un Resource Group separado que no gestiona Terraform.

Para destruir TODO (incluyendo la IP):

```bash
# Destruir la infraestructura de Terraform
cd terraform/environments/prod
terraform destroy -var="jwt_secret_value=secret123"

# Destruir manualmente la IP estática (OPCIONAL)
az group delete --name ecommerce-static-resources --yes
```

---

## Notas

- La IP estática solo se crea **una vez**
- Terraform la **lee** pero no la gestiona
- Puedes destruir y recrear el cluster AKS sin perder la IP
- El certificado TLS se renovará automáticamente con Let's Encrypt

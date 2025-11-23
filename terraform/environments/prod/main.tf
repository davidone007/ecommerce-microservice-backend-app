module "aks" {
  source              = "../../modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
}

data "azurerm_client_config" "current" {}

module "cert_manager" {
  source = "../../modules/cert-manager"
  email  = var.email

  depends_on = [module.aks]
}

module "ingress_nginx" {
  source = "../../modules/ingress-nginx"

  depends_on = [module.aks]
}

module "helm_release" {
  source       = "../../modules/helm-release"
  release_name = "ecommerce-microservices"
  chart_path   = "../../../helm/ecommerce-microservices"
  namespace    = "prod"
  values_file  = "values.yaml"
  timeout      = 1200

  depends_on = [module.aks, module.cert_manager, module.ingress_nginx]
}

module "rbac" {
  source    = "../../modules/k8s-rbac"
  namespace = "prod"

  depends_on = [module.aks, module.helm_release]
}

module "keyvault" {
  source                                  = "../../modules/keyvault"
  key_vault_name                          = "ecommerce-kv-${random_string.suffix.result}"
  location                                = var.location
  resource_group_name                     = var.resource_group_name
  aks_key_vault_secret_provider_object_id = module.aks.key_vault_secrets_provider_identity_object_id
  jwt_secret_value                        = var.jwt_secret_value

  depends_on = [module.aks]
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}



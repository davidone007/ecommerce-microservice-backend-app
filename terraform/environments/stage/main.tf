module "aks" {
  source              = "../../modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
  tags                = var.tags
}

data "azurerm_client_config" "current" {}

module "helm_release" {
  source       = "../../modules/helm-release"
  release_name = "ecommerce-microservices"
  chart_path   = "../../../helm/ecommerce-microservices"
  namespace    = "stage"
  values_file  = "values.yaml"

  set_values = {
    "keyVault.name"                   = module.keyvault.key_vault_name
    "keyVault.tenantId"               = data.azurerm_client_config.current.tenant_id
    "keyVault.userAssignedIdentityID" = module.aks.key_vault_secrets_provider_identity_client_id
  }

  depends_on = [module.aks, module.keyvault]
}

module "sonarqube" {
  source       = "../../modules/sonarqube"
  service_type = "ClusterIP"

  depends_on = [module.aks]
}

module "keyvault" {
  source                                  = "../../modules/keyvault"
  key_vault_name                          = "ecom-kv-stg-${random_string.suffix.result}"
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

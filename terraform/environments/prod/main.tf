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

# Data source para leer la IP pública estática creada manualmente
data "azurerm_public_ip" "ingress" {
  name                = var.static_ip_name
  resource_group_name = var.static_ip_resource_group
}

# Data source para obtener el resource group de la IP estática
data "azurerm_resource_group" "static_ip_rg" {
  name = var.static_ip_resource_group
}

# Role assignment para que AKS pueda usar la IP estática
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = data.azurerm_resource_group.static_ip_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.kubelet_identity_object_id

  depends_on = [module.aks]
}

# Grant the AKS cluster's control-plane identity Network Contributor on the
# static IP resource group so the control-plane (load balancer creation) can
# attach/operate on public IPs. The identity principal may be different from
# the kubelet identity and is exposed by the aks module as
# module.aks.identity_principal_id
resource "azurerm_role_assignment" "aks_control_plane_network_contributor" {
  scope                = data.azurerm_resource_group.static_ip_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.identity_principal_id

  depends_on = [module.aks]
}

# Small wait to allow Azure RBAC role assignments to propagate before we attempt
# to provision resources which depend on those permissions (LoadBalancer creation
# can be immediate but the identity permissions often propagate with a small
# delay). This avoids races where Helm installs a chart that triggers LB
# creation before AAD permissions are usable.
resource "time_sleep" "wait_for_rbac" {
  create_duration = "30s"
}

# Ensure the AKS secret-provider user-assigned identity has Key Vault access
# rights. This uses the object id published by the aks module and creates a
# KeyVault access policy granting read/list on secrets so the CSI driver can
# mount the secret into pods.
/* access policy for the secret provider is configured inside the
   keyvault module using module.aks.key_vault_secrets_provider_identity_object_id
   so a separate azurerm_key_vault_access_policy resource is unnecessary and
   would conflict when the same object id is present. */

# (duplicate role assignment removed) azurerm_role_assignment.aks_network_contributor

module "cert_manager" {
  source = "../../modules/cert-manager"
  email  = var.email

  depends_on = [module.aks]
}

module "ingress_nginx" {
  source = "../../modules/ingress-nginx"

  load_balancer_ip         = data.azurerm_public_ip.ingress.ip_address
  static_ip_resource_group = var.static_ip_resource_group

  # Ensure the role assignments are created and have time to propagate before
  # we install the ingress (which triggers LoadBalancer actions).
  depends_on = [
    module.aks,
    azurerm_role_assignment.aks_network_contributor,
    azurerm_role_assignment.aks_control_plane_network_contributor,
    time_sleep.wait_for_rbac,
  ]
}

module "helm_release" {
  source       = "../../modules/helm-release"
  release_name = "ecommerce-microservices"
  chart_path   = "../../../helm/ecommerce-microservices"
  namespace    = "prod"
  values_file  = "values.yaml"

  set_values = {
    "keyVault.name"                   = module.keyvault.key_vault_name
    "keyVault.tenantId"               = data.azurerm_client_config.current.tenant_id
    "keyVault.userAssignedIdentityID" = module.aks.key_vault_secrets_provider_identity_client_id
  }

  # Ensure RBAC + ingress are ready before attempting application helm release.
  depends_on = [
    module.aks,
    module.cert_manager,
    module.ingress_nginx,
    module.keyvault,
    azurerm_role_assignment.aks_network_contributor,
    azurerm_role_assignment.aks_control_plane_network_contributor,
    time_sleep.wait_for_rbac,
    /* azurerm_key_vault_access_policy.aks_secret_provider_policy, */
  ]
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

# Output para mostrar la IP pública del Ingress
output "ingress_public_ip" {
  description = "Public IP address for the ingress controller"
  value       = data.azurerm_public_ip.ingress.ip_address
}

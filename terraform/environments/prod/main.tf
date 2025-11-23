module "aks" {
  source              = "../../modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
}

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

  extra_values = yamlencode({
    secrets = {
      enabled      = true
      keyVaultName = var.key_vault_name
      tenantId     = module.aks.tenant_id
      objects = [
        {
          secretName = "database-secret"
          data = [
            {
              objectName = "database-password"
              key        = "password"
            }
          ]
        }
      ]
    }
  })

  depends_on = [module.aks, module.cert_manager, module.ingress_nginx, module.key_vault]
}

module "rbac" {
  source    = "../../modules/k8s-rbac"
  namespace = "prod"

  depends_on = [module.aks, module.helm_release]
}

module "key_vault" {
  source                        = "../../modules/key-vault"
  key_vault_name                = var.key_vault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  aks_secret_provider_object_id = module.aks.key_vault_secrets_provider_object_id
  tenant_id                     = module.aks.tenant_id

  depends_on = [module.aks]
}



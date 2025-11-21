module "aks" {
  source              = "../../modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
}

module "helm_release" {
  source       = "../../modules/helm-release"
  release_name = "ecommerce-microservices"
  chart_path   = "../../../helm/ecommerce-microservices"
  namespace    = "prod"
  values_file  = "values.yaml"

  depends_on = [module.aks]
}


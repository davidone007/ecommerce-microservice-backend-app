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

module "helm_release" {
  source       = "../../modules/helm-release"
  release_name = "ecommerce-microservices"
  chart_path   = "../../../helm/ecommerce-microservices"
  namespace    = "stage"
  values_file  = "values.yaml"

  depends_on = [module.aks]
}

module "sonarqube" {
  source = "../../modules/sonarqube"
  service_type = "ClusterIP"

  depends_on = [module.aks]
}

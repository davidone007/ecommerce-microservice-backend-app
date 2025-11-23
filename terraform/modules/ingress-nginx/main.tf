resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.8.3"

  # Helm waits for resources to be ready; on cloud providers (AKS) LoadBalancer
  # provisioning can take several minutes. Increase timeout to avoid 'context
  # deadline exceeded' when Terraform/Helm tries to wait for the Release to
  # become ready. Make the release atomic so failed installations are rolled
  # back automatically.
  atomic  = true
  wait    = true
  timeout = 900

  values = [
    yamlencode({
      controller = {
        service = {
          loadBalancerIP = "172.210.123.215"
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
            "service.beta.kubernetes.io/azure-load-balancer-resource-group"            = "MC_ecommerce-rg-prod_ecommerce-aks-prod_eastus"
          }
        }
      }
    })
  ]
}

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.8.3"

  # Use provider defaults for wait/timeout/atomic to keep a standard Helm
  # behaviour and reduce surprises on retries.

  values = [
    yamlencode({
      controller = {
        service = {
          loadBalancerIP = var.load_balancer_ip
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
            "service.beta.kubernetes.io/azure-load-balancer-resource-group"            = var.static_ip_resource_group
          }
        }
      }
    })
  ]
}

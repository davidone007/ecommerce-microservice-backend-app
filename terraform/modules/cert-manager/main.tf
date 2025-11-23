resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.13.3"

  values = [
    yamlencode({
      installCRDs = true
    })
  ]
}

resource "time_sleep" "wait_for_cert_manager" {
  depends_on = [helm_release.cert_manager]

  create_duration = "30s"
}

resource "helm_release" "cluster_issuer" {
  depends_on = [time_sleep.wait_for_cert_manager]

  name      = "cluster-issuer"
  chart     = "${path.module}/cluster-issuer-chart"
  namespace = "cert-manager"

  set {
    name  = "email"
    value = var.email
  }
}

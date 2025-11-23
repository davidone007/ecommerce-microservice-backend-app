resource "helm_release" "ecommerce" {
  name             = var.release_name
  chart            = var.chart_path
  namespace        = var.namespace
  create_namespace = true

  values = [
    file(var.values_file)
  ]
}

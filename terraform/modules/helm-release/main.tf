resource "helm_release" "ecommerce" {
  name             = var.release_name
  chart            = var.chart_path
  namespace        = var.namespace
  create_namespace = true
  timeout          = 1000
  wait             = true

  values = [
    file(var.values_file)
  ]


  dynamic "set" {
    for_each = var.set_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

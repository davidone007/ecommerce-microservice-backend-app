variable "namespace" {
  description = "Namespace to apply RBAC"
  type        = string
}

# 1. Creamos una ServiceAccount simulando un usuario desarrollador
resource "kubernetes_service_account" "dev_user" {
  metadata {
    name      = "dev-user"
    namespace = var.namespace
  }
}

# 2. Creamos un Role con permisos de lectura
resource "kubernetes_role" "dev_reader" {
  metadata {
    name      = "dev-reader"
    namespace = var.namespace
  }

  rule {
    api_groups = ["", "apps", "networking.k8s.io"]
    resources  = ["pods", "services", "deployments", "ingresses", "configmaps", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
}

# 3. Hacemos el Binding (Vinculación) entre el Usuario y el Rol
resource "kubernetes_role_binding" "dev_binding" {
  metadata {
    name      = "dev-user-binding"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.dev_reader.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.dev_user.metadata.0.name
    namespace = var.namespace
  }
}

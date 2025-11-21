variable "service_type" {
  description = "Kubernetes Service Type (ClusterIP, LoadBalancer, NodePort)"
  type        = string
  default     = "LoadBalancer"
}

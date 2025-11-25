variable "load_balancer_ip" {
  description = "Static public IP address for the ingress controller"
  type        = string
}

variable "static_ip_resource_group" {
  description = "The resource group where the static public IP is located"
  type        = string
}

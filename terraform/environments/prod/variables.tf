variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "ecommerce-rg-prod"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "ecommerce-aks-prod"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "ecommerce-prod"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for the nodes"
  type        = string
  default     = "Standard_E2_v3"

}

variable "email" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
  default     = "davidecazaran@gmail.com"
}

variable "jwt_secret_value" {
  description = "Value of the JWT secret"
  type        = string
  sensitive   = true
  default     = "mysecretkey" # In a real scenario, this should be passed via -var or environment variable
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "static_ip_name" {
  description = "Name of the static public IP created manually"
  type        = string
  default     = "ecommerce-prod-ip"
}

variable "static_ip_resource_group" {
  description = "Resource group where the static public IP is located"
  type        = string
  default     = "ecommerce-static-resources"
}


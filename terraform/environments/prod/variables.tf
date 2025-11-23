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
  default     = 1
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

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "ecommerce-kv-prod-001"
}


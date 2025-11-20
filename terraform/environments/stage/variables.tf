variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "ecommerce-rg-stage"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "ecommerce-aks-stage"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "ecommerce-stage"
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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Stage"
    Project     = "Ecommerce"
  }
}


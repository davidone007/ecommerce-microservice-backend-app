variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "aks_secret_provider_object_id" {
  description = "Object ID of the AKS Key Vault Secrets Provider identity"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}

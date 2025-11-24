variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "aks_key_vault_secret_provider_object_id" {
  description = "Object ID of the AKS Key Vault Secrets Provider identity"
  type        = string
}

variable "jwt_secret_value" {
  description = "Value of the JWT secret"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

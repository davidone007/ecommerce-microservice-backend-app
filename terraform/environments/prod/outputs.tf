output "resource_group_name" {
  value = module.aks.resource_group_name
}

output "cluster_name" {
  value = module.aks.cluster_name
}

output "key_vault_name" {
  value = module.keyvault.key_vault_name
}

output "key_vault_id" {
  value = module.keyvault.key_vault_id
}

output "key_vault_secrets_provider_identity_client_id" {
  value = module.aks.key_vault_secrets_provider_identity_client_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

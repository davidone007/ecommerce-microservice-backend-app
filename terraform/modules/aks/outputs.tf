output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
}

output "key_vault_secrets_provider_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
}

output "key_vault_secrets_provider_identity_client_id" {
  value = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id
}

output "node_resource_group" {
  description = "The auto-generated resource group where AKS nodes are deployed"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "kubelet_identity_object_id" {
  description = "The object ID of the kubelet identity used by AKS"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "identity_principal_id" {
  description = "The principal id of the cluster's systemAssigned identity (control plane)"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

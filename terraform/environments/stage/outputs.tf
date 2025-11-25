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

# Monitoring Stack Outputs
output "monitoring_namespace" {
  description = "Monitoring namespace"
  value       = module.monitoring.namespace
}

output "grafana_service_name" {
  description = "Grafana service name for port-forward"
  value       = module.monitoring.grafana_service_name
}

output "prometheus_service_name" {
  description = "Prometheus service name for port-forward"
  value       = module.monitoring.prometheus_service_name
}

output "kibana_service_name" {
  description = "Kibana service name for port-forward"
  value       = module.monitoring.kibana_service_name
}

output "port_forward_commands" {
  description = "Commands to access monitoring services via port-forward"
  value       = module.monitoring.port_forward_commands
}

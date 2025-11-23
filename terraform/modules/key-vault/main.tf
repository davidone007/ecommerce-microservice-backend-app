data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  # Access policy for the user running Terraform (to create secrets)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Recover", "Purge", "GetRotationPolicy"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]

    certificate_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"
    ]
  }

  # Access policy for AKS Secrets Provider
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.aks_secret_provider_object_id

    secret_permissions = [
      "Get", "List"
    ]

    key_permissions = [
      "Get", "List"
    ]

    certificate_permissions = [
      "Get", "List"
    ]
  }
}

# Example Secret
resource "azurerm_key_vault_secret" "db_pass" {
  name         = "database-password"
  value        = "SuperSecretPassword123!"
  key_vault_id = azurerm_key_vault.kv.id
}

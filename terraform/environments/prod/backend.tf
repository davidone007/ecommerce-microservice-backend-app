terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate41265"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

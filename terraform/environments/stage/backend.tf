terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateunique12345"
    container_name       = "tfstate"
    key                  = "stage.terraform.tfstate"
  }
}

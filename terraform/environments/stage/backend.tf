terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate30989"
    container_name       = "tfstate"
    key                  = "stage.terraform.tfstate"
  }
}

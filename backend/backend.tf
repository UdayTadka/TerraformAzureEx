
terraform {
    backend "azurerm" {
    resource_group_name   = "backendtfrg"
    storage_account_name  = "tfstrgad12"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "eastus"
}

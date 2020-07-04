provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  subscription_id = "690d60be-a9af-477b-887d-b6b8353c4483"
  client_id       = "bbc420c7-3a9c-4b6e-b92a-fabf6f3b8a83"
  client_secret   = "7bd2b499-40fa-461c-acec-64e31c957a51"
  tenant_id       = "5e48715a-8e3e-424d-8443-393d18063e1a"
}
# Create a resource group
resource "azurerm_resource_group" "demorg" {
  name     = "demotfrg"
  location = "east us"
}
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  subscription_id = "690d60be-a9af-477b-887d-b6b8353c4483"
  client_id       = "0a7296eb-a8e8-4cee-ab1d-1ab9bd94b6ae"
  client_secret   = "${var.secret}"
  tenant_id       = "5e48715a-8e3e-424d-8443-393d18063e1a"
}


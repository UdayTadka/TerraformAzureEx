provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  subscription_id = "367f5532-2d88-410d-8b02-5e5c8f779c8e"
  client_id       = "0303da52-1db5-44c2-b6fa-29710468d7ae"
  client_secret   = "${var.secret}"
  tenant_id       = "4935eefd-5b0f-4deb-9c51-70dcc61f0f38"
}

resource "azurerm_resource_group" "demorg" {
  name     = "${var.rgname}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "tfvnet" {
    name = "terraformvnet"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    address_space = ["10.0.0.0/16"]
    location = "${var.location}"
}

resource "azurerm_subnet" "tfsubnet"{
  name = "terraformsubnet"
  resource_group_name = "${azurerm_resource_group.demorg.name}"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  address_prefix       = "10.0.1.0/24"
}

output "subnetid" {
  value = "${azurerm_subnet.tfsubnet.id}"
}

output "rgname" {
  value = "${azurerm_resource_group.demorg.name}"
}

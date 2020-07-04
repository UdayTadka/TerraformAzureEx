resource "azurerm_virtual_network" "tfvnet" {
    name = "vnet"
    resource_group_name = "${var.rgname}"
    address_space = ["10.0.0.0/16"]
    location = "${var.location}"
}

resource "azurerm_subnet" "tfsubnet"{
  name = "subnet"
  resource_group_name = "${var.rgname}"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  address_prefix       = "10.0.1.0/24"
}


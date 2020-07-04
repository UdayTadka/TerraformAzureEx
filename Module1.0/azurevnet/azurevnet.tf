resource "azurerm_virtual_network" "tfvnet" {
    name = "terraformvnet"
    resource_group_name = "${var.rgnamevnet}"
    address_space = ["10.0.0.0/16"]
    location = "${var.rglocationvnet}"
}

resource "azurerm_subnet" "tfsubnet"{
  name = "terraformsubnet"
  resource_group_name = "${var.rgnamevnet}"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  address_prefix       = "10.0.1.0/24"
}
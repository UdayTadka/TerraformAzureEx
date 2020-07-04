resource "azurerm_virtual_network" "tfvnet" {
    name = "${var.vnetname}"
    resource_group_name = "${var.rgnamevnet}"
    address_space = ["${var.addspa}"]
    location = "${var.rglocationvnet}"
}

resource "azurerm_subnet" "tfsubnet"{
  name = "${var.subnetname}"
  resource_group_name = "${var.rgnamevnet}"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
  address_prefix       = "${var.addpre}"
}
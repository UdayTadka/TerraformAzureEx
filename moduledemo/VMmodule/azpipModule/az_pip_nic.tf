resource "azurerm_public_ip" "tfpip" {
  name = "tpip"
  resource_group_name = "${var.rgname}"
  location = "${var.location}"
  #public_ip_address_allocation = "Dynamic"
  allocation_method   = "Dynamic"
  domain_name_label   =  "tfpip"
}

resource "azurerm_network_interface" "tfnic"{
  name = "trfnic"
  resource_group_name = "${var.rgname}"
  location = "${var.location}"

  ip_configuration {
    name                          = "trfconfig"
    subnet_id                     =  "${var.subnetid}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = "${azurerm_public_ip.tfpip.id}"
  }
}

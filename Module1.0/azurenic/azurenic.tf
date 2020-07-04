resource "azurerm_network_interface" "tfnic"{
  name = "terraformnic"
  resource_group_name = "${var.rgnamenic}"
  location = "${var.rglocationnic}"

  ip_configuration {
    name                          = "terraformconfig"
    subnet_id                     =  "${var.subnetid}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = "${var.publicipid}"
  }
}

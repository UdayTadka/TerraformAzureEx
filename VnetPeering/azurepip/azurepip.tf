
resource "azurerm_public_ip" "tfpip" {
  name = "${var.pipname}"
  resource_group_name = "${var.rgnamepip}"
  location = "${var.rglocationpip}"
  #public_ip_address_allocation = "Dynamic"
  allocation_method   = "Dynamic"
  domain_name_label   =  "${var.dnsname}"
}

provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  subscription_id = "367f5532-2d88-410d-8b02-5e5c8f779c8e"
  client_id       = "0303da52-1db5-44c2-b6fa-29710468d7ae"
  client_secret   = "${var.secret}"
  tenant_id       = "4935eefd-5b0f-4deb-9c51-70dcc61f0f38"
}

resource "azurerm_public_ip" "tfpip" {
  name = "terraformpip"
  resource_group_name = "${var.rgname}"
  location = "${var.location}"
  #public_ip_address_allocation = "Dynamic"
  allocation_method   = "Dynamic"
  domain_name_label   =  "tfpip"
}

resource "azurerm_network_interface" "tfnic"{
  name = "terraformnic"
  resource_group_name = "${var.rgname}"
  location = "${var.location}"

  ip_configuration {
    name                          = "terraformconfig"
    subnet_id                     =  "${var.subnetid}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = "${azurerm_public_ip.tfpip.id}}"
  }
}

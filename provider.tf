provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  subscription_id = "367f5532-2d88-410d-8b02-5e5c8f779c8e"
  client_id       = "0303da52-1db5-44c2-b6fa-29710468d7ae"
  client_secret   = "${var.secret}"
  tenant_id       = "4935eefd-5b0f-4deb-9c51-70dcc61f0f38"
}
# Create a resource group
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

resource "azurerm_public_ip" "tfpip" {
  name = "terraformpip"
  resource_group_name = "${azurerm_resource_group.demorg.name}"
  location = "${var.location}"
  #public_ip_address_allocation = "Dynamic"
  allocation_method   = "Dynamic"
  domain_name_label   =  "tfpip"
}

resource "azurerm_network_interface" "tfnic"{
  name = "terraformnic"
  resource_group_name = "${azurerm_resource_group.demorg.name}"
  location = "${var.location}"

  ip_configuration {
    name                          = "terraformconfig"
    subnet_id                     =  "${azurerm_subnet.tfsubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = "${azurerm_public_ip.tfpip.id}"
  }
}

resource "azurerm_virtual_machine" "tfvm"{
  name = "terrafromvm"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.demorg.name}"
  network_interface_ids = ["${azurerm_network_interface.tfnic.id}"]
  vm_size = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "myvm"
    admin_username = "adminuser"
    admin_password = "Password1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

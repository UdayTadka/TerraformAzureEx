provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  subscription_id = "367f5532-2d88-410d-8b02-5e5c8f779c8e"
  client_id       = "0303da52-1db5-44c2-b6fa-29710468d7ae"
  client_secret   = "${var.secret}"
  tenant_id       = "4935eefd-5b0f-4deb-9c51-70dcc61f0f38"
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

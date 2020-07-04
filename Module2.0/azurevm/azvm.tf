resource "azurerm_virtual_machine" "tfvm"{
  name = "terrafromvm"
  location              = "${var.rglocationvm}"
  resource_group_name   = "${var.rgnamevm}"
  network_interface_ids = ["${var.vmnicid}"]
 # ["${module.aznic.nicid}"]
  vm_size = "Standard_F2s_v2"

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
resource "azurerm_resource_group" "demorg" {
  name     = "${var.rgname}"
  location = "${var.location}"
}

module "azvnet" {
  source = "./azurevnet"
  #rgnamevnet = "${var.rgname}"
  rgnamevnet = "${azurerm_resource_group.demorg.name}"
  #rglocationvnet = "${var.location}"
  rglocationvnet = "${azurerm_resource_group.demorg.location}"
}
module "azpip" {
  source = "./azurepip"
  #rgnamepip = "${var.rgname}"
  rgnamepip = "${azurerm_resource_group.demorg.name}"
  #rglocationpip = "${var.location}"
  rglocationpip = "${azurerm_resource_group.demorg.location}"

}

module "aznic" {
  source = "./azurenic"
  rgnamenic = "${var.rgname}"
  rglocationnic = "${var.location}"
  subnetid = "${module.azvnet.subnetid}"
  publicipid = "${module.azpip.pipid}"
  
}

resource "azurerm_virtual_machine" "tfvm"{
  name = "terrafromvm"
  location              = "${var.location}"
  resource_group_name   = "${var.rgname}"
  network_interface_ids = ["${module.aznic.nicid}"]
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
  provisioner "remote-exec" {
   # connection {
    #  user     = "adminuser"
     # password = "Password1234"
    #}
    connection {
      type     = "ssh"
      host = "${module.azpip.dns}.${var.location}.cloudapp.azure.com"
      user     = "adminuser"
      password = "Password1234"
      timeout = "2m"
      #agent = true
    }


    inline = [
      "sudo apt-get update",
      "sudo mkdir newfile",
      "cd newfile",
      "sudo echo welcome > terraform"
    ]
  }
  tags = {
    environment = "staging"
  }
}

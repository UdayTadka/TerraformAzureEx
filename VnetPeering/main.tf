resource "azurerm_resource_group" "demorg" {
  name     = "${var.rgname}"
  location = "${var.location}"
}

#first VM 
module "azvnet" {
  source = "./azurevnet"
  #rgnamevnet = "${var.rgname}"
  rgnamevnet = "${azurerm_resource_group.demorg.name}"
  #rglocationvnet = "${var.location}"
  rglocationvnet = "${azurerm_resource_group.demorg.location}"
  vnetname = "tfvnet1"
  subnetname ="tfsubnet1"
  addspa ="10.0.0.0/16"
  addpre = "10.0.1.0/24"
}
module "azpip" {
  source = "./azurepip"
  #rgnamepip = "${var.rgname}"
  rgnamepip = "${azurerm_resource_group.demorg.name}"
  #rglocationpip = "${var.location}"
  rglocationpip = "${azurerm_resource_group.demorg.location}"
  pipname = "pip1"
  dnsname = "tfpip1"

}

module "aznic" {
  source = "./azurenic"
  rgnamenic = "${var.rgname}"
  rglocationnic = "${var.location}"
  subnetid = "${module.azvnet.subnetid}"
  publicipid = "${module.azpip.pipid}"
  nicname ="nic1"
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
      #"sudo echo welcome > terraform"
    ]
  }
  tags = {
    environment = "staging"
  }
}





# Second VM


module "azvnet1" {
  source = "./azurevnet"
  #rgnamevnet = "${var.rgname}"
  rgnamevnet = "${azurerm_resource_group.demorg.name}"
  #rglocationvnet = "${var.location}"
  rglocationvnet = "${azurerm_resource_group.demorg.location}"
  vnetname = "tfvnet2"
  subnetname ="tfsubnet2"
  addspa ="10.1.0.0/16"
  addpre = "10.1.0.0/24"
}
module "azpip1" {
  source = "./azurepip"
  #rgnamepip = "${var.rgname}"
  rgnamepip = "${azurerm_resource_group.demorg.name}"
  #rglocationpip = "${var.location}"
  rglocationpip = "${azurerm_resource_group.demorg.location}"
  pipname = "pip2"
  dnsname = "tfpip2"

}

module "aznic1" {
  source = "./azurenic"
  rgnamenic = "${var.rgname}"
  rglocationnic = "${var.location}"
  subnetid = "${module.azvnet1.subnetid}"
  publicipid = "${module.azpip1.pipid}"
  nicname ="nic2"
}
resource "azurerm_virtual_machine" "tfvm1"{
  name = "terrafromvm1"
  location              = "${var.location}"
  resource_group_name   = "${var.rgname}"
  network_interface_ids = ["${module.aznic1.nicid}"]
  vm_size = "Standard_F2s_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
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
      host = "${module.azpip1.dns}.${var.location}.cloudapp.azure.com"
      user     = "adminuser"
      password = "Password1234"
      timeout = "2m"
      #agent = true
    }


    inline = [
      "sudo apt-get update",
      "sudo mkdir newfile",
      "cd newfile",
      #"sudo echo welcome > terraform"
    ]
  }
  tags = {
    environment = "staging"
  }
}


/* VNET PEERING
*/
resource "azurerm_virtual_network_peering" "test1" {
  name                      = "peer1to2"
  #vmname = "${azurerm_virtual_machine.tfvm.name}"  ## adding VM name to add dependency
  resource_group_name       = "${azurerm_resource_group.demorg.name}"
  virtual_network_name      = "${module.azvnet.vnetname}"
  #remote_virtual_network_id = "${azurerm_virtual_network.test2.id}"
  remote_virtual_network_id = "${module.azvnet1.id}"
}

resource "azurerm_virtual_network_peering" "test2" {
  name                      = "peer2to1"
  #vmname = "${azurerm_virtual_machine.tfvm1.name}" #adding VM name to add dependency
  resource_group_name       = "${azurerm_resource_group.demorg.name}"
  #virtual_network_name      = "${azurerm_virtual_network.test2.name}"
  virtual_network_name      = "${module.azvnet1.vnetname}"
  #remote_virtual_network_id = "${azurerm_virtual_network.test1.id}"
  remote_virtual_network_id = "${module.azvnet.id}"
}


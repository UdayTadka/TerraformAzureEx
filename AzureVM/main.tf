
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  #client_secret   = "${var.secret}"
  #client_id = "${var.clientid}"
  #client_secret="${var.clientsecret}"
  subscription_id = "367f5532-2d88-410d-8b02-5e5c8f779c8e"
  client_id       = "0303da52-1db5-44c2-b6fa-29710468d7ae"
  client_secret   = "${var.secret}"
  tenant_id       = "4935eefd-5b0f-4deb-9c51-70dcc61f0f38"
  }
# Create a resource group
resource "azurerm_resource_group" "rsg" {
    name = "terraform"
    location = "${var.location}"
}

resource "azurerm_virtual_network" "tfvnet" {
    name = "terraformvnet"
    resource_group_name = "${azurerm_resource_group.rsg.name}"
    address_space = ["192.168.0.0/16"]
    location = "${var.location}"

}

resource "azurerm_subnet" "terraformcompute" {
    name                 = "terraformcompute"
  virtual_network_name = "${azurerm_virtual_network.tfvnet.name}"
   resource_group_name = "${azurerm_resource_group.rsg.name}"
  address_prefix       = "192.168.0.0/24"

}


resource "azurerm_public_ip" "publicip" {
    name = "terraformip"
    resource_group_name = "${azurerm_resource_group.rsg.name}"
    location = "${var.location}"
    public_ip_address_allocation = "dynamic"
    domain_name_label   =  "tfpip"

}

resource "azurerm_network_interface" "terraformnic" {
  name                = "terraformnic"
  resource_group_name = "${azurerm_resource_group.rsg.name}"
  location = "${var.location}"

  ip_configuration {
    name                          = "terraformipconfig"
    subnet_id                     = "${azurerm_subnet.terraformcompute.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
  }
}

resource "azurerm_virtual_machine" "myvm" {
    name = "terraformdevops"
    resource_group_name = "${azurerm_resource_group.rsg.name}"
    location = "${var.location}"
    network_interface_ids = ["${azurerm_network_interface.terraformnic.id}"]
    vm_size               = "Standard_F2s_v2"

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
        computer_name  = "terraformdevops"
        admin_username = "adminuser"
        admin_password = "Password1234"
    }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host = "${azurerm_public_ip.publicip.domain_name_label}.${var.location}.cloudapp.azure.com"
      user     = "adminuser"
      password = "Password1234"
      #timeout = "2m"
      agent = true
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y"
    ]
  }
}

output "machineip" {
  value = "${azurerm_public_ip.publicip.ip_address}"
}
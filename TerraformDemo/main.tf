resource "azurerm_virtual_network" "vnettf" {
    name = "vnet"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    address_space = ["192.168.0.0/16"]
    location = "${azurerm_resource_group.demorg.location}"

}

resource "azurerm_subnet" "tfsubnet" {
    name                 = "subnet"
    virtual_network_name = "${azurerm_virtual_network.vnettf.name}"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    address_prefix       = "192.168.0.0/24"

}


resource "azurerm_public_ip" "publiciptf" {
    name = "tfpip"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    location = "${azurerm_resource_group.demorg.location}"
    public_ip_address_allocation = "dynamic"
    domain_name_label   =  "tfpip"

}
resource "azurerm_network_interface" "tfnic" {
  name                = "nic"
  resource_group_name = "${azurerm_resource_group.demorg.name}"
  location = "${azurerm_resource_group.demorg.location}"

  ip_configuration {
    name                          = "tfipconfig"
    subnet_id                     = "${azurerm_subnet.tfsubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publiciptf.id}"
  }
}

resource "azurerm_virtual_machine" "myvm" {
    name = "tfvm"
    resource_group_name = "${azurerm_resource_group.demorg.name}"
    location = "${azurerm_resource_group.demorg.location}"
    network_interface_ids = ["${azurerm_network_interface.tfnic.id}"]
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
        computer_name  = "myvmtf"
        admin_username = "adminuser"
        admin_password = "Password1234"
    }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

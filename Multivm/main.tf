provider "azurerm" {
  version ="=1.44.0"
  subscription_id  =  "ecfb86af-784f-452b-aa80-8710ed29cecb"
  client_id        =  "ed55b255-1704-4e94-873d-df980df1c08c"
  client_secret    =  "ZQxVy-~HQYuZiX3UPxbbxLq7ugyfy4xVGl"
  tenant_id        =  "b41b72d0-4e9f-4c26-8a69-f949f367c91d"
}
resource "azurerm_resource_group" "azure_rg" {
  name     =  var.rgname
  location =  var.location
}

#Data Disk for Virtual Machine
resource "azurerm_managed_disk" "datadisk" {
 count                = var.numbercount
 name                 = "datadisk_existing_${count.index}"
 location             = var.location
 resource_group_name  = var.rgname
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "50"
}

#Aure Virtual machine
resource "azurerm_virtual_machine" "terravm" {
    name                  = "vm-stg-${count.index}"
    location              = var.location
    resource_group_name   = var.rgname
    count 		  = var.numbercount
    network_interface_ids = [element(azurerm_network_interface.terranic.*.id, count.index)]
    vm_size               = "Standard_B1ls"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true


storage_os_disk {
    name                 = "osdisk-${count.index}"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Premium_LRS"
    disk_size_gb         = "30"
  }

 storage_data_disk {
   name              = element(azurerm_managed_disk.datadisk.*.name, count.index)
   managed_disk_id   = element(azurerm_managed_disk.datadisk.*.id, count.index)
   create_option     = "Attach"
   lun               = 1
   disk_size_gb      = element(azurerm_managed_disk.datadisk.*.disk_size_gb, count.index)
 }

   storage_image_reference {
    publisher       = "Canonical"
    offer           = "UbuntuServer"
    sku             = "16.04-LTS"
    version         = "latest"
  }
    os_profile {
        computer_name  = "terraformdevops"
        admin_username = "adminuser"
        admin_password = "Password1234"
    }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
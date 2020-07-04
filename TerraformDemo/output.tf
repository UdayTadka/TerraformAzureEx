output "rgname" {
  value = "${azurerm_resource_group.demorg.name}"
}

output "vmname" {
  value = "${azurerm_virtual_machine.myvm.name}"
}


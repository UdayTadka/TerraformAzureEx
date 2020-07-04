output "subnetid" {
  value = "${azurerm_subnet.tfsubnet.id}"
}

output "vnetname" {
  value = "${azurerm_virtual_network.tfvnet.name}"
}

output "id" {
  value = "${azurerm_virtual_network.tfvnet.id}"
}


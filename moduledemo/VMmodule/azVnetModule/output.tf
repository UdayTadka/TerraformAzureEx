output "subnetid" {
  value = "${azurerm_subnet.tfsubnet.id}"
}

output "rgname" {
  value = "${var.rgname}"
}

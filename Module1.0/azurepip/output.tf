output "pipid" {
  value = "${azurerm_public_ip.tfpip.id}"
}

output "dns" {
  value = "${azurerm_public_ip.tfpip.domain_name_label}"
}


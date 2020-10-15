resource "azurerm_storage_account" "tfstrg" {
    name       = "${var.stacname}${random_string.unique.result}"
    count   =  "${var.env == "prod" ? 1 : 0}"
    #resource_group_name = azurerm_resource_group.strg.name
    resource_group_name = "${var.rgname}"
    location   = azurerm_resource_group.strg.location
    account_tier = "Standard"
    account_replication_type = "GRS"
}

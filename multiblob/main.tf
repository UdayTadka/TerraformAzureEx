 resource "azurerm_resource_group" "strg" {
    name        = "${var.rgname}"
    location    = "${var.rgloc}"
}
resource "random_string" "unique" {
  length    = 4
  special   = false
  lower     = true
  upper     = false
  number    = false
  
}

resource "azurerm_storage_account" "tfstrg" {
    name       = "${var.stacname}${random_string.unique.result}[count.index]"
    #resource_group_name = azurerm_resource_group.strg.name
    resource_group_name = "${var.rgname}"
    location   = azurerm_resource_group.strg.location
    account_tier = "Standard"
    account_replication_type = "LRS"
    count = 3
}
/*
resource "azurerm_storage_container" "tfstrg" {
    name    = "firstcntr"
    #storage_account_name = "${var.stacname}"
    storage_account_name = azurerm_storage_account.tfstrg.name
}

resource "azurerm_storage_blob" "tfstrg" {
    name                       = "file"
    storage_account_name       = azurerm_storage_account.tfstrg.name[count.index]
    storage_container_name     = azurerm_storage_container.tfstrg.name[count.index]
    type                       = "block"
    source                     = "C:/Users/Uday_Tadka/Terraform14.10/test.txt"
    count = 3
}*/
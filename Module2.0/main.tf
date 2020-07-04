resource "azurerm_resource_group" "demorg" {
  name     = "${var.rgname}"
  location = "${var.location}"
}

module "azvnet" {
  source = "./azurevnet"
  #rgnamevnet = "${var.rgname}"
  rgnamevnet = "${azurerm_resource_group.demorg.name}"
  #rglocationvnet = "${var.location}"
  rglocationvnet = "${azurerm_resource_group.demorg.location}"
}
module "azpip" {
  source = "./azurepip"
  #rgnamepip = "${var.rgname}"
  rgnamepip = "${azurerm_resource_group.demorg.name}"
  #rglocationpip = "${var.location}"
  rglocationpip = "${azurerm_resource_group.demorg.location}"

}

module "aznic" {
  source = "./azurenic"
  rgnamenic = "${var.rgname}"
  rglocationnic = "${var.location}"
  subnetid = "${module.azvnet.subnetid}"
  publicipid = "${module.azpip.pipid}"
  
}
module "azurevm" {
  source = "./azurevm"
  rglocationvm = "${var.location}"
  rgnamevm = "${var.rgname}"
  vmnicid = ["${module.aznic.nicid}"]
}

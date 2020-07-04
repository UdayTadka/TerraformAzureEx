
module "az_vnet"{
  source = "./VMmodule/azVnetModule"
 # rgname = "${var.rgname}"
  rgname = "${azurerm_resource_group.demorg.name}"
  secret = "${var.secret}"
  #location = "${var.location}"
  location = "${azurerm_resource_group.demorg.location}"
  

}

module "az_pip"{
  source = "./VMmodule/azpipModule"
  rgname = "${module.az_vnet.rgname}"
  subnetid = "${module.az_vnet.subnetid}"
  secret = "${var.secret}"
  location = "${var.location}"
  
}

#module "az_VM"{
 # source = "./VMmodule/azVMmodule"
  #rgname = "${var.rgname}"
  #secret = "${var.secret}"
  #location = "${var.location}"
#}


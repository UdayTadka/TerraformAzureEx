module "unique_id" {
  source = "./unique_id"
}
resource "azurerm_resource_group" "webappdemo"{
 name = "wpdemo"
 location = "${var.location}"   
}

resource "azurerm_app_service_plan" "demoplan" {
  name                = "demowebplan"
  location            = "${azurerm_resource_group.webappdemo.location}"
  resource_group_name = "${azurerm_resource_group.webappdemo.name}"

  sku {
    tier = "Basic"
    size = "B1"
  }
}
resource "azurerm_app_service" "webservice" {
  name                = "demowd${module.unique_id.unique_id}"
  location            = "${azurerm_resource_group.webappdemo.location}"
  resource_group_name = "${azurerm_resource_group.webappdemo.name}"
  app_service_plan_id = "${azurerm_app_service_plan.demoplan.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
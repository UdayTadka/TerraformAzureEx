provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

  subscription_id = "367f5532-2d88-410d-8b02-5e5c8f779c8e"
  client_id       = "0303da52-1db5-44c2-b6fa-29710468d7ae"
  client_secret   = "${var.secret}"
  tenant_id       = "4935eefd-5b0f-4deb-9c51-70dcc61f0f38"
}


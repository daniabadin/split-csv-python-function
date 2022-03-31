resource "azurerm_storage_account" "tf_backend" {
  name                     = "tfbackend"
  resource_group_name      = "uni-labs"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tf_backend.name
  container_access_type = "blob"
}

terraform {
  backend "azurerm" {
      resource_group_name  = "uni-labs"
      storage_account_name = azurerm_storage_account.tf_backend.name
      container_name       = azurerm_storage_container.tfstate.name
      key                  = "terraform.tfstate"
  }
}
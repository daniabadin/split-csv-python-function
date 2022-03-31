## Uncomment the resource azurerm_resource_group.unilabs if you don't have a storage account created

# resource "azurerm_resource_group" "unilabs" {
#   name     = var.resource_group_name
#   location = var.location
# }

resource "azurerm_storage_account" "unilabscsvs" {
  name                     = "unilabscsvs"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "csvs" {
  name                  = "csvs"
  storage_account_name  = azurerm_storage_account.unilabscsvs.name
  container_access_type = "container"
}
## Uncomment the resource azurerm_resource_group.unilabs if you don't have a storage account created

# resource "azurerm_resource_group" "unilabs" {
#   name     = var.resource_group_name
#   location = var.location
# }

resource "azurerm_storage_account" "unilabscsvs" {
  name                     = "unilabscsvs"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
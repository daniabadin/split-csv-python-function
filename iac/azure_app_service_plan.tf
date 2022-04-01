resource "azurerm_app_service_plan" "split_csv_python_asp" {
  name                = "split-csv-python-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "FunctionApp"
  sku {
    tier = "Standard"
    size = "S1"
  }
}
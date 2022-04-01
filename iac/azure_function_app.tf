resource "azurerm_application_insights" "split_csv_python_insights" {
  name                = "split-csv-python-insights"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
}

resource "azurerm_function_app" "split_csv_python_func" {
  name                       = "split-csv-python-func"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.split_csv_python_asp.id
  storage_account_name       = azurerm_storage_account.unilabscsvs.name
  storage_account_access_key = azurerm_storage_account.unilabscsvs.primary_access_key
  os_type                    = "linux"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "python"
    FUNCTION_APP_EDIT_MODE         = "readonly"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.split_csv_python_insights.instrumentation_key
    AzureWebJobsStorage            = azurerm_storage_account.unilabscsvs.primary_connection_string
    storage_name                   = azurerm_storage_account.unilabscsvs.primary_connection_string

  }
}
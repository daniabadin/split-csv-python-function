terraform {
  required_providers {
    local = {
      version = "=2.1.0"
    }
    azurerm = {
      version = "=2.91.0"
    }
  }
  required_version = ">= 0.14"
}



provider "local" {

}

provider "azurerm" {
  skip_provider_registration = "true"

  # subscription_id = var.azurerm_subscription_id
  # client_id       = var.azurerm_client_id
  # client_secret   = var.azurerm_client_secret
  # tenant_id       = var.azurerm_tenant_id

  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
      purge_soft_delete_on_destroy    = false
    }
  }
}
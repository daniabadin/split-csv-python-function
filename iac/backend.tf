terraform {
  backend "azurerm" {
      resource_group_name  = "uni-labs"
      storage_account_name = "unilabstfbackend"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}
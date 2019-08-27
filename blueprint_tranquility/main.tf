terraform {
    backend "azurerm" {
    }
}

data "azurerm_client_config" "current" {
}

provider "azurerm" {
  version = "=1.33.0"
}

terraform {
    backend "azurerm" {
    }
}

data "azurerm_client_config" "current" {
}

provider "azurerm" {
  version = "=1.31.0"
}

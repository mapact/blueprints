terraform {
    backend "azurerm" {
    }
}

data "azurerm_client_config" "current" {
}

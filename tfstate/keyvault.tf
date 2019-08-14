data "azurerm_client_config" "current" {}

resource "random_string" "kv_name" {
  length  = 23 - length(random_string.prefix.result)
  special = false
  upper   = false
  number  = true
}

resource "random_string" "kv_middle" {
  length  = 1
  special = false
  upper   = false
  number  = false
}

locals {
    kv_name = "${random_string.prefix.result}${random_string.kv_middle.result}${random_string.kv_name.result}"
}


resource "azurerm_key_vault" "tfstate" {
    name                = local.kv_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    tenant_id           = data.azurerm_client_config.current.tenant_id

    sku_name = "standard"

    tags = {
      kvtfstate="level0"
    }

    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azuread_service_principal.tfstate.object_id

      key_permissions = []

      secret_permissions = [
          "set",
          "get",
          "list",
          "delete",
      ]
    }

    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azuread_service_principal.devops.object_id

      key_permissions = []

      secret_permissions = [
          "get",
          "list",
      ]
    }

    access_policy {
      tenant_id       = data.azurerm_client_config.current.tenant_id
      object_id       = azurerm_user_assigned_identity.tfstate.principal_id

      key_permissions = []

      secret_permissions = [
          "get",
      ]
    }

}




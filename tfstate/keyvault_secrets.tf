provider "azurerm" {
    client_id       = azuread_application.tfstate.application_id
    client_secret   = random_string.tfstate_password.result
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id

    alias           = "sp_tfstate"
}


## Store the tfstate storage account details in the keyvault to allow the deployment script to 
# connect to the storage account
resource "azurerm_key_vault_secret" "tfstate_resource_group" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate

    name          = "tfstate-resource-group"
    value         = azurerm_resource_group.rg.name
    key_vault_id  = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_storage_account_name" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-storage-account-name"
    value        = azurerm_storage_account.stg.name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_container" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-container"
    value        = azurerm_storage_container.tfstate.name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_prefix" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-prefix"
    value        = random_string.prefix.result
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_blob_name" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-blob-name"
    value        = local.tfstate-blob-name
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_msi_client_id" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-msi-client-id"
    value        = azurerm_user_assigned_identity.tfstate.client_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_msi_principal_id" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-msi-principal-id"
    value        = azurerm_user_assigned_identity.tfstate.principal_id
    key_vault_id = azurerm_key_vault.tfstate.id
}

resource "azurerm_key_vault_secret" "tfstate_msi_id" {
    depends_on    = [azuread_service_principal_password.tfstate]
    provider      = azurerm.sp_tfstate
    
    name         = "tfstate-msi-id"
    value        = azurerm_user_assigned_identity.tfstate.id
    key_vault_id = azurerm_key_vault.tfstate.id
}
terraform {
  backend "azurerm" {
    storage_account_name = "tfstate20260914"
    container_name       = "tfstate"
    key                  = "elk/dev/terraform.tfstate"
    use_azuread_auth     = true
  }
}

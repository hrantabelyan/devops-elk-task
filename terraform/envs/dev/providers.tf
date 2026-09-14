# Authentication is left to defaults and ARM_* environment variables (Azure CLI locally, OIDC in CI).
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

# Authentication is left to defaults and ARM_* environment variables (Azure CLI locally, OIDC in CI).
provider "azurerm" {
  features {
    key_vault {
      # The vault keeps deleted secrets for 30 days. Purging them on destroy lets the next apply
      # create them again under the same names.
      purge_soft_deleted_secrets_on_destroy = true
    }
  }
  resource_provider_registrations = "none"
}

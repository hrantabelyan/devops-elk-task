terraform {
  # 1.11 for ephemeral resources and write-only arguments (secrets.tf).
  required_version = ">= 1.11"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.4.1"
    }
  }
}

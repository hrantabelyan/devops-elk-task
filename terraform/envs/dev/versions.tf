terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.4.1"
    }
  }
}

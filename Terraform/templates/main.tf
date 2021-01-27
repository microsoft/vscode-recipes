provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-sample"
  location = "eastus"
}

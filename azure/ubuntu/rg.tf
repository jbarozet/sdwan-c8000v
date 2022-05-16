# Create Resource Group

data "azurerm_resource_group" "rg_vnet" {
  name = var.rg
}

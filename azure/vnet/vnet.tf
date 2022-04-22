# Create a VNET

resource "azurerm_virtual_network" "my_vnet" {
  resource_group_name = azurerm_resource_group.my_rg.name
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.region
}


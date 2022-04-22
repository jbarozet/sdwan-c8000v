# Create subnets

resource "azurerm_subnet" "transport_subnet" {
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  name                 = "${var.subnet_name}-transport"
  address_prefixes     = var.transport_subnet_prefix

}

resource "azurerm_subnet" "service_subnet" {
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  name                 = "${var.subnet_name}-service"
  address_prefixes     = var.service_subnet_prefix
}

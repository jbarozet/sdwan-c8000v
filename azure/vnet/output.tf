
output "rg" {
  value = azurerm_resource_group.my_rg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.my_vnet.id
}

output "transport_subnet" {
  value = azurerm_subnet.transport_subnet.id
}

output "service_subnet" {
  value = azurerm_subnet.service_subnet.id
}


# Create security group:

resource "azurerm_network_security_group" "transport" {
  name                = "${var.name}-transport-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "ICMP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DTLS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "12346-13156"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "outbound"
    priority                   = 1020
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_security_group" "service" {
  name                = "${var.name}-service-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "All"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "outbound"
    priority                   = 1020
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}


# Create interface and security group associations:

resource "azurerm_network_interface_security_group_association" "transport" {
  network_interface_id      = azurerm_network_interface.transport.id
  network_security_group_id = azurerm_network_security_group.transport.id
}

resource "azurerm_network_interface_security_group_association" "service" {
  network_interface_id      = azurerm_network_interface.service.id
  network_security_group_id = azurerm_network_security_group.service.id
}

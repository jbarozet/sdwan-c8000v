# Create Public IP Address

resource "azurerm_public_ip" "public" {
  name                = "${var.name}-public-ip"
  location            = azurerm_resource_group.rg_c8000v.location
  resource_group_name = azurerm_resource_group.rg_c8000v.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


# Create NICs:

resource "azurerm_network_interface" "transport" {
  name                 = "${var.name}-transport-nic"
  location             = azurerm_resource_group.rg_c8000v.location
  resource_group_name  = azurerm_resource_group.rg_c8000v.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.name}-transport-nic"
    subnet_id                     = data.terraform_remote_state.spam.outputs.transport_subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }

  depends_on = [azurerm_network_security_group.transport]
}

resource "azurerm_network_interface" "service" {
  name                 = "${var.name}-service-nic"
  location             = azurerm_resource_group.rg_c8000v.location
  resource_group_name  = azurerm_resource_group.rg_c8000v.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.name}-service-nic"
    subnet_id                     = data.terraform_remote_state.spam.outputs.service_subnet
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_network_security_group.service]
}


# Create Catalyst 8000v:

resource "azurerm_virtual_machine" "c8000v" {
  name                = var.name
  location            = azurerm_resource_group.rg_c8000v.location
  resource_group_name = azurerm_resource_group.rg_c8000v.name

  network_interface_ids = [
    azurerm_network_interface.transport.id,
    azurerm_network_interface.service.id
  ]

  primary_network_interface_id = azurerm_network_interface.transport.id

  vm_size = var.instance_size

  #  delete_os_disk_on_termination    = true
  #  delete_data_disks_on_termination = true

  plan {
    publisher = "cisco"
    product   = "cisco-c8000v"
    name      = "17_07_01a-byol"
  }

  storage_os_disk {
    name              = "${var.name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-c8000v"
    sku       = "17_07_01a-byol"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.name}-vm"
    admin_username = var.username
    admin_password = var.password
    #custom_data    = file("../cloud_init/c8000v.user_data")
    custom_data = data.template_cloudinit_config.config.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  depends_on = [
    azurerm_network_interface_security_group_association.transport,
    azurerm_network_interface_security_group_association.service
  ]
}

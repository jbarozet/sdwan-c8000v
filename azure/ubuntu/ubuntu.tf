# Make Ubuntu VM

# Create public IPs
resource "azurerm_public_ip" "ubuntu_public" {
  name                = "${var.name}-public-ip"
  location            = data.azurerm_resource_group.rg_vnet.location
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "ubuntu_public" {
  name                = "${var.name}-public-nic"
  location            = data.azurerm_resource_group.rg_vnet.location
  resource_group_name = data.azurerm_resource_group.rg_vnet.name

  ip_configuration {
    name                          = "${var.name}-public-nic"
    subnet_id                     = data.azurerm_subnet.transport_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ubuntu_public.id
  }

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "public" {
  network_interface_id      = azurerm_network_interface.ubuntu_public.id
  network_security_group_id = azurerm_network_security_group.ubuntu_public.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = data.azurerm_resource_group.rg_vnet.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = data.azurerm_resource_group.rg_vnet.name
  location                 = data.azurerm_resource_group.rg_vnet.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "ubuntu" {
  name                  = var.name
  location              = data.azurerm_resource_group.rg_vnet.location
  resource_group_name   = data.azurerm_resource_group.rg_vnet.name
  network_interface_ids = [azurerm_network_interface.ubuntu_public.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.name}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = var.name
  admin_username                  = "cisco"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "cisco"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

}

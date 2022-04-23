
output "ubuntu_public_ip" {
  value = azurerm_linux_virtual_machine.ubuntu.public_ip_address
}

output "ubuntu_private_ip" {
  value = azurerm_linux_virtual_machine.ubuntu.private_ip_address
}

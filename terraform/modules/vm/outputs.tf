output "id" {
  value = azurerm_linux_virtual_machine.this.id
}

output "private_ip" {
  value = azurerm_network_interface.this.private_ip_address
}

output "public_ip" {
  value = azurerm_public_ip.this.ip_address
}

output "admin_username" {
  value = var.admin_username
}

output "name" {
  value = azurerm_linux_virtual_machine.this.name
}

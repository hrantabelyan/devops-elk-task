output "id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Subnet name => subnet ID."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}

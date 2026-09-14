resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "inbound" {
  for_each = var.inbound_rules

  name                        = each.key
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
  direction                   = "Inbound"
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = length(each.value.ports) == 1 ? each.value.ports[0] : null
  destination_port_ranges     = length(each.value.ports) > 1 ? each.value.ports : null
}

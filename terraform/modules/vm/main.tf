resource "azurerm_public_ip" "this" {
  name                = "${var.name}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  zones               = [var.zone]
  tags                = var.tags
}

resource "azurerm_network_interface" "this" {
  name                           = "${var.name}-nic"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  accelerated_networking_enabled = var.accelerated_networking
  tags                           = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_linux_virtual_machine" "this" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.size
  zone                  = var.zone
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.this.id]
  secure_boot_enabled   = true
  vtpm_enabled          = true
  tags                  = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.image.publisher
    offer     = var.image.offer
    sku       = var.image.sku
    version   = var.image.version
  }

  boot_diagnostics {}
}

variable "name" {
  description = "VM name. Public IP and NIC names are derived from it."
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "zone" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_ip" {
  type = string
}

variable "network_security_group_id" {
  type = string
}

variable "size" {
  type = string
}

variable "ssh_public_key" {
  description = "OpenSSH public key. Changing it replaces the VM."
  type        = string
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "accelerated_networking" {
  type    = bool
  default = false
}

variable "os_disk_type" {
  type    = string
  default = "StandardSSD_LRS"
}

variable "image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

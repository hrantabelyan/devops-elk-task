variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  description = "Subnet name => address prefix."
  type        = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

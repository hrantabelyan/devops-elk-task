variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "inbound_rules" {
  description = "Rule name => rule. Keys become Azure rule names, so renaming a key replaces the rule."
  type = map(object({
    priority = number
    ports    = list(string)
    source   = string
    access   = optional(string, "Allow")
    protocol = optional(string, "Tcp")
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

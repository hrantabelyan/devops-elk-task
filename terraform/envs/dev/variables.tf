variable "operator_ip" {
  description = "Your public IP in CIDR form (e.g. 203.0.113.10/32). Allowed to SSH to both VMs and open Kibana."
  type        = string

  validation {
    condition     = can(cidrhost(var.operator_ip, 0))
    error_message = "operator_ip must be a CIDR, e.g. 203.0.113.10/32."
  }
}

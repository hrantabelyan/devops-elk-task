output "public_ips" {
  value = { for name, vm in module.vm : name => vm.public_ip }
}

output "private_ips" {
  value = { for name, vm in module.vm : name => vm.private_ip }
}

output "ssh_private_key_file" {
  value = local_sensitive_file.ssh_private_key.filename
}

output "ssh_commands" {
  value = {
    for name, vm in module.vm :
    name => "ssh -i ${local_sensitive_file.ssh_private_key.filename} ${vm.admin_username}@${vm.public_ip}"
  }
}

output "ansible_inventory_file" {
  value = local_file.ansible_inventory.filename
}

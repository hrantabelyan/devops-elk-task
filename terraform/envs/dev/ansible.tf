# Configures the VMs once Terraform has created them: site.yml runs from ansible/ with the generated inventory
# and key, and its first plays read the passwords from Key Vault and wait for SSH and cloud-init. It runs again
# when a VM is replaced or the inventory changes. Role changes alone don't trigger it: run ansible-playbook for
# those. If the playbook fails, this resource is tainted and the next apply runs it again, leaving the VMs in place.
resource "terraform_data" "ansible" {
  triggers_replace = {
    vm_ids    = { for name, vm in module.vm : name => vm.id }
    inventory = local_file.ansible_inventory.content_sha256
  }

  # Ansible needs these, but nothing above references them: the NSG rules for SSH from your IP,
  # and the passwords in Key Vault that its first play reads.
  depends_on = [module.nsg, azurerm_key_vault_secret.stack]

  # New VMs can get public IPs that older VMs had, so host keys learned before are dropped.
  provisioner "local-exec" {
    working_dir = local.ansible_dir
    command     = <<-EOT
      set -e
      rm -f "${local.ssh_known_hosts_file}"
      ansible-galaxy collection install -r requirements.yml
      ansible-playbook site.yml
    EOT
  }
}

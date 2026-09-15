# Static Ansible inventory built from what Terraform actually created, so IPs are never copied by hand.
# One group per node key (web, elk). private_ip is a host var: Filebeat on web reaches Logstash via
# hostvars[groups['elk'][0]].private_ip, and the ELK services bind to their own private_ip.
resource "local_file" "ansible_inventory" {
  filename        = "${local.ansible_dir}/inventory.ini"
  file_permission = "0644"

  content = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    hosts = {
      for group, vm in module.vm : group => {
        name           = vm.name
        public_ip      = vm.public_ip
        private_ip     = vm.private_ip
        admin_username = vm.admin_username
      }
    }
    ssh_private_key_file = local_sensitive_file.ssh_private_key.filename
    ssh_known_hosts_file = local.ssh_known_hosts_file
    ports                = local.ports
  })
}

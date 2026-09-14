# One deployment key for both VMs; Ansible connects with the private half.
resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "ssh_private_key" {
  filename             = "${local.ansible_dir}/.ssh/id_ed25519"
  content              = tls_private_key.ssh.private_key_openssh
  file_permission      = "0600"
  directory_permission = "0700"
}

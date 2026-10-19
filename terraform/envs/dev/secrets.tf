# The vault is created once by an admin, who also gives the identity that runs Terraform and Ansible the
# Key Vault Secrets Officer role on it (README, Prerequisites). Terraform only looks it up and manages its secrets.
data "azurerm_key_vault" "this" {
  name                = local.key_vault_name
  resource_group_name = local.project
}

# Elastic Stack passwords, kept in Key Vault so every machine that runs Ansible uses the same ones.
# The password is ephemeral and value_wo is write-only: Terraform generates it during apply and sends it to
# Key Vault, and neither the plan nor the state stores it.
# A new password is written only when its version in local.stack_passwords changes, which is how you rotate one;
# the next playbook run then sets it on the cluster.
ephemeral "random_password" "stack" {
  for_each = local.stack_passwords

  length  = 32
  special = false
}

resource "azurerm_key_vault_secret" "stack" {
  # checkov:skip=CKV_AZURE_41: rotation is a version bump in locals.tf; Key Vault still returns a secret after its expiry date
  for_each = local.stack_passwords

  name             = each.key
  key_vault_id     = data.azurerm_key_vault.this.id
  value_wo         = ephemeral.random_password.stack[each.key].result
  value_wo_version = each.value
  content_type     = "password"
}

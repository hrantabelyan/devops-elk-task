module "vnet" {
  source = "../../modules/vnet"

  name                = "${local.name}-vnet"
  location            = local.location
  resource_group_name = local.project
  address_space       = [local.address_space]
  subnets             = { (local.subnet_name) = local.subnet_prefix }
  tags                = local.common_tags
}

module "nsg" {
  source   = "../../modules/nsg"
  for_each = local.nodes

  name                = "${local.name}-${each.key}-nsg"
  location            = local.location
  resource_group_name = local.project
  inbound_rules       = each.value.inbound_rules
  tags                = merge(local.common_tags, { node_number = each.value.node_number })
}

module "vm" {
  source   = "../../modules/vm"
  for_each = local.nodes

  name                      = "${local.name}-${each.key}"
  location                  = local.location
  resource_group_name       = local.project
  zone                      = local.zone
  subnet_id                 = module.vnet.subnet_ids[local.subnet_name]
  private_ip                = local.private_ips[each.key]
  network_security_group_id = module.nsg[each.key].id
  size                      = each.value.size
  accelerated_networking    = each.value.accelerated_networking
  ssh_public_key            = trimspace(tls_private_key.ssh.public_key_openssh)
  tags                      = merge(local.common_tags, { node_number = each.value.node_number })
}

locals {
  project     = "devops-bank"
  environment = "dev"
  location    = "swedencentral"
  zone        = "1"

  # Base for every Azure name, e.g. devops-bank-dev-web.
  name = "${local.project}-${local.environment}"

  address_space = "172.16.0.0/16"
  subnet_name   = "${local.name}-snet"
  subnet_prefix = cidrsubnet(local.address_space, 8, 0) # 172.16.0.0/24

  # Static so NSG rules and the ELK bind address can name them.
  # Kept apart from `nodes` because elk's rules reference web's IP.
  private_ips = {
    web = cidrhost(local.subnet_prefix, 11) # 172.16.0.11
    elk = cidrhost(local.subnet_prefix, 12) # 172.16.0.12
  }

  # Shared with Ansible through the inventory, so NSG rules and service configs use the same numbers.
  ports = {
    ssh           = 22
    http          = 80
    https         = 443
    beats         = 5044
    elasticsearch = 9200
    kibana        = 5601
  }

  nodes = {
    web = {
      node_number            = "1"
      size                   = "Standard_D2ls_v5"
      accelerated_networking = true
      inbound_rules = {
        "SSH-from-operator" = { priority = 200, ports = [local.ports.ssh], source = var.operator_ip }
        "HTTP"              = { priority = 300, ports = [local.ports.http], source = "*" }
        "HTTPS"             = { priority = 320, ports = [local.ports.https], source = "*" }
      }
    }
    elk = {
      node_number            = "2"
      size                   = "Standard_B4as_v2"
      accelerated_networking = false
      inbound_rules = {
        "Beats-from-web"         = { priority = 100, ports = [local.ports.beats], source = "${local.private_ips.web}/32" }
        "Elasticsearch-from-web" = { priority = 110, ports = [local.ports.elasticsearch], source = "${local.private_ips.web}/32" }
        "SSH-from-operator"      = { priority = 200, ports = [local.ports.ssh], source = var.operator_ip }
        "Kibana-from-operator"   = { priority = 210, ports = [local.ports.kibana], source = var.operator_ip }
        # Commented the line below: Claude claims - Without this, Azure's default AllowVnetInBound (65000) lets any VNet host reach 5044/9200.
        # "Deny-beats-elasticsearch" = { priority = 400, ports = [local.ports.beats, local.ports.elasticsearch], source = "*", access = "Deny", protocol = "*" }
      }
    }
  }

  common_tags = {
    project     = local.project
    environment = local.environment
    managed_by  = "terraform"
  }

  ansible_dir = abspath("${path.module}/../../../ansible")
}

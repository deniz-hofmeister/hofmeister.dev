locals {
  vm_sizes = {
    nano   = "t4g.nano"   # 2 vCPU, 0.5GB  ~$3/mo (ARM Graviton)
    micro  = "t4g.micro"  # 2 vCPU, 1GB    ~$6/mo (ARM Graviton)
    small  = "t4g.small"  # 2 vCPU, 2GB    ~$12/mo (ARM Graviton)
    medium = "t4g.medium" # 2 vCPU, 4GB    ~$24/mo (ARM Graviton)
  }

  regions = {
    eu_central = "eu-central-1"
    eu_west    = "eu-west-1"
    us_east    = "us-east-1"
    us_west    = "us-west-2"
  }

  vm_instance_type = local.vm_sizes[var.vm_size]
  region           = local.regions[var.region]
  name_prefix      = var.project_name
}

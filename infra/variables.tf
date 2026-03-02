variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "hofmeister"
}

variable "region" {
  description = "Deployment region"
  type        = string
  default     = "eu_central"

  validation {
    condition     = contains(["eu_central", "eu_west", "us_east", "us_west"], var.region)
    error_message = "Region must be one of: eu_central, eu_west, us_east, us_west"
  }
}

variable "vm_size" {
  description = "VM size (nano, micro, small, medium)"
  type        = string
  default     = "nano"

  validation {
    condition     = contains(["nano", "micro", "small", "medium"], var.vm_size)
    error_message = "VM size must be one of: nano, micro, small, medium"
  }
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = []
}

variable "domain_name" {
  description = "Domain name for DNS zone"
  type        = string
  default     = "hofmeister.dev"
}

variable "email" {
  description = "Email for Let's Encrypt certificate"
  type        = string
}

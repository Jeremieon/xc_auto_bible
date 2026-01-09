variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "my-resource-group"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  type        = string
  default     = "172.16.1.0/24"
}

variable "f5xc_default_sw_version" {
  type        = bool
  description = "Use default software version (true) or specify custom version (false). If true, volterra_software_version must not be specified"
  default     = true

  validation {
    condition     = can(var.f5xc_default_sw_version)
    error_message = "f5xc_default_sw_version must be a boolean value."
  }
}
variable "outside_subnet_cidr" {
  description = "CIDR for outside subnet"
  type        = string
  default     = "172.16.2.0/24"
}

variable "inside_subnet_cidr" {
  description = "CIDR for inside subnet"
  type        = string
  default     = "172.16.3.0/24"
}

variable "f5xc-ce-site-name" {
  description = "F5XC CE site/cluster name (will be used as prefix for resources)"
  type        = string
  default     = "my-f5xc-site"
}

variable "f5xc_sms_instance_type" {
  description = "Azure instance type (allowed: Standard_D8_v4, Standard_D16_v4)"
  type        = string
  default     = "Standard_D8_v4"

  validation {
    condition     = contains(["Standard_D8_v4", "Standard_D16_v4"], var.f5xc_sms_instance_type)
    error_message = "Invalid Azure instance type. Allowed values are: Standard_D8_v4 or Standard_D16_v4."
  }
}

variable "f5xc_sms_storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  type        = string
  default     = "Standard_LRS"
}

variable "f5xc_api_url" {
  type    = string
  default = "https://your-tenant.console.ves.volterra.io/api"
}

variable "f5xc_api_p12_file" {
  type        = string
  description = "Path to F5XC API credentials P12 file (download from F5XC console)"
  default     = "/path/to/your/api-creds.p12"
}

variable "f5xc_sms_description" {
  type    = string
  default = "F5XC Azure site created with Terraform"
}


variable "create_f5xc_vsite_resources" {
  type        = bool
  description = "Create the F5XC vsite key and label resources"
  default     = true
}

variable "node_count" {
  type        = number
  description = "Number of F5XC CE nodes to deploy"
  default     = 1
  validation {
    condition     = var.node_count >= 1 && var.node_count <= 10
    error_message = "Node count must be between 1 and 10."
  }
}


variable "owner" {
  description = "Creator of the Azure ressources"
  default     = "pveys"
}



variable "ssh_username" {
  type        = string
  description = "ssh user for the F5XC CE"
  default     = "cloud-user"
}
variable "location" {
  description = "Azure location name"
  default     = "francecentral"
}

variable "slo-private-ip" {
  description = "Private IP for SLO"
  default     = "172.16.2.10"
}

variable "sli-private-ip" {
  description = "Private IP for SLI"
  default     = "172.16.3.10"
}



variable "f5xc_software_version" {
  type        = string
  description = "F5XC software version for the site (only specify if default_sw_version is false)"
  default     = null
}



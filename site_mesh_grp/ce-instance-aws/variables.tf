variable "tenant_name" {
  description = "REQUIRED: F5 Distributed Cloud tenant ID"
  type        = string
}

variable "namespace" {
  description = "REQUIRED: F5 Distributed Cloud namespace to deploy objects into"
  type        = string
  default     = "default"
}

variable "f5xc_vsite_key_label" {
  type        = string
  description = "F5XC virtual site key label value"
  default     = "yes"
}

variable "create_f5xc_virtual_site" {
  type        = bool
  description = "Create F5XC Virtual Site"
  default     = false
}

variable "f5xc_virtual_site_name" {
  type        = string
  description = "F5XC Virtual Site name"
  default     = ""
}

variable "f5xc-ce-site-name" {
  description = "F5XC CE site/cluster name (will be used as prefix for resources)"
  type        = string
  default     = "my-f5xc-site"
}


variable "f5xc_vsite_key" {
  type        = string
  description = "F5XC virtual site key for site selection"
  default     = "my-vsite-key"
}
variable "create_f5xc_vsite_resources" {
  type        = bool
  description = "Create the F5XC vsite key and label resources"
  default     = true
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

variable "aws_region" {
  type        = string
  description = "This  is the region where big-ip was deployed"
  default     = "us-east-1"
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

variable "f5xc_sms_description" {
  type    = string
  default = "F5XC AWS site created with Terraform"
}


variable "azr_public_ip" {
  description = "Ip of remote CE "
  type        = string
  default     = "0.0.0.0"
}

variable "f5xc_software_version" {
  type        = string
  description = "F5XC software version for the site (only specify if default_sw_version is false)"
  default     = null
}

variable "public_ip" {
  description = "Public IP from AWS instance"
  type        = string
  default     = "0.0.0.0"
}

variable "volterra_url" {
  description = "Volterra API URL"
  type        = string
  default     = "https://f5-emea-ent.console.ves.volterra.io/api"
}

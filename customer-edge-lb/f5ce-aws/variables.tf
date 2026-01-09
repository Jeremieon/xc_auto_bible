#instance/variable.tf
variable "f5xc_ce_site_name" {
  description = "F5XC CE site/cluster name (will be used as prefix for resources)"
  type        = string
  default     = "my-f5xc-site"
}

variable "owner" {
  description = "Owner tag for AWS resources"
  type        = string
  default     = "your-name"
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

variable "slo-private-ip" {
  description = "Private IP for SLO interface"
  type        = string
}

variable "sli-private-ip" {
  description = "Private IP for SLI interface"
  type        = string
}
variable "aws-f5xc-ami" {
  description = "F5XC CE AMI ID (obtain from F5 Distributed Cloud console)"
  type        = string
  default     = "ami-xxxxxxxxxxxxxxxxx"
}

variable "aws-ec2-flavor" {
  type        = string
  description = "EC2 instance type (allowed: m5.2xlarge, m5.4xlarge)"
  default     = "m5.2xlarge"

  validation {
    condition     = contains(["m5.2xlarge", "m5.4xlarge"], var.aws-ec2-flavor)
    error_message = "Invalid EC2 instance type. Allowed values are: m5.2xlarge or m5.4xlarge."
  }
}

variable "f5xc_api_url" {
  type    = string
  default = "https://your-tenant.console.ves.volterra.io/api"
}

# variable "aws_ssh_key" {
#   description = "AWS SSH key pair name for EC2 instance access"
#   type        = string
#   default     = "my-ssh-key"
# }

variable "aws-region" {
  description = "AWS region for F5XC CE deployment"
  type        = string
  default     = "us-east-1"
}

variable "deploy_nlb" {
  type        = bool
  description = "Deploy AWS Network Load Balancer"
  default     = false
}

variable "nlb_target_ports" {
  type        = list(number)
  description = "Target ports for NLB to forward traffic to F5XC CE nodes"
  default     = [80, 443]
}

variable "nlb_health_check_port" {
  type        = number
  description = "Port for NLB health check"
  default     = 80
}

variable "f5xc_sms_description" {
  type    = string
  default = "F5XC AWS site created with Terraform"
}

# --- vpc/variable.tf ---
variable "name-prefix" {
  description = "Name of the instance"
  type        = string
}

variable "aws_region" {
  description = "region instance was deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "create_f5xc_loadbalancer" {
  type        = bool
  description = "Create F5XC HTTP Load Balancer"
  default     = true
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "outside_subnet_cidr" {
  description = "The CIDR block for the Subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "inside_subnet_cidr" {
  description = "The CIDR block for the Subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone" {
  description = "The az for the VPC"
  type        = string
  default     = "us-east-1a"
}

variable "f5xc_api_p12_file" {
  type        = string
  description = "Path to F5XC API credentials P12 file (download from F5XC console)"
  default     = "./api-creds.p12"
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
# --- instance/variable.tf ---

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "aws_ami" {
  description = "value"
  type        = string
  default     = "ami-0c398cb65a93047f2"
}

variable "key_name" {
  type    = string
  default = null
}


variable "f5xc_software_version" {
  type        = string
  description = "F5XC software version for the site (only specify if default_sw_version is false)"
  default     = null
}

variable "namespace" {
  type        = string
  description = "Namespace for the load balancer"
  default     = "system"
}

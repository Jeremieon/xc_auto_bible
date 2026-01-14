# --- vpc/variable.tf ---
variable "aws_region" {
  description = "region instance was deployed"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidr_block" {
  description = "The CIDR block for the Subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "private_subnet_cidr_block" {
  description = "The CIDR block for the Subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "The az for the VPC"
  type        = string
  default     = "us-east-1a"
}

# --- instance/variable.tf ---
variable "instance_name" {
  description = "name of Instances"
  type        = string
}
variable "instance_type" {
  description = "the type of instance to be created"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "aws_ami" {
  description = "value"
  type        = string
}
variable "user_data_script" {
  description = "Script run after Vm deployment"
  type        = string
  default     = ""
}

variable "key_name" {
  type    = string
  default = null
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  sensitive   = true
}

# --- vpc/variable.tf ---
variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "aws_region" {
  description = "region instance was deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zone" {
  description = "The az for the VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block for the Subnet"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "The CIDR block for the Subnet"
  type        = string
}



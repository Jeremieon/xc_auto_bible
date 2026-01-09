# --- terraform/main.tf ---
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}



provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                    = "./modules/vpc"
  instance_name             = var.instance_name
  aws_region                = var.aws_region
  vpc_cidr_block            = var.vpc_cidr_block
  availability_zone         = var.availability_zone
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
}

module "instance" {
  source               = "./modules/instance"
  instance_name        = var.instance_name
  aws_ami              = var.aws_ami
  instance_type        = var.instance_type
  vpc_id               = module.vpc.vpc_id
  my_public_subnet_id  = module.vpc.my_public_subnet_id
  my_private_subnet_id = module.vpc.my_private_subnet_id
  instance_count       = var.instance_count
  key_name             = var.key_name
  user_data_script     = file("${path.module}/user_data.sh")
  ssh_public_key       = var.ssh_public_key
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }
  }

  cloud {
    organization = "jeremieonk"
    workspaces {
      name = "xc-me"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

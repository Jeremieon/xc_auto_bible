terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.12.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "volterra" {
  url = var.f5xc_api_url
}

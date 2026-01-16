terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.11.42"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws-region
}

provider "volterra" {
  url          = var.volterra_url
  api_p12_file = var.f5xc_api_p12
  VES_P12_PASSWORD = var.tosii
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "remote" {
    organization = "jeremieonk"

    workspaces {
      name = "xc_auto_bible"
    }
  }
}

terraform {
  required_version = ">= 0.14.0"

  backend "remote" {
    organization = "jeremieonk"

    workspaces {
      name = "xc_me"
    }
  }

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.40"
    }
  }
}


provider "volterra" {
  url = var.volterra_url
}

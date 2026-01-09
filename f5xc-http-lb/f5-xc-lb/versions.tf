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
      version = "= 0.11.40"
    }
  }
}



# provider "volterra" {
#   api_p12_file = "${path.module}/api.p12"
#   url          = "https://${var.tenant_name}.console.ves.volterra.io/api"
# }

provider "volterra" {
  
  url = var.volterra_url
}

terraform {
  required_version = ">= 0.14.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.12.2"
    }
  }
}

provider "volterra" {
  # We point the provider to the filename created above
  api_p12_file = "${path.module}/api.p12"
  url          = "https://${var.tenant_name}.console.ves.volterra.io/api"
}



terraform {
  required_version = ">= 1.8.0, < 2.0.0"

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "= 0.11.40"
    }
  }
}

resource "local_file" "cert_file" {
  content_base64 = var.api_p12
  filename       = "${path.module}/certificate.p12"
}

provider "volterra" {
  api_p12_file = local_file.cert_file.filename
  url          = "https://${var.tenant_name}.console.ves.volterra.io/api"
}



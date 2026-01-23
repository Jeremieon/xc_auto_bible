# F5XC resources (Site / Token / Cloud-init)
resource "volterra_known_label_key" "vsite_key" {
  count     = var.create_f5xc_vsite_resources && var.f5xc_vsite_key != "" ? 1 : 0
  key       = var.f5xc_vsite_key
  namespace = "shared"
}

resource "volterra_known_label" "vsite_label" {
  count      = var.create_f5xc_vsite_resources && var.f5xc_vsite_key_label != "" ? 1 : 0
  depends_on = [volterra_known_label_key.vsite_key]
  key        = var.f5xc_vsite_key
  namespace  = "shared"
  value      = var.f5xc_vsite_key_label
}

resource "volterra_securemesh_site_v2" "site" {
  depends_on              = [volterra_known_label_key.vsite_key, volterra_known_label.vsite_label]
  name                    = format("%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex)
  namespace               = "system"
  description             = var.f5xc_sms_description
  block_all_services      = true
  logs_streaming_disabled = true
  enable_ha               = false
  labels = merge({
    "ves.io/provider" = "ves-io-Azure"
    }, var.f5xc_vsite_key != "" && var.f5xc_vsite_key_label != "" ? {
    "${var.f5xc_vsite_key}" = "${var.f5xc_vsite_key_label}"
  } : {})

  re_select {
    geo_proximity = true
  }

  azure {
    not_managed {
      node_list {
        type      = "Control"
        public_ip = azurerm_public_ip.ce_public_ip
        interface_list {
          static_ip {
            ip_address = var.inside_subnet_cidr
          }
          network_option {
            site_local_inside_network = true
          }
          site_to_site_connectivity_interface_enabled = true
        }

      }

    }

  }
  site_mesh_group_on_slo {
    sm_connection_public_ip = true
  }
}

resource "volterra_token" "smsv2_token" {
  depends_on = [volterra_securemesh_site_v2.site]
  name       = format("%s-%s-%s", var.f5xc-ce-site-name, random_id.suffix.hex, "token")
  namespace  = "system"
  type       = 1
  site_name  = volterra_securemesh_site_v2.site.name
}

resource "volterra_virtual_site" "vsite" {
  count      = var.create_f5xc_virtual_site && var.f5xc_virtual_site_name != "" ? 1 : 0
  depends_on = [volterra_known_label_key.vsite_key, volterra_known_label.vsite_label]
  name       = var.f5xc_virtual_site_name
  namespace  = "shared"

  site_selector {
    expressions = ["${var.f5xc_vsite_key} in (${var.f5xc_vsite_key_label})"]
  }

  site_type = "CUSTOMER_EDGE"
}

data "cloudinit_config" "f5xc_ce_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      #cloud-config
      write_files = [
        {
          path        = "/etc/vpm/user_data"
          permissions = "0644"
          owner       = "root"
          content     = <<-EOT
            token: ${trimprefix(trimprefix(volterra_token.smsv2_token.id, "id="), "\"")}
          EOT
        }
      ]
    })
  }
}

terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">=0.11.42"
    }

  }
}

provider "volterra" {
  api_p12_file = var.api_p12_file
  url          = var.xc_api_url
}


#=====================
# Get LB State Data #
#=====================
data "volterra_http_loadbalancer_state" "lb-state" {
  name      = volterra_http_loadbalancer.https_auto_cert-lb.name
  namespace = var.namespace
}

#=====================
# Create Health Check #
#=====================
resource "volterra_healthcheck" "http-health-check" {
  name      = "${var.namespace}-http-hc"
  namespace = var.namespace

  http_health_check {
    use_origin_server_name = true
    path                   = "/"
    use_http2              = false
    expected_status_codes  = ["200"]
  }

  timeout             = 3
  interval            = 15
  unhealthy_threshold = 1
  healthy_threshold   = 3
  jitter_percent      = 30
}

#=====================
# Create Origin Pool #
#=====================

resource "volterra_origin_pool" "http-origin-pool" {
  name      = "${var.namespace}-tf-pool"
  namespace = var.namespace

  origin_servers {
    private_ip {
      ip             = var.inside_network_IP
      inside_network = true
      site_locator {
        site {
          name      = var.site_name
          namespace = "system"
        }
      }

    }
  }
  port                  = var.port
  same_as_endpoint_port = true
  no_tls                = true
  healthcheck {
    namespace = var.namespace
    name      = volterra_healthcheck.http-health-check.name

  }
  loadbalancer_algorithm = "LB_OVERRIDE"
  endpoint_selection     = "LOCALPREFERED"
}

#=======================
# Create Load Balancer #
#=======================
resource "volterra_http_loadbalancer" "https_auto_cert-lb" {
  name      = "${var.namespace}-tf-http-lb"
  namespace = var.namespace
  domains   = ["${var.namespace}s.labtestdemo.com"]

  https_auto_cert {
    add_hsts                = true
    http_redirect           = true
    port                    = 443
    connection_idle_timeout = "60000"
    no_mtls                 = true
    tls_config {
      default_security = true
    }
  }
  # Or advertise on RE (internet)
  # advertise_on_public_default_vip = true
  # Advertise on CE public IP
  advertise_custom {
    advertise_where {
      site {
        network = var.site_adv_network
        site {
          namespace = "system"
          name      = var.site_name
        }
      }
    }
  }
  #   http {
  #     dns_volterra_managed = false
  #     port                 = 80
  #   }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.http-origin-pool.name
      namespace = var.namespace
    }
    weight           = 1
    priority         = 1
    endpoint_subsets = {}
  }
  disable_api_definition           = true
  disable_waf                      = true
  add_location                     = true
  no_challenge                     = true
  user_id_client_ip                = true
  disable_rate_limit               = true
  service_policies_from_namespace  = true
  round_robin                      = true
  disable_trust_client_ip_headers  = true
  disable_malicious_user_detection = true
  disable_api_discovery            = true
  disable_bot_defense              = true
  disable_ip_reputation            = true
  disable_client_side_defense      = true
  no_service_policies              = true
  source_ip_stickiness             = true
}

#===========================
#  CREATE DNS ZONE & RECORDS
#===========================

# resource "volterra_dns_zone" "main_zone" {
#   name      = "sample.io"
#   namespace = "system"
#   primary {
#     default_soa_parameters = true
#     dnssec_mode {
#       disable = true
#     }
#     allow_http_lb_managed_records = false
#     default_rr_set_group {
#       ttl = 86400
#       ns_record {
#         values = ["ns1.f5clouddns.com", "ns2.f5clouddns.com"]
#       }
#     }
#   }
# }

# resource "volterra_dns_zone_record" "mz_record" {
#   dns_zone_name = volterra_dns_zone.main_zone.name
#   group_name    = "default_rr_set_group"
#   rrset {
#     description = "description"
#     ttl         = "3600"
#     a_record {
#       name   = "j-agboola"
#       values = [var.frontend_public_ip]
#     }
#   }
# }





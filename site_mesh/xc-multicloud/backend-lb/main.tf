#=====================
# Get LB State Data #
#=====================
data "volterra_http_loadbalancer_state" "lb-state" {
  name      = volterra_http_loadbalancer.http-internal-lb.name
  namespace = var.namespace
}

#=====================
# Create Health Check #
#=====================
resource "volterra_healthcheck" "http-internal-hc" {
  name      = "${var.namespace}-httpint-hc"
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

resource "volterra_origin_pool" "http-backend-pool" {
  name                   = "${var.namespace}-internal-pool"
  namespace              = var.namespace
  loadbalancer_algorithm = "LB_OVERRIDE"
  endpoint_selection     = "LOCALPREFERED"
  port                   = var.port
  same_as_endpoint_port  = true
  no_tls                 = true

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

  healthcheck {
    namespace = var.namespace
    name      = volterra_healthcheck.http-internal-hc.name
  }

}

#=======================
# Create Load Balancer #
#=======================
resource "volterra_http_loadbalancer" "http-internal-lb" {
  name      = "${var.namespace}-internal-http-lb"
  namespace = var.namespace
  domains   = ["azure.backend.internal"]


  # Or advertise on RE (internet)
  # advertise_on_public_default_vip = true
  # Advertise on CE public IP
  advertise_custom {
    advertise_where {
      site {
        network = var.site_adv_network
        site {
          namespace = "system"
          name      = var.site_adv_name
        }
      }
    }
  }
  http {
    dns_volterra_managed = false
    port                 = 80
  }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.http-backend-pool.name
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





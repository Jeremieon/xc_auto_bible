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
  name                   = "${var.namespace}-tf-pool"
  namespace              = var.namespace
  loadbalancer_algorithm = "LB_OVERRIDE"
  endpoint_selection     = "LOCALPREFERED"
  port                   = var.port
  same_as_endpoint_port  = true
  no_tls                 = true
  healthcheck {
    namespace = var.namespace
    name      = volterra_healthcheck.http-health-check.name
  }
  origin_servers {
    public_ip {
      ip = var.public_ip
    }
  }
}

#=======================
# Create Load Balancer #
#=======================
resource "volterra_http_loadbalancer" "https_auto_cert-lb" {
  name      = "${var.namespace}-tf-http-lb"
  namespace = var.namespace
  domains   = ["${var.namespace}.${var.domain}"]
  app_firewall {
    name      = volterra_app_firewall.waf.name
    namespace = var.namespace
  }
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

  advertise_on_public_default_vip = true

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
  disable_waf                      = false
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





#=====================================#
#  CREATE APPLICATION FIREWALL Policy #
#=====================================#

resource "volterra_app_firewall" "waf" {
  name      = "${var.namespace}-appfwl"
  namespace = var.namespace

  allow_all_response_codes = true
  default_anonymization    = true
  blocking_page {
    response_code = "OK"
    blocking_page = "string:///PCFkb2N0eXBlIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KICA8aGVhZD4KICAgIDx0aXRsZT5SZXF1ZXN0IFJlamVjdGVkPC90aXRsZT4KICAgIDxsaW5rIGhyZWY9Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9ucG0vYm9vdHN0cmFwQDUuMy4wL2Rpc3QvY3NzL2Jvb3RzdHJhcC5taW4uY3NzIiByZWw9InN0eWxlc2hlZXQiIGludGVncml0eT0ic2hhMzg0LTluZEN5VWFJYnpBaTJGVVZYSmkwQ2ptQ2FwU21PN1NucEplZjA0ODZxaExudVoyY2RlUmhPMDJpdUs2RlVVVk0iIGNyb3Nzb3JpZ2luPSJhbm9ueW1vdXMiPgogIDwvaGVhZD4KICA8Ym9keT4KPG1haW4+CiAgPGRpdiBjbGFzcz0iY29udGFpbmVyIHB5LTQiPgogICAgPGhlYWRlciBjbGFzcz0icGItMyBtYi00IGJvcmRlci1ib3R0b20iPgogICAgICA8YSBocmVmPSJqYXZhc2NyaXB0Omhpc3RvcnkuYmFjaygpIiBjbGFzcz0iZC1mbGV4IGFsaWduLWl0ZW1zLWNlbnRlciB0ZXh0LWRhcmsgdGV4dC1kZWNvcmF0aW9uLW5vbmUiPgogICAgICAgIDxzcGFuIGNsYXNzPSJmcy00IGZ3LWxpZ2h0IHRleHQtZGFuZ2VyIj5CbG9ja2VkIFBhZ2U8L3NwYW4+CiAgICAgIDwvYT4KICAgIDwvaGVhZGVyPgoKICAgIDxkaXYgY2xhc3M9InAtNSBtYi00IGJnLWxpZ2h0IHJvdW5kZWQtMyI+CiAgICAgIDxkaXYgY2xhc3M9ImNvbnRhaW5lci1mbHVpZCBweS01Ij4KICAgICAgICA8aSBjbGFzcz0iYmkgYmktZXhjbGFtYXRpb24tZGlhbW9uZC1maWxsICI+PC9pPjxoMSBjbGFzcz0iZGlzcGxheS01IGZ3LWJvbGQgdGV4dC1kYW5nZXIiPlJlcXVlc3QgQmxvY2tlZDwvaDE+CiAgICAgICAgPHAgY2xhc3M9ImZzLTQiPlRoaXMgaXMgYW4gZXJyb3IgcGFnZSBhcyBhIHJlc3VsdCBvZiBXcm9uZyBvciBtYWxpY2lvdXMgcmVxdWVzdCBmcm9tIHRoZSB1c2VyLkNvbnN1bHQgd2l0aCB5b3VyIGFkbWluaXN0cmF0b3IgaWYgZXJyb3IgcGVyc2lzdHMhITwvcD4KICAgICAgICA8cCBjbGFzcz0iZnMtNiI+WW91ciBzdXBwb3J0IElEIGlzOi0ge3tyZXF1ZXN0X2lkfX08L3A+CiAgICAgICAgPHAgY2xhc3M9ImZzLTYiPlRoYW5rIFlvdSEhITwvcD4KICAgICAgICA8YSBjbGFzcz0iYnRuIGJ0bi1pbmZvIGJ0bi1sZyIgaHJlZj0iamF2YXNjcmlwdDpoaXN0b3J5LmJhY2soKSI+UmV0dXJuPC9hPgogICAgICA8L2Rpdj4KICAgIDwvZGl2PgogICAgPGZvb3RlciBjbGFzcz0icHQtMyBtdC00IHRleHQtbXV0ZWQgYm9yZGVyLXRvcCB0ZXh0LWNlbnRlciI+CiAgICAgIEpFUkVNSUFIJmNvcHk7IDIwMjMtMjAzMwogICAgPC9mb290ZXI+CiAgPC9kaXY+CjwvbWFpbj4KICA8L2JvZHk+CjwvaHRtbD4K"

  }
  #default_bot_setting = true
  default_detection_settings = true
  blocking                   = true
}




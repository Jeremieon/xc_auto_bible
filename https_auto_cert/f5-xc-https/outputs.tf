output "http_lb_fqdn" {
  value = volterra_http_loadbalancer.https_auto_cert-lb.domains
}

output "http_lb_public_ip" {
  value = volterra_http_loadbalancer.https_auto_cert-lb.domains
}


output "http_lb_state" {
  value = data.volterra_http_loadbalancer_state.lb-state.state
}

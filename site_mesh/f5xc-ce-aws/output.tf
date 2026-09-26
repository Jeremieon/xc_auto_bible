# CE Instance
output "ce_instance_id" {
  value = aws_instance.smsv2-aws-tf[*].id
}

output "ce_public_ip" {
  value = aws_eip.public_ip.public_ip
}

output "ce_outside_private_ip" {
  value = aws_network_interface.outside[*].private_ip
}

output "ce_inside_private_ip" {
  value = aws_network_interface.inside[*].private_ip
}

# Frontend App Instance

output "private_app_ip" {
  value = aws_instance.private_app_server[*].private_ip
}

output "aws_site_name" {
  value = join(",", volterra_securemesh_site_v2.site[*].name)
}

# Route53
output "backend_dns_name" {
  value = aws_route53_record.azure_backend.fqdn
}


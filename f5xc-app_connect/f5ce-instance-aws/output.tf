# VPC & Networking
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "outside_subnet_id" {
  value = aws_subnet.outside.id
}

output "inside_subnet_id" {
  value = aws_subnet.inside.id
}

# CE Instance
output "ce_instance_id" {
  value = aws_instance.smsv2-aws-tf.id
}

output "ce_public_ip" {
  value = aws_eip.public_ip.public_ip
}

output "ce_outside_private_ip" {
  value = aws_network_interface.public.private_ip
}

output "ce_inside_private_ip" {
  value = aws_network_interface.private.private_ip
}

# Frontend App Instance

output "frontend_private_ip" {
  value = aws_instance.private_app_server[0].private_ip
}

# Route53
output "backend_dns_name" {
  value = aws_route53_record.azure_backend.fqdn
}


# SSH Command
output "ssh_to_ce" {
  value = "ssh -i ~/.ssh/id_rsa cloud-user@${aws_eip.public_ip.public_ip}"
}

output "ssh_to_frontend" {
  value = "ssh -i ~/.ssh/id_rsa -J cloud-user@${aws_eip.public_ip.public_ip} ubuntu@${aws_instance.private_app_server[0].private_ip}"
}

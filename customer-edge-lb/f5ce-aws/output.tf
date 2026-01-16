# --- vpc/output.tf ---


output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "private_app_ip" {
  value = aws_instance.private_app_server[0].private_ip
}

output "ce_public_ip" {
  value = aws_eip.public_ip
}

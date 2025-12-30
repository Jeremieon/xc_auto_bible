# --- instance/output.tf ---
output "public_instance_ids" {
  value = aws_instance.app_server[*].id
}

output "private_instance_ids" {
  value = aws_instance.private_app_server[*].id
}

output "public_ips" {
  description = "Public IPs of all public instances"
  value       = aws_instance.app_server[*].public_ip
}
output "private_ips" {
  description = "Private IPs of all private instances"
  value       = aws_instance.private_app_server[*].private_ip
}

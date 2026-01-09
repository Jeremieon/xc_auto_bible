# --- vpc/output.tf ---


output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

# # --- instance/output.tf ---
# output "public_instance_ids" {
#   value = aws_instance.app_server[*].id
# }

# output "private_instance_ids" {
#   value = aws_instance.private_app_server[*].id
# }

# output "public_ips" {
#   description = "Public IPs of all public instances"
#   value       = aws_instance.app_server[*].public_ip
# }
# output "private_ips" {
#   description = "Private IPs of all private instances"
#   value       = aws_instance.private_app_server[*].private_ip
# }

# output "public_subnet_id" {
#   description = "Public subnet ID"
#   value       = aws_subnet.public.id
# }

# output "outside_subnet_id" {
#   description = "Outside subnet ID"
#   value       = aws_subnet.outside.id
# }

# output "inside_subnet_id" {
#   description = "Inside subnet ID"
#   value       = aws_subnet.inside.id
# }

# output "nat_gateway_id" {
#   description = "NAT Gateway ID"
#   value       = aws_nat_gateway.nat_gw.id
# }

# output "internet_gateway_id" {
#   description = "Internet Gateway ID"
#   value       = aws_internet_gateway.igw.id
# }

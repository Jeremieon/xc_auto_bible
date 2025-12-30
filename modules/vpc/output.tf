# --- vpc/output.tf ---

output "my_public_subnet_id" {
  value = aws_subnet.my_public_subnet.id
}

output "my_private_subnet_id" {
  value = aws_subnet.my_private_subnet.id
}
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

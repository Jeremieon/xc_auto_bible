output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "outside_subnet_id" {
  value = aws_subnet.outside.id
}

output "inside_subnet_id" {
  value = aws_subnet.inside.id
}

output "aws_region" {
  value = var.aws_region
}

output "availability_zone" {
  value = var.availability_zone
}

output "outside_sg_id" {
  value = aws_security_group.EC2-CE-sg-SLO.id
}

output "inside_sg_id" {
  value = aws_security_group.EC2-CE-sg-SLI.id
}

output "public_ip" {
  value = aws_eip.public_ip.public_ip
}

output "random_suffix" {
  value = random_id.suffix.hex
}

output "f5xc_ce_site_name" {
  value = var.f5xc_ce_site-name
}

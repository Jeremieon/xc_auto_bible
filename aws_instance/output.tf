# --- vpc/output.tf ---
output "subnet_ids" {
  value = [
    module.vpc.my_public_subnet_id,
    module.vpc.my_private_subnet_id
  ]
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
# --- instance/output.tf ---
output "public_instance_ids" {
  value = module.instance.public_instance_ids
}

output "private_instance_ids" {
  value = module.instance.private_instance_ids
}

output "public_ip" {
  description = "First public IP (primary instance)"
  value       = module.instance.public_ips[0]
}


output "public_ips" {
  value = module.instance.public_ips
}

output "private_ips" {
  value = module.instance.private_ips
}

# Example terraform.tfvars file
# Copy this to terraform.tfvars and customize with your values

# AWS Configuration
aws_region              = "us-east-1"
aws-f5xc-ami            = "ami-08a006458983be57e"
name-prefix             = "jeremieon"
vpc_cidr                = "10.0.0.0/16"
owner                   = "jeremy"
f5xc_default_sw_version = true

slo-private-ip = "10.0.2.10"
sli-private-ip = "10.0.3.10"

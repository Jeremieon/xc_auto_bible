# Example terraform.tfvars file
# Copy this to terraform.tfvars and customize with your values

# AWS Configuration
aws_region              = "us-east-1"
aws-f5xc-ami            = "ami-08a006458983be57e"
name-prefix             = "jeremieons"
vpc_cidr                = "10.0.0.0/16"
owner                   = "jeremy"
f5xc_default_sw_version = true
# F5XC Site Configuration
f5xc_ce_site_name = "jerry-aws-site"
node_count        = 1
aws-ec2-flavor    = "m5.2xlarge"
# F5XC API Configuration
f5xc_api_url         = "https://f5-emea-ent.console.ves.volterra.io/api"
f5xc_api_p12_file    = "./api-creds.p12"
f5xc_sms_description = "F5XC SMSv2 AWS site created with Terraform"

slo-private-ip = "10.0.2.10"
sli-private-ip = "10.0.3.10"

deploy_nlb            = true
nlb_target_ports      = [80, 443]
nlb_health_check_port = 80


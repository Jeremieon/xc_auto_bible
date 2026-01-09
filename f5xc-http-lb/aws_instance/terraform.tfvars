aws_region                = "us-east-1"
aws_ami                   = "ami-04b70fa74e45c3917"
instance_type             = "t2.micro"
#user_data_script          = <<EOT
# #!/bin/bash
# # sudo apt-get update -y
# # sudo apt-get install -y docker.io
# # sudo systemctl start docker
# sudo docker run -d -p 80:80 nginx:latest
# EOT
instance_name             = "jeremieon"
instance_count            = 1
vpc_cidr_block            = "10.0.0.0/16"
public_subnet_cidr_block  = "10.0.1.0/24"
private_subnet_cidr_block = "10.0.2.0/24"
availability_zone         = "us-east-1a"
key_name                  = "admin-key"


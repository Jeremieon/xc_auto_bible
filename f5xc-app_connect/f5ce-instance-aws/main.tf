resource "random_id" "suffix" {
  byte_length = 2
}
# --- vpc/main.tf ---
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = format("%s-VPC", var.name-prefix)
  }
}

#public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet", var.name-prefix)
  }
}
#Outside Subnet (private with NAT gateway can be added later)
resource "aws_subnet" "outside" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.outside_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = format("%s-outside-subnet", var.name-prefix)
  }
}

#Inside Subnet

resource "aws_subnet" "inside" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.inside_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = format("%s-inside-subnet", var.name-prefix)
  }
}

#internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = format("%s-igw", var.name-prefix)
  }
}

#Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = format("%s-nat-gateway-eip", var.name-prefix)
  }
  depends_on = [aws_internet_gateway.igw]
}

#NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = format("%s-nat-gateway", var.name-prefix)
  }
  depends_on = [aws_internet_gateway.igw]
}

#Public Route
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = format("%s-public-rt", var.name-prefix)
  }
}

#Public Route Association
resource "aws_route_table_association" "instance_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

#Outside Route Table to NAT Gateway
resource "aws_route_table" "outside_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    #nat_gateway_id = aws_nat_gateway.nat_gw.id
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = format("%s-outside-rt", var.name-prefix)
  }
}

#Outside Route Association
resource "aws_route_table_association" "outside_rt_association" {
  subnet_id      = aws_subnet.outside.id
  route_table_id = aws_route_table.outside_rt.id
}

#Inside Route Table(Local)
resource "aws_route_table" "inside_rt" {
  vpc_id = aws_vpc.main_vpc.id


  tags = {
    Name = format("%s-inside-rt", var.name-prefix)
  }
}

resource "aws_route" "inside_to_nat" {
  route_table_id         = aws_route_table.inside_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

#Inside Route Association
resource "aws_route_table_association" "inside_rt_association" {
  subnet_id      = aws_subnet.inside.id
  route_table_id = aws_route_table.inside_rt.id
}

#
#AWS security group for the instance
#
resource "aws_security_group" "EC2-CE-sg-SLO" {
  name        = format("%s-%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex, "sg-SLO")
  description = "Allow traffic flows on SLO, ingress and egress"
  vpc_id      = aws_vpc.main_vpc.id


  #
  #Please uncomment / adapt the two rules bellow to allow ICMP and/or SSH access to the public IP of SLO interface
  #
  ingress {
    description = "SSH from trusted"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }

  ingress {
    from_port   = 8000
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }

  ingress {
    from_port   = 3000
    to_port     = 3080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }


  ingress {
    description = "ICMP from trusted"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }

  #
  #Please uncomment / adapt the rule bellow if you plan to use the site mesh group feature over a public IP
  #
  ingress {
    description = "IPSEC from any"
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }


  #
  #Please adapt the following rule if needed. CE need outgoing access to TCP 53(DNS), 443(HTTPS) and UDP 53(DNS), 123(NTP)
  #
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = format("%s-%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex, "sg-SLO")
    owner = var.owner
  }
}

resource "aws_security_group" "EC2-CE-sg-SLI" {
  name        = format("%s-%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex, "sg-SLI")
  description = "Allow traffic flows on SLI, ingress and egress"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #change to specific IP/CIDR for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = format("%s-%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex, "sg-SLI")
    owner = var.owner
  }
}

#
# CE interfaces creation. Comment / uncomment private_ips if you want or not use static IPs on the CEs
#
# Create a public network interface (SLO) for the F5XC CE
resource "aws_network_interface" "public" {
  subnet_id         = aws_subnet.outside.id
  security_groups   = [aws_security_group.EC2-CE-sg-SLO.id]
  private_ips       = [var.slo-private-ip]
  source_dest_check = false
  tags = {
    Name  = format("%s-%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex, "eni-pub")
    owner = var.owner
  }
}

# Create a private network interface (SLI) for the F5XC CE
resource "aws_network_interface" "private" {
  subnet_id         = aws_subnet.inside.id
  security_groups   = [aws_security_group.EC2-CE-sg-SLI.id]
  private_ips       = [var.sli-private-ip]
  source_dest_check = false
  tags = {
    Name  = format("%s-%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex, "eni-priv")
    owner = var.owner
  }
}


# Create a private application server instance in the private subnet
resource "aws_instance" "private_app_server" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.inside.id
  count                  = var.instance_count
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.EC2-CE-sg-SLI.id]
  depends_on = [
    aws_nat_gateway.nat_gw,
    aws_route.inside_to_nat
  ]
  user_data = file("${path.module}/user_data.sh")
  tags = {
    Name = format("%s-private-instance", var.name-prefix)
  }
}

#
# Public E. IP creation
#
resource "aws_eip" "public_ip" {
  domain = "vpc"
}

resource "aws_eip_association" "eip_attach" {
  allocation_id        = aws_eip.public_ip.id
  network_interface_id = aws_network_interface.public.id
}



#
#Create the F5XC CE EC2 ressource
#
resource "aws_key_pair" "my_key" {
  key_name   = "${var.name-prefix}-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_instance" "smsv2-aws-tf" {
  depends_on    = [aws_security_group.EC2-CE-sg-SLI]
  ami           = var.aws-f5xc-ami
  instance_type = var.aws-ec2-flavor
  key_name      = aws_key_pair.my_key.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.public.id
  }
  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.private.id
  }
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 80
  }

  user_data = data.cloudinit_config.f5xc-ce_config.rendered

  tags = {
    Name                                                                     = format("%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex)
    ves-io-site-name                                                         = format("%s-%s", var.f5xc_ce_site_name, random_id.suffix.hex)
    "kubernetes.io/cluster/${var.f5xc_ce_site_name}-${random_id.suffix.hex}" = "owned"
  }
}

# Create Private Hosted Zone
resource "aws_route53_zone" "private" {
  name = "backend.internal"

  vpc {
    vpc_id = aws_vpc.main_vpc.id
  }

  tags = {
    Name = "private-dns-zone"
  }
}

# Create A Record for Azure Backend
resource "aws_route53_record" "azure_backend" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "azure.backend.internal"
  type    = "A"
  ttl     = 300
  records = ["10.0.3.10"]
}

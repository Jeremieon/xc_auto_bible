# --- instance/main.tf ---


resource "aws_security_group" "my_app_sg" {
  name        = format("%s-sg", var.instance_name)
  description = "Security group for ${var.instance_name} instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP (ping)
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-sec-gw", var.instance_name)
  }

}

resource "aws_security_group" "private_sg" {
  name        = format("%s-priv-sg", var.instance_name)
  description = "Security group for ${var.instance_name} instances"
  vpc_id      = var.vpc_id


  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.my_app_sg.id] #only instances in the public SG can talk to the private instance on the allowed port.
  }
  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.my_app_sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = format("%s-priv-sec-gw", var.instance_name)
  }

}


resource "aws_key_pair" "my_laptop_key" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}


resource "aws_instance" "app_server" {
  ami                    = var.aws_ami
  instance_type          = var.instance_type
  subnet_id              = var.my_public_subnet_id
  count                  = var.instance_count
  key_name               = aws_key_pair.my_laptop_key.key_name
  user_data              = var.user_data_script
  vpc_security_group_ids = [aws_security_group.my_app_sg.id]
  tags = {
    Name = format("%s-instance", var.instance_name)
  }
}

resource "aws_instance" "private_app_server" {
  ami             = var.aws_ami
  instance_type   = var.instance_type
  subnet_id       = var.my_private_subnet_id
  count           = var.instance_count
  key_name        = aws_key_pair.my_laptop_key.key_name
  security_groups = [aws_security_group.private_sg.id]
  user_data       = var.user_data_script



  tags = {
    Name = format("%s-private-instance", var.instance_name)
  }
}

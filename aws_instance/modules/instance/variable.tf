# --- instance/variable.tf ---
variable "instance_name" {
  description = "name of Instances"
  type        = string
}

variable "instance_type" {
  description = "the type of instance to be created"
  type        = string
}

variable "key_name" {
  type    = string
  default = null
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "The ID of vpc to be attached"
  type        = string
}

variable "aws_ami" {
  description = "value"
  type        = string
  default     = "ami-0c398cb65a93047f2"
}


variable "user_data_script" {
  description = "User data script to be executed on instance launch"
  type        = string
  default     = ""
}

variable "my_public_subnet_id" {
  description = "The ID of the public subnet to launch the instance in"
  type        = string
}

variable "my_private_subnet_id" {
  description = "The ID of the private subnet to launch the instance in"
  type        = string
}


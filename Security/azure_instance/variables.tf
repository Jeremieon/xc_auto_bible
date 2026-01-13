variable "name" {
  type        = string
  description = "Base name for the resources"
}

variable "location" {
  type        = string
  description = "deployment location"
}

variable "organization" {
  type        = string
  description = "Terraform Cloud organization name"
}

variable "workspace" {
  type        = string
  description = "Terraform Cloud workspace name"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

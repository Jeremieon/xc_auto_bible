variable "tenant_name" {
  description = "REQUIRED: F5 Distributed Cloud tenant ID"
  type        = string
}

variable "namespace" {
  description = "REQUIRED: F5 Distributed Cloud namespace to deploy objects into"
  type        = string
  default     = "default"
}

variable "public_ip" {
  description = "Public IP from AWS instance"
  type        = string
}

variable "volterra_url" {
  description = "Volterra API URL"
  type        = string
  default     = "https://f5-emea-ent.console.ves.volterra.io/api"
}
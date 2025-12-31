variable "api_p12" {
  description = "Base64 encoded content of the .p12 file"
  type        = string
  sensitive   = true
  default = ""
}

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
  description = "IP address passed from the AWS job"
  type        = string
  default     = "default"
}



variable "xc_api_url" {
  description = "XC API URL"
  type        = string
  default     = "https://f5-emea-ent.console.ves.volterra.io/api"
}

variable "namespace" {
  description = "XC deployment namespace"
  type        = string
  default     = "system"
}

variable "domain" {
  description = "Loadbalancer domain"
  type        = string
}


variable "public_ip" {
  description = "Public IP of the backend server"
  type        = string
  default     = "0.0.0.0"
}

variable "port" {
  description = "origin server port"
  type        = number
  default     = 8000
}

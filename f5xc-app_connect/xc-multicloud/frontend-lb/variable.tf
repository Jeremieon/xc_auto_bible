variable "api_p12_file" {
  description = "Path to XC API certificate"
  type        = string
  default     = "./api-creds.p12"
}

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


variable "inside_network_IP" {
  description = "Inside network IP where the backend server is located for origin pool"
  type        = string
}

variable "site_name" {
  description = "F5XC site name where the backend server is located"
  type        = string
}

variable "site_adv_network" {
  description = "Network type to be used on site"
  type        = string
  default     = "SITE_NETWORK_OUTSIDE"
}

variable "port" {
  description = "origin server port"
  type        = number
}

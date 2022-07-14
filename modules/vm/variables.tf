variable "name" {
  type = string
}

variable "memory" {
  type = string
}

variable "cpus" {
  type = string
}

variable "cpu_cores" {
  type = string
}

varible "ignition" {
  type      = string
  sensitive = true
  default   = ""
}

variable "ip_address" {
  type = string
}

variable "default_gateway" {
  type = string
}

variable "subnet" {

  type = string
}

variable "dns_addresses" {
  type = list(string)
}


variable "disk_size_in_mb" {
  type    = number
  default = 131072
}

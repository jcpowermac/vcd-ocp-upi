variable "vcd_user" {
  type    = string
}

variable "vcd_pass" {
  type    = string
}

variable "vcd_org" {
  type    = string
}

variable "vcd_url" {
  type    = string
}

variable "vcd_vdc" {
  type    = string
}

variable "openshift_installer_path" {
  type = string
  default = "./openshift-install"
}

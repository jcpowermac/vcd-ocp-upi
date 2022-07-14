terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
    }
  }
  required_version = ">= 0.13"
}

locals {
  description = "Created By OpenShift Installer"
}

provider "vcd" {
  user      = var.vcd_user
  password  = var.vcd_pass
  auth_type = "integrated"
  org       = var.vcd_org
  vdc       = var.vcd_vdc
  url       = var.vcd_url
}

data "external" "openshift-coreos" {
  program = [var.openshift_installer_path, "coreos print-stream-json"]
}

data "vcd_org" "org" {
  name = var.vcd_org
}

data "vcd_storage_profile" "sp1" {
  org  = data.vcd_org.org.name
  vdc  = var.vcd_vdc
  name = "Standard"
}

resource "vcd_catalog" "openshift" {
  org = data.vcd_org.org.name

  name               = "openshift"
  description        = local.description
  storage_profile_id = data.vcd_storage_profile.sp1.id
  delete_recursive   = "true"
  delete_force       = "true"
}

resource "vcd_catalog_item" "rhcos-ova" {
  org     = data.vcd_org.org.name
  catalog = vcd_catalog.openshift.name

  name = "rhcos-ova"

  description          = "rhcos"
  ova_path             = "rhcos.ova"
  upload_piece_size    = 5
  show_upload_progress = "true"
}

resource "vcd_catalog_media" "rhcos-iso" {
  org     = data.vcd_org.org.name
  catalog = vcd_catalog.openshift.name

  name = "bootstrap-rhcos-iso"

  description          = "bootsrap rhcos iso"
  media_path             = "rhcos.iso"
  upload_piece_size    = 5
  show_upload_progress = "true"
}

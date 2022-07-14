resource "vcd_vm" "vm" {
  name = var.name

  catalog_name  = "my-catalog"
  template_name = "photon-os"

  memory    = var.memory
  cpus      = var.cpus
  cpu_cores = var.cpu_cores

  guest_properties = {
    "guestinfo.ignition.config.data"           = base64encode(var.ignition)
    "guestinfo.ignition.config.data.encoding"  = "base64"
    "guestinfo.afterburn.initrd.network-kargs" = "ip=${var.ip_address}::${var.default_gateway}:${var.subnet}:${var.name}:ens192:none:${join(":", var.dns_addresses)}"
  }

  network {
    type               = "org"
    name               = vcd_vapp_org_network.direct-net.org_network_name
    ip_allocation_mode = "MANUAL"
    is_primary         = true
  }

  override_template_disk {
    bus_type        = "paravirtual"
    size_in_mb      = var.disk_size_in_mb
    bus_number      = 0
    unit_number     = 0
    iops            = 0
    storage_profile = "*"
  }


}

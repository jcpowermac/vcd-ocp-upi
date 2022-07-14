resource "local_file" "foo" {
  content = templatefile("knot.bu.tftpl", {
    domain                = var.domain,
    acl_ip_address        = var.acl_ip_address,
    dns_server_ip_address = var.dns_server_ip_address
    }
  )
  filename = "${path.module}/knot.bu"

  provisioner "local-exec" {
    command = "podman run -i --rm quay.io/coreos/butane:release --pretty --strict < knot.bu > transpiled_config.ign"
  }
  provisioner "local-exec" {
    command = "podman run  --rm -i quay.io/coreos/ignition-validate:release - < transpiled_config.ign"
  }
}



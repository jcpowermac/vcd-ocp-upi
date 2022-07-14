
output "ignition" {
value = file("${path.module}/transpiled_config.ign")
}


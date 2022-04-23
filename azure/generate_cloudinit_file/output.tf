

output "cloudinit" {
  value = data.template_cloudinit_config.config.rendered
}

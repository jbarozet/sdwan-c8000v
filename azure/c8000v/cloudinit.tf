# Create cloud-init config file for C8kv

data "template_file" "cloudconfig" {
  template = file("./cloud_init/cloud-config")

  vars = {
    uuid         = var.uuid
    organization = var.organization
    token        = var.token
    vbond_ip     = var.vbond_ip
  }
}

data "template_file" "cloudboothook" {
  template = file("./cloud_init/cloud-boothook")

  vars = {
    uuid         = var.uuid
    system_ip    = var.system_ip
    site_id      = var.site_id
    organization = var.organization
    vbond_ip     = var.vbond_ip
    ntp_server   = var.ntp_server

  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudconfig.rendered
  }

  part {
    content_type = "text/cloud-boothook"
    content      = data.template_file.cloudboothook.rendered
  }

}

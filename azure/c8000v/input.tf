variable "name" {}

variable "region" {}

variable "rg" {}

variable "subnet_transport" {}
variable "subnet_service" {}

variable "instance_sku" {}
variable "instance_size" {}

variable "organization" {}
variable "site_id" {}
variable "system_ip" {}
variable "vbond_ip" {}
variable "uuid" {}
variable "token" {}
variable "username" {}
variable "password" {}
variable "ntp_server" {}

data "terraform_remote_state" "spam" {
  backend = "local"

  config = {
    path = "../vnet/terraform.tfstate"
  }
}

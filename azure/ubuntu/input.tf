variable "name" {}
variable "rg" {}
variable "region" {}


data "terraform_remote_state" "spam" {
  backend = "local"

  config = {
    path = "../vnet/terraform.tfstate"
  }
}

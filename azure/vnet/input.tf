variable "vnet_name" {}
variable "region" {}
variable "rg" {}
variable "vnet_address_space" { default = ["10.0.0.0/16"] }
variable "subnet_name" {}
variable "transport_subnet_prefix" { default = ["10.0.1.0/24"] }
variable "service_subnet_prefix" { default = ["10.0.2.0/24"] }

# Create Resource Group

resource "azurerm_resource_group" "my_rg" {
  name     = var.rg
  location = var.region

  tags = {
    Environment = "SDWAN Terraform Demo"
    Team        = "SDWAN TME"
  }
}

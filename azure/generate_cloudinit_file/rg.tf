# Create Resource Group

resource "azurerm_resource_group" "rg_c8000v" {
  name     = var.rg
  location = var.region

  tags = {
    Environment = "SDWAN Terraform Demo"
    Team        = "SDWAN TME"
  }
}

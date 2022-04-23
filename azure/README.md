# Instantiate C8000v on Azure

This script is used to quickly setup C8000v with Terraform on Azure for testing or learning purpose.

## Azure

Login to Azure
`$ az login`

To list all C8000v images:
`az vm image list --all -l westeurope  -p cisco -f cisco-c8000v -o table`

You have to accept the legal terms on this subscription before being able to deploy:
`$ az vm image terms accept --urn cisco:cisco-c8000v:17_07_01a-byol:latest`

You can set your ARM credentials in your environment. See below:
```
export TF_VAR_ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export TF_VAR_ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export TF_VAR_ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export TF_VAR_ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

## Create VNET

Deploy Azure VNET for Cisco SD-WAN C8000v. Edit vnet/variables.auto.tfvars.json with your VNET Name, region, Resource Group Name, subnet-name and VNET cidr_block.

Example:
```
{
    "vnet_name": "my-vnet",
    "region": "westeurope",
    "rg": "my-rg",
    "subnet_name": "my-subnet"
}
```

With vnet as your current working directory, run terraform.
```
$ terraform init
$ terraform plan
$ terraform apply
```

## Create c8000v in that VNET

Deploy C8000v into VNET. Edit c8000v/variables.auto.tfvars.json with appropriate settings.

Terraform deployment.
```
$ terraform init
$ terraform plan
$ terraform apply
```


## Termination

To terminate instances, go to the c8000 directory and run:
```
$ terraform destroy --auto-approve
```

To destroy the empty VNET, go to the vnet directory and run:
```
$ terraform destroy --auto-approve
```


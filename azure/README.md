# Instantiate C8000v on Azure

This script is used to quickly setup C8000v with Terraform on Azure for testing or learning purpose.

Login to Azure
`$ az login`

To list all C8000v images:
`az vm image list --all -l westeurope  -p cisco -f cisco-c8000v -o table`

You have to accept the legal terms on this subscription before being able to deploy:
`$ az vm image terms accept --urn cisco:cisco-c8000v:17_07_01a-byol:latest`

variables.auto.tfvars.json file and define the variables.

Step1 - Create vnet
Step2 - Create c8000v in that vnet

Terraform deployment.
```
$ terraform init
$ terraform plan
$ terraform apply
```

When lab is finished:
`$ terraform destroy --auto-approve`


# Quick start steps

## Getting the environment ready

  - From Duplo, open the EKS shell
  - In the Duplo EKS shell:
    - Get the code: `git clone https://github.com/duplocloud/duplo-labs-handson-20210527.git`
    - Change to the project diretory: `cd duplo-labs-handson-20210527`
    - Validate your setup:  `./check.sh`

## Running a Terraform project

  - In the Duplo EKS shell:
    - Change to the `simple-app` subdirectory of the project: `cd simple-app`
    - Initialize terraform: `terraform init`
    - Plan: `terraform plan`
    - Deploy: `terraform apply`

#!/bin/bash

# Generate keys
mkdir ./keyfiles
ssh-keygen -t rsa -b 4096 -a 100 -f ./keyfiles/myKeyfile

# Provision AMI
terraform init

terraform apply

# Exit

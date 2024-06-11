# MinecraftServer
Scripts for provisioning, setting up, and starting a Minecraft server using AWS CLI and Terraform. 

## Requirements
### Terraform
Visit https://developer.hashicorp.com/terraform/install to choose appropriate the package and install Terraform for your platform. Version 1.8.5
### AWS CLI
Visit https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html to install AWS CLI for your platform. Version 2.16.4
## Overview of scripts and terraform config
### server_provision.tf
This is Terraform file that defines a us-west-2 EC2 instance with Linux 2 AMI (x86) as the OS image. It creates a security group that allows ssh and Minecraft conncetions for the server. Remotely provisions the AMI with 'remote_script.sh' using remote_exec.
### setup_script.sh
  This is a shell script to run on the local machine that create a key pair for the AMI names myKeyfile and stores them in a new directory called keyfiles. The script then runs terraform init and terraform apply to initialize and create the instance.
### remote_script.sh
  This is a shell script to run on the AMI that installs java 21, installs the latest Minecraft Server pkg (v1.20.6), signs the EULA, then creates a systemd service to start the Minecraft server if/when resources restart.

## Steps to build and connect
  ### 1. Check required software
  - Ensure Terraform and AWS CLI are installed. To check, open a terminal/shell and enter `aws --version` and `terraform --version`. If you see version outputs for both commands, continue to the next step. If you get 'unknown command errors' review the documentation linked in the Requirements section.
  ### 2. Configure AWS credentials
  - To retrieve and set your AWS CLI short term credentials, visit and follow the steps outline from Amazon here: https://docs.aws.amazon.com/cli/v1/userguide/cli-authentication-short-term.html
  ### 3. Create AMI
  1. Create a new directory and place the contents of this repository in it.
  2. `cd` into the new directory
  3. Enter and execute `./setup_script.sh`. Enter a passphrase for your keyfile (hit enter twice for no passphrase).
  4. A prompt will come up asking to confirm your Terraform configuration. Type 'yes' and hit enter to continue.
  5. That's it! It will take a few minutes for the instance to finish building and for the remote initialization script to finish.
  6. Note the public IP of your instance.
  ### 4. Connect to the server
  - Open your Minecraft client and make sure you are using version 1.20.6 (the same version as the server).
  - Go to 'Multiplayer'
  - Click 'Direct Connection' and paste the public IP notes from the previous step.
## Resources
### Terraform configuration
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
- https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec
### AWS
- https://aws.amazon.com/blogs/gametech/setting-up-a-minecraft-java-server-on-amazon-ec2/
### Systemd service creation
- https://www.suse.com/support/kb/doc/?id=000019672


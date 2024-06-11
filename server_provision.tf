terraform {
    required_providers {
            aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-west-2"
}

resource "aws_security_group" "Minecraft_Security_Group" {
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    # for ssh connections
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    # for minecraft connections
    ingress {
        from_port       = 25565
        to_port         = 25565
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "keyfile" {
    key_name   = "minecraftKey"
    public_key = file("./keyfiles/myKeyfile.pub") 
}

resource "aws_instance" "app_server" {
    key_name        = "minecraftKey"
    ami             = "ami-0eb9d67c52f5c80e5" 
    instance_type   = "t2.small"
    vpc_security_group_ids = [aws_security_group.Minecraft_Security_Group.id]

    tags = {
        Name = "MinecraftServerInstance"
    }

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./keyfiles/myKeyfile")
        host        = self.public_ip
    }

    provisioner "file" {
        source      = "remote_script.sh"
        destination = "/tmp/remote_script.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/remote_script.sh",     
            "sudo /tmp/remote_script.sh",
        ]
    }    
}

output "instance_public_ip" {
    description = "Public IP address of the Minecraft Server"
    value       = aws_instance.app_server.public_ip
}

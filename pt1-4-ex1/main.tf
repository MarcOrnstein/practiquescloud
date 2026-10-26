###############################################################################
# Exercici 1 - Desplegament de 2 instancies EC2 amb Terraform
# Alumne: Marc Hernandez Dominguez
# Modul: Cloud Computing (ASIX2)
#
# Regio:      us-east-1
# Instancies: 2 x t3.micro
# SO:         Amazon Linux 2023 (AMI mes recent, obtinguda amb un bloc data)
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

###############################################################################
# AMI: cerca la versio mes recent d'Amazon Linux 2023 (x86_64)
###############################################################################
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

###############################################################################
# 2 instancies EC2 t3.micro
###############################################################################
resource "aws_instance" "web" {
  count = 2

  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  tags = {
    Name    = "practiquescloud-ex1-instance-${count.index + 1}"
    Project = "practiquescloud"
    Module  = "pt1-4-ex1"
  }
}

###############################################################################
# Outputs
###############################################################################
output "instance_ids" {
  description = "IDs de les 2 instancies EC2"
  value       = aws_instance.web[*].id
}

output "public_ips" {
  description = "IPs publiques de les 2 instancies EC2"
  value       = aws_instance.web[*].public_ip
}

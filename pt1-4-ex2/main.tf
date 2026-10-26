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

# --- VPC Personalitzada ---
resource "aws_vpc" "ex2_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "practiquescloud-ex2-vpc"
    Project = "practiquescloud"
    Module  = "pt1-4-ex2"
  }
}

# --- 3 Subxarxes en us-east-1a ---
# Subnet 1: 10.0.1.0/24
resource "aws_subnet" "ex2_subnet1" {
  vpc_id                  = aws_vpc.ex2_vpc.id
  cidr_block              = var.subnet_cidrs[0]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "practiquescloud-ex2-subnet1"
    Project = "practiquescloud"
    Module  = "pt1-4-ex2"
  }
}

# Subnet 2: 10.0.2.0/24
resource "aws_subnet" "ex2_subnet2" {
  vpc_id                  = aws_vpc.ex2_vpc.id
  cidr_block              = var.subnet_cidrs[1]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "practiquescloud-ex2-subnet2"
    Project = "practiquescloud"
    Module  = "pt1-4-ex2"
  }
}

# Subnet 3: 10.0.3.0/24
resource "aws_subnet" "ex2_subnet3" {
  vpc_id                  = aws_vpc.ex2_vpc.id
  cidr_block              = var.subnet_cidrs[2]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "practiquescloud-ex2-subnet3"
    Project = "practiquescloud"
    Module  = "pt1-4-ex2"
  }
}

# --- 6 Instàncies EC2 (2 per subxarxa) ---
# Subnet 1: 2 instàncies
resource "aws_instance" "ex2_subnet1_instances" {
  count = 2

  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  subnet_id       = aws_subnet.ex2_subnet1.id
  associate_with_default_associate_public_ip_address = true

  tags = {
    Name = "practiquescloud-ex2-subnet1-instance-${count.index + 1}"
    Project = "practiquescloud"
    Module  = "pt1-4-ex2"
    Subnet  = "ex2_subnet1"
  }
}

# Subnet 2: 2 instàncies
resource "aws_instance" "ex2_subnet2_instances" {
  count = 2

  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  subnet_id       = aws_subnet.ex2_subnet2.id
  associate_with_default_associate_public_ip_address = true

  tags = {
    Name = "practiquescloud-ex2-subnet2-instance-${count.index + 1}"
    Project = "practiquescloud"
    Module  = "pt1-4-ex2"
    Subnet  = "ex2_subnet2"
  }
}

# Subnet 3: 2 instàncies
resource "aws_instance" "ex2_subnet3_instances" {
  count = 2

  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"

  subnet_id       = aws_subnet.ex2_subnet3.id
  associate_with_default_associate_public_ip_address = true

  tags = {
    Name = "practiquescloud-ex2-subnet3-instance-${count.index + 1}"
    Project = "practiquescloud"
    Module  = "pt1-4-ex2"
    Subnet  = "ex2_subnet3"
  }
}

# --- Dades AMI ---
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

# --- Sortides ---
output "vpc_id" {
  description = "ID de la VPC personalitzada"
  value       = aws_vpc.ex2_vpc.id
}

output "subnet_ids" {
  description = "IDs de les 3 subxarxes"
  value       = [aws_subnet.ex2_subnet1.id, aws_subnet.ex2_subnet2.id, aws_subnet.ex2_subnet3.id]
}

output "instance_ids" {
  description = "IDs de les 6 instàncies EC2"
  value       = [
    aws_instance.ex2_subnet1_instances[*].id,
    aws_instance.ex2_subnet2_instances[*].id,
    aws_instance.ex2_subnet3_instances[*].id
  ]
}
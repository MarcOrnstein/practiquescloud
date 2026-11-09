# =============================================================================
# Configuració principal de Terraform i del proveïdor d'AWS
# =============================================================================
# Aquest és el fitxer d'entrada del projecte. Configurem la versió de Terraform,
# el proveïdor oficial d'AWS (Hashicorp) i la regió on es desplegarà tota la
# infraestructura de la pràctica.
#
# La resta de recursos estan separats per responsabilitats:
#   - vpc.tf       → xarxa (VPC, subxarxes, IGW i taula de rutes)
#   - security.tf  → Security Group i regles
#   - ec2.tf       → AMI i instàncies EC2
#   - outputs.tf   → sortides del desplegament
# =============================================================================

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

  # Etiquetes comunes a tots els recursos creats per aquest mòdul.
  # Així evitem repetir-les a cada recurs i facilitem el seguiment de costos.
  default_tags {
    tags = {
      Project = "practiquescloud"
      Module  = "pt2-2"
    }
  }
}

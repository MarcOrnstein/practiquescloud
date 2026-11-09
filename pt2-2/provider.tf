# =============================================================================
# Proveïdor d'AWS
# =============================================================================
# Configurem Terraform per treballar amb el proveïdor oficial d'AWS (Hashicorp)
# i fixem la regió on es desplegarà tota la infraestructura de la pràctica.
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

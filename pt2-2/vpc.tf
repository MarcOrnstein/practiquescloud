# =============================================================================
# Xarxa: VPC, subxarxes públiques, Internet Gateway i taula de rutes
# =============================================================================
# Arquitectura desplegada:
#
#   VPC-03 (10.0.0.0/16)
#   ├── Public Subnet A (10.0.1.0/24) — us-east-1a
#   ├── Public Subnet B (10.0.2.0/24) — us-east-1b
#   ├── Internet Gateway (VPC-03-IGW)
#   └── Taula de rutes pública (0.0.0.0/0 -> IGW)
# =============================================================================

# --- VPC principal -----------------------------------------------------------
resource "aws_vpc" "vpc03" {
  cidr_block = "10.0.0.0/16"

  # Habilitem DNS perquè les instàncies puguin resoldre noms interns i externs.
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-03"
  }
}

# --- Subxarxa pública A (us-east-1a) ----------------------------------------
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.vpc03.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  # Cada instància llançada aquí rep automàticament una IP pública.
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet A"
  }
}

# --- Subxarxa pública B (us-east-1b) ----------------------------------------
resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.vpc03.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet B"
  }
}

# --- Internet Gateway --------------------------------------------------------
# Permet la comunicació entre la VPC i Internet.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc03.id

  tags = {
    Name = "VPC-03-IGW"
  }
}

# --- Taula de rutes pública --------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc03.id

  # Ruta per defecte: tot el tràfic desconegut surt cap a Internet.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "VPC-03-Public-RT"
  }
}

# --- Associacions de la taula de rutes amb les subxarxes --------------------
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

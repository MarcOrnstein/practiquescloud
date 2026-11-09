# =============================================================================
# Seguretat: Security Group de les instàncies EC2
# =============================================================================
# Regles configurades:
#   - Ingress TCP 22 (SSH) des de qualsevol lloc (0.0.0.0/0).
#   - Ingress ICMP (ping) només des de dins de la VPC (10.0.0.0/16).
#   - Egress total cap a qualsevol destí.
#
# Nota: els Security Groups són "stateful", per tant el tràfic de resposta
# (per exemple, l'ICMP echo reply) es permet automàticament.
# =============================================================================

resource "aws_security_group" "vpc03_sg" {
  name        = "VPC-03-SG"
  description = "SSH des de qualsevol lloc, ICMP des de la VPC i egress total"
  vpc_id      = aws_vpc.vpc03.id

  # --- SSH (port 22) des de qualsevol adreça IPv4 ---------------------------
  ingress {
    description = "SSH des de qualsevol lloc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # --- ICMP (ping) restringit a l'interior de la VPC ------------------------
  # protocol "icmp" amb from_port/to_port = -1 permet tots els tipus d'ICMP.
  # Si només es volgués permitir l'echo request, s'usaria from_port = 8 i
  # to_port = 0.
  ingress {
    description = "ICMP ping nomes des de dins de la VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.vpc03.cidr_block]
  }

  # --- Tot el tràfic de sortida ---------------------------------------------
  egress {
    description = "Tot el trafic de sortida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-03-SG"
  }
}

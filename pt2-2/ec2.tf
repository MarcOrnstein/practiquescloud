# =============================================================================
# Còmput: 2 instàncies EC2 (ec2-a i ec2-b)
# =============================================================================
# Les dues instàncies utilitzen:
#   - Amazon Linux 2023 (última AMI disponible, obtinguda amb un data source).
#   - Tipus t3.micro.
#   - El par de claus "vockey" (disponible als laboratoris d'AWS Academy).
#   - El Security Group definit a security.tf.
# =============================================================================

# --- Cerca de la última AMI d'Amazon Linux 2023 -----------------------------
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

# --- Instància ec2-a (Public Subnet A) --------------------------------------
resource "aws_instance" "ec2_a" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  key_name      = "vockey"

  subnet_id = aws_subnet.public_a.id

  # Assignem explícitament una IP pública (també està activat a la subxarxa).
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.vpc03_sg.id]

  tags = {
    Name = "ec2-a"
  }
}

# --- Instància ec2-b (Public Subnet B) --------------------------------------
resource "aws_instance" "ec2_b" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  key_name      = "vockey"

  subnet_id = aws_subnet.public_b.id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.vpc03_sg.id]

  tags = {
    Name = "ec2-b"
  }
}

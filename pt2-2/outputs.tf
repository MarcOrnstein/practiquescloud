# =============================================================================
# Sortides de Terraform
# =============================================================================
# Permeten consultar la informació més rellevant del desplegament amb:
#   terraform output
# =============================================================================

output "vpc_id" {
  description = "ID de la VPC-03"
  value       = aws_vpc.vpc03.id
}

output "public_subnet_ids" {
  description = "IDs de les subxarxes públiques A i B"
  value = {
    public_subnet_a = aws_subnet.public_a.id
    public_subnet_b = aws_subnet.public_b.id
  }
}

output "instance_ids" {
  description = "IDs de les instàncies EC2"
  value = {
    ec2_a = aws_instance.ec2_a.id
    ec2_b = aws_instance.ec2_b.id
  }
}

output "public_ips" {
  description = "IPs públiques de les instàncies EC2"
  value = {
    ec2_a = aws_instance.ec2_a.public_ip
    ec2_b = aws_instance.ec2_b.public_ip
  }
}

output "private_ips" {
  description = "IPs privades de les instàncies EC2"
  value = {
    ec2_a = aws_instance.ec2_a.private_ip
    ec2_b = aws_instance.ec2_b.private_ip
  }
}

output "ssh_commands" {
  description = "Comandes per connectar-se per SSH a cada instància"
  value = {
    ec2_a = "ssh -i vockey.pem ec2-user@${aws_instance.ec2_a.public_ip}"
    ec2_b = "ssh -i vockey.pem ec2-user@${aws_instance.ec2_b.public_ip}"
  }
}

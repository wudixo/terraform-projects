output "public_subnet_id" {
  value = aws_subnet.wudixo_public_subnet.id
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

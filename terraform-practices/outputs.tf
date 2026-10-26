output "ec2_public_ip" {
  value = aws_instance.my_instance.public_ip
}
output "ec2_public_dns" {
  value = aws_instance.my_instance.public_dns
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat.public_ip
}
output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}

output "rds_master_secret_arn" {
  value = aws_db_instance.mysql.master_user_secret[0].secret_arn
}


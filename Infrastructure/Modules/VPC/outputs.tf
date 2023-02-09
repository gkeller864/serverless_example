output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]
}

output "private_subnets" {
  value = [aws_subnet.private_subnets_server[0].id, aws_subnet.private_subnets_server[1].id]
}
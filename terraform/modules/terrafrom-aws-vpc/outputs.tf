output "public_subnets" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "igw_id" {
  value = aws_internet_gateway.gw.id
}

output "ngw_id" {
  value = aws_internet_gateway.gw.id
}

output "public_rt" {
  value = aws_route_table.public.id
}

output "private_rt" {
  value = aws_route_table.private.id
}

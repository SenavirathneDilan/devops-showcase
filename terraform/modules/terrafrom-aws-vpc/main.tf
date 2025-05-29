data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_id" "id" {
  byte_length = 10
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = element(var.public_subnets, count.index)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = element(var.private_subnets, count.index)

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_nat_gateway" "ngw" {
  subnet_id = aws_subnet.public[0].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "ngw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_network_acl" "acl" {
  vpc_id = aws_vpc.this.id
}

resource "aws_network_acl_rule" "r" {
  for_each = var.nacl_ingress_rules

  network_acl_id = aws_network_acl.acl.id

  rule_number = each.value.rule_number
  rule_action = each.value.rule_action
  egress      = each.value.egress
  protocol    = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_block  = each.value.cidr_block == "" ? var.cidr_block : each.value.cidr_block

}

resource "aws_security_group" "sg" {}

resource "aws_security_group_rule" "rule" {
  security_group_id = aws_security_group.sg.id
  for_each          = var.default_security_group_rules

  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_block
}


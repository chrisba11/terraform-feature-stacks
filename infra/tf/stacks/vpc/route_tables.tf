resource "aws_route_table" "to_internet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "${local.app_name_lower}-internet-rt"
  }
}

resource "aws_route_table" "to_nat_gw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${local.app_name_lower}-nat-rt"
  }
}

resource "aws_route_table_association" "nat" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.to_nat_gw.id
}

resource "aws_route_table_association" "internet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.to_internet.id
}

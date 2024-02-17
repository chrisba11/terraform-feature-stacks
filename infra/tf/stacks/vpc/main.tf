resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = local.app_name_lower
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}a"
  cidr_block        = var.private_subnet_cidr

  tags = {
    Name = "${local.app_name_lower}-private-subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.aws_region}a"
  cidr_block        = var.public_subnet_cidr

  tags = {
    Name = "${local.app_name_lower}-public-subnet"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.app_name_lower}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${local.app_name_lower}-nat-gw"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.app_name_lower}-igw"
  }
}

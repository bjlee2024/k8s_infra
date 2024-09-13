
resource "aws_vpc" "eks_network" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${var.region}-${var.name}-vpc"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  count = local.az_count

  vpc_id = aws_vpc.eks_network.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "${var.name}-private-${var.availability_zones[count.index]}-rt"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_network.id
  tags = {
    Name = "${var.name}-igw"
  }
}


resource "aws_eip" "nat" {
  count = local.az_count

  domain = "vpc"
  tags = {
    Name = "${var.name}-nat-${var.availability_zones[count.index]}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = local.az_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.name}-nat-${var.availability_zones[count.index]}"
  }
}

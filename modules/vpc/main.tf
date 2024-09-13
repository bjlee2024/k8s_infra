
resource "aws_vpc" "eks_network" {
  cidr_block = var.vpc_cidr_block

  # This is for some addons such like EFS CSI driver or Client VPN
  # I'm not sure on now if it should be put back to variables.tf
  # TODO : Check if this is needed
  enable_dns_support   = true
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
  depends_on = [aws_internet_gateway.eks_igw]

  count = local.az_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.name}-nat-${var.availability_zones[count.index]}"
  }
}

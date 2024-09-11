

locals {
  az_count = length(var.availability_zones)
}

resource "aws_subnet" "public" {
  count = local.az_count

  vpc_id            = aws_vpc.eks_network.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "${var.name}-public-${var.availability_zones[count.index]}"
    # "kubernetes.io/role/elb"         = "1"
    # "kubernetes.io/role/alb-ingress" = "1"
    "subnet-type" = "public"
  }

  # lifecycle {
  #   ignore_changes = [
  #     tags,
  #   ]
  # }
}

resource "aws_route_table_association" "public" {
  count          = local.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count = local.az_count

  vpc_id            = aws_vpc.eks_network.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    Name = "${var.name}-private-${var.availability_zones[count.index]}"
    # "kubernetes.io/role/elb"         = "1"
    # "kubernetes.io/role/alb-ingress" = "1"
    "subnet-type" = "private"
  }

  # lifecycle {
  #   ignore_changes = [
  #     tags,
  #   ]
  # }
}

resource "aws_route_table_association" "private" {
  count = local.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


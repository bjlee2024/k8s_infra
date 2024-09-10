
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_counts)

  private_subnet_cidrs = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 2, k)]
  public_subnet_cidrs  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 192)]

}

# Internet gateway
# resource "aws_internet_gateway" "vpc_network_gateway" {
#   vpc_id = module.vpc.vpc_id
#
#   tags = {
#     Name = "${var.name}-internet-gateway"
#   }
# }

# EIP for NAT gateway
resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  count  = var.az_counts

  tags = {
    Name = "${var.name}-eip-nat-gateway"
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "vpc-${var.name}"
  cidr = var.vpc_cidr_block

  azs             = local.azs
  private_subnets = local.private_subnet_cidrs
  public_subnets  = local.public_subnet_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  reuse_nat_ips       = true
  external_nat_ip_ids = [for eip in aws_eip.nat_gateway : eip.id]

  private_subnet_tags = {
    Name                              = "${var.name}-private"
    "kubernetes.io/role/internal-elb" = "1"
    "subnet-type"                     = "private"
  }

  public_subnet_tags = {
    Name                     = "${var.name}-public"
    "kubernetes.io/role/elb" = "1"
    "subnet-type"            = "public"
  }
}

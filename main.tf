
data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_counts)

  private_subnet_cidrs = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 2, k)]
  public_subnet_cidrs  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 192)]
}


module "vpc" {
  source = "./modules/vpc"

  name                 = var.name
  region               = var.region
  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = local.azs
  private_subnet_cidrs = local.private_subnet_cidrs
  public_subnet_cidrs  = local.public_subnet_cidrs
}

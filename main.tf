# This is the main entry point for the terraform configuration of poc-eks
# It will call the modules to create the VPC and EKS cluster
# It will also pass the required variables to the modules
# Created by byeongjin lee

data "aws_availability_zones" "available" {}

locals {
  # if no azs are provided, we will use the first az_count available zones
  azs = length(var.availability_zones) == 0 ? slice(data.aws_availability_zones.available.names, 0, var.az_count) : var.availability_zones

  # this will calculate the cidr blocks for the subnets based on the VPC cidr block and az counts
  # private subnets will have 256 addresses each
  # public subnets will have 16382 addresses each
  private_subnet_cidrs = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 2, k)]
  public_subnet_cidrs  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 192)]
}

module "vpc" {
  source               = "./modules/vpc"
  name                 = var.name
  region               = var.region
  env                  = var.env
  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = local.azs
  private_subnet_cidrs = local.private_subnet_cidrs
  public_subnet_cidrs  = local.public_subnet_cidrs
}

module "eks" {
  source             = "./modules/eks"
  name               = var.name
  region             = var.region
  env                = var.env
  eks_version        = var.eks_version
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_types     = var.instance_types
}

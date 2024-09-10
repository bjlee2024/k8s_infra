
# locals {
#   azs = slice(data.aws_availability_zones.available.names, 0, var.az_counts)
#
#   private_subnet_cidrs = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 2, k)]
#   public_subnet_cidrs  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 192)]
#
# }
#
# resource "aws_subnet" "public" {
#   count = var.az_counts
#
#   vpc_id            = module.vpc.vpc_id
#   availability_zone = local.azs[count.index]
#   cidr_block        = local.public_subnet_cidrs[count.index]
#
#   tags = {
#     Name = "${var.name}-public-${data.aws_availability_zones.available.names[count.index]}"
#     # "kubernetes.io/role/elb"         = "1"
#     # "kubernetes.io/role/alb-ingress" = "1"
#     "subnet-type" = "public"
#   }
#
#   lifecycle {
#     ignore_changes = [
#       tags,
#     ]
#   }
# }
#
#
# resource "aws_subnet" "private" {
#   count = var.az_counts
#
#   vpc_id            = module.vpc.vpc_id
#   availability_zone = local.azs[count.index]
#   cidr_block        = local.private_subnet_cidrs[count.index]
#
#   tags = {
#     Name = "${var.name}-private-${data.aws_availability_zones.available.names[count.index]}"
#     # "kubernetes.io/role/elb"         = "1"
#     # "kubernetes.io/role/alb-ingress" = "1"
#     "subnet-type" = "private"
#   }
#
#   lifecycle {
#     ignore_changes = [
#       tags,
#     ]
#   }
# }

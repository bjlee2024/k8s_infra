# we can see all outputs using out parameter of terraform command 

# if need, we can use the -json flag to get the output in JSON format
# check later....
output "region" {
  value = var.region
}

output "vpc_cidr_block" {
  value = var.vpc_cidr_block
}

output "count_for_availability_zones" {
  value = var.az_count
}

output "selected_availablity_zones" {
  value = local.azs
}

output "count_for_private_subnets" {
  value = length(module.vpc.private_subnet_ids)
}
output "count_for_public_subnets" {
  value = length(module.vpc.public_subnet_ids)
}

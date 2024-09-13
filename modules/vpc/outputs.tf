
# we can see all outputs using out parameter of terraform command 

# if need, we can use the -json flag to get the output in JSON format
# check later....

output "vpc_network_id" {
  value = aws_vpc.eks_network.id
}
output "private_subnet_id" {
  value = [for az, subnet in aws_subnet.private : subnet.id]
}
output "public_subnet_id" {
  value = [for az, subnet in aws_subnet.public : subnet.id]
}


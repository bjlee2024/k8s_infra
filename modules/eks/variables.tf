
variable "name" {
  type        = string
  default     = "eks-poc"
  description = "A name for this network stack."
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region where this stack will be deployed."
}

variable "env" {
  type        = string
  default     = "dev"
  description = "Environment of the cluster."
}

variable "eks_version" {
  type        = string
  default     = "1.30"
  description = "The version of EKS to use."
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.192.0/24", "10.0.193.0/24", "10.0.194.0/24"]
  description = "The CIDR blocks for the private subnets, default is 3 subnets in the VPC_CIDR_BLOCK whcich has 256 addresses each."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/18", "10.0.64.0/18", "10.0.128.0/18"]
  description = "The CIDR blocks for the public subnets, default is 3 subnets in the VPC_CIDR_BLOCK whcich has 16382 addresses each."
}

variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "The availability zones to create subnets in, should be input where calling this module"
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "The instance type for the EKS nodes."
}

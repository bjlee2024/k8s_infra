variable "name" {
  type        = string
  default     = "eks-poc"
  description = "A name for this stack."
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

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC."
}


variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "The availability zones to create subnets in"
}

variable "az_counts" {
  type        = number
  default     = 3
  description = "The Number of availability zones to create subnets in"
}

# for eks module
variable "eks_version" {
  type        = string
  default     = "1.30"
  description = "The version of EKS to use."
}
variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "The instance type for the EKS nodes."
}

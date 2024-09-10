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

variable "aws_profile" {
  type        = string
  default     = "poc"
  description = "profile name for credential"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC."
}

# variable "availability_zones" {
#   default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   description = "The availability zones to create subnets in"
# }

variable "az_counts" {
  default = 3
}


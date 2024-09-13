
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

variable "private_subnet_ids" {
  type        = list(string)
  description = "The private subnet IDs for the EKS nodes."
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "The instance type for the EKS nodes."
}

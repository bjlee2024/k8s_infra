
variable "eks_name" {
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

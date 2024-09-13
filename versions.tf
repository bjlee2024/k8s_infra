terraform {
  required_version = "~>1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.64.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.6.3"
    }

    local = {
      source  = "hashicorp/local"
      version = "~>2.5.2"
    }

    null = {
      source  = "hashicorp/null"
      version = "~>3.2.3"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.32.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~>2.15.0"
    }
  }
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 6"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "helm" {
  kubernetes = {
    host                   = module.aws_eks.cluster_eks.eks_properties.endpoint
    cluster_ca_certificate = base64decode(module.aws_eks.cluster_eks.eks_properties.certificate_authority.0.data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.aws_eks.cluster_eks.eks_properties.id]
      command     = "aws"
    }
  }
}
provider "kubernetes" {
 
    host                   = module.aws_eks.cluster_eks.eks_properties.endpoint
    cluster_ca_certificate = base64decode(module.aws_eks.cluster_eks.eks_properties.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.aws_eks.cluster_eks.eks_properties.id]
      command     = "aws"
    }

  }

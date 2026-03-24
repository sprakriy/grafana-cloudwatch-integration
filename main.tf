terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# The AWS Provider - Uses your ~/.aws/credentials
provider "aws" {
  region = "us-east-1"
}

# The Kubernetes Provider - Automatically finds your k3d config
provider "kubernetes" {
  config_path = "~/.kube/config"
  # Optional: specify the context if you have multiple clusters
  # config_context = "k3d-my-cluster"
}

# The Helm Provider - Uses the same config as Kubernetes
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
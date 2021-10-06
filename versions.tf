terraform {
  required_version = ">= 1.0.0"

  required_providers {
    github = {
      source = "integrations/github"
      version = ">= 4.16.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.11.3"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.3.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }

  }
}

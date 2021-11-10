terraform {
  required_version = ">= 1.0.0"

  required_providers {
    github = {
      source = "integrations/github"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
    flux = {
      source  = "fluxcd/flux"
    }
    tls = {
      source  = "hashicorp/tls"
    }

  }
}

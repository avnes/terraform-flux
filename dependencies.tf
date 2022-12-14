locals {
  cluster_config  = "~/.kube/${var.cluster_name}.config"
  repository_name = var.repository_name != null ? var.repository_name : "${var.cluster_name}-flux"
  known_hosts     = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="

  catalogue = {
    "apiVersion" = "source.toolkit.fluxcd.io/v1beta2"
    "kind"       = "GitRepository"
    "metadata" = {
      "name"      = "catalogue"
      "namespace" = "flux-system"
    }
    "spec" = {
      "interval" = "1m0s"
      "ref" = {
        "branch" = "${var.flux_catalogue_branch}"
      }
      "url" = "${var.flux_catalogue_repo_url}"
    }
  }

  sources = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta2"
    "kind"       = "Kustomization"
    "metadata" = {
      "name"      = "sources"
      "namespace" = "flux-system"
    }
    "spec" = {
      "interval" = "1m0s"
      "dependsOn" = [
        {
          "name" = "flux-system"
        }
      ]
      "sourceRef" = {
        "kind" = "GitRepository"
        "name" = "catalogue"
      }
      "path"       = "./sources"
      "prune"      = true
      "validation" = "client"
    }
  }

  infrastructure = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta2"
    "kind"       = "Kustomization"
    "metadata" = {
      "name"      = "infrastructure"
      "namespace" = "flux-system"
    }
    "spec" = {
      "interval" = "1m0s"
      "dependsOn" = [
        {
          "name" = "sources"
        }
      ]
      "sourceRef" = {
        "kind" = "GitRepository"
        "name" = "catalogue"
      }
      "path"       = "./clusters/${var.cluster_name}"
      "prune"      = true
      "validation" = "client"
    }
  }

}

locals {
  cluster_config  = "~/.kube/${var.cluster_name}.config"
  gitops_dir      = "gitops"
  repository_name = var.repository_name != null ? var.repository_name : "${var.cluster_name}-flux"
  known_hosts     = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="

  catalogue_git = {
    "apiVersion" = "source.toolkit.fluxcd.io/v1beta1"
    "kind"       = "GitRepository"
    "metadata" = {
      "name"      = "flux-catalogue-git"
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

  catalogue_resources = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta1"
    "kind"       = "Kustomization"
    "metadata" = {
      "name"      = "flux-catalogue-resources"
      "namespace" = "flux-system"
    }
    "spec" = {
      "interval" = "1m0s"
      "dependsOn" = [
        {
          "name" = "flux-catalogue-sources"
        }
      ]
      "sourceRef" = {
        "kind" = "GitRepository"
        "name" = "flux-catalogue-git"
      }
      "path"       = "./resources"
      "prune"      = true
      "validation" = "client"
    }
  }

  catalogue_sources = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta1"
    "kind"       = "Kustomization"
    "metadata" = {
      "name"      = "flux-catalogue-sources"
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
        "name" = "flux-catalogue-git"
      }
      "path"       = "./sources"
      "prune"      = true
      "validation" = "client"
    }
  }

  catalogue_products = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta1"
    "kind"       = "Kustomization"
    "metadata" = {
      "name"      = "flux-catalogue-products"
      "namespace" = "flux-system"
    }
    "spec" = {
      "interval" = "1m0s"
      "dependsOn" = [
        {
          "name" = "flux-catalogue-sources"
        }
      ]
      "sourceRef" = {
        "kind" = "GitRepository"
        "name" = "flux-catalogue-git"
      }
      "path"       = "./products"
      "prune"      = true
      "validation" = "client"
    }
  }

  catalogue_configuration = {
    "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta1"
    "kind"       = "Kustomization"
    "metadata" = {
      "name"      = "flux-catalogue-configuration"
      "namespace" = "flux-system"
    }
    "spec" = {
      "interval" = "1m0s"
      "dependsOn" = [
        {
          "name" = "flux-catalogue-products"
        }
      ]
      "sourceRef" = {
        "kind" = "GitRepository"
        "name" = "flux-catalogue-git"
      }
      "path"       = "./configuration"
      "prune"      = true
      "validation" = "client"
    }
  }

}

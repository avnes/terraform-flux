locals {
    cluster_config          = "~/.kube/${var.cluster_name}.config"
    gitops_dir              = "gitops"
    repository_name         = var.repository_name != null ? var.repository_name : "${var.cluster_name}-flux"
    known_hosts             = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="

    catalogue_git           = {
        "apiVersion" = "source.toolkit.fluxcd.io/v1beta1"
        "kind" = "GitRepository"
        "metadata" = {
            "name" = "flux-catalogue-git"
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

    catalogue_resources       = {
        "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta1"
        "kind" = "Kustomization"
        "metadata" = {
            "name" = "flux-catalogue-resources"
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
            "path" = "./resources"
            "prune" = true
            "validation" = "client"
        }
    }

    catalogue_sources       = {
        "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta1"
        "kind" = "Kustomization"
        "metadata" = {
            "name" = "flux-catalogue-sources"
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
            "path" = "./sources"
            "prune" = true
            "validation" = "client"
        }
    }

    catalogue_products       = {
        "apiVersion" = "kustomize.toolkit.fluxcd.io/v1beta1"
        "kind" = "Kustomization"
        "metadata" = {
            "name" = "flux-catalogue-products"
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
            "path" = "./products"
            "prune" = true
            "validation" = "client"
        }
    }

}

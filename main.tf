provider "kubernetes" {
  config_path = local.cluster_config
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

################################################################################
# Flux CD installation and sync                                                #
################################################################################

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "flux_install" "main" {
  target_path = "./"
}

data "flux_sync" "main" {
  target_path = "./"
  url         = "ssh://git@github.com/${var.github_owner}/${local.repository_name}.git"
  branch      = var.branch
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = local.known_hosts
  }
}

resource "github_repository" "main" {
  name                 = local.repository_name
  visibility           = var.repository_visibility
  vulnerability_alerts = var.vulnerability_alerts
  auto_init            = true
}

resource "github_branch_default" "main" {
  repository = github_repository.main.name
  branch     = var.branch
}

resource "github_repository_deploy_key" "main" {
  title      = var.cluster_name
  repository = github_repository.main.name
  key        = tls_private_key.main.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository = github_repository.main.name
  file       = data.flux_install.main.path
  content    = data.flux_install.main.content
  branch     = var.branch
}

resource "github_repository_file" "sync" {
  repository = github_repository.main.name
  file       = data.flux_sync.main.path
  content    = data.flux_sync.main.content
  branch     = var.branch
}

resource "github_repository_file" "kustomize" {
  repository = github_repository.main.name
  file       = data.flux_sync.main.kustomize_path
  content    = data.flux_sync.main.kustomize_content
  branch     = var.branch
}

################################################################################
# Additional Flux manifests                                                    #
################################################################################

resource "github_repository_file" "catalogue" {
  count      = var.use_flux_catalogue ? 1 : 0
  repository = github_repository.main.name
  branch     = var.branch
  file       = "catalogue.yaml"
  content    = jsonencode(local.catalogue)
}

resource "github_repository_file" "sources" {
  count      = var.use_flux_catalogue ? 1 : 0
  repository = github_repository.main.name
  branch     = var.branch
  file       = "sources.yaml"
  content    = jsonencode(local.sources)
}

resource "github_repository_file" "infrastructure" {
  count      = var.use_flux_catalogue ? 1 : 0
  repository = github_repository.main.name
  branch     = var.branch
  file       = "infrastructure.yaml"
  content    = jsonencode(local.infrastructure)
}

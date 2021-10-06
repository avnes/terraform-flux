variable "github_owner" {
  type        = string
  default     = null
  description = "GitHub owner"
}

variable "github_token" {
  type        = string
  default     = null
  description = "GitHub token"
}

variable "repository_name" {
  type        = string
  default     = null
  description = "GitHub repository name"
}

variable "repository_visibility" {
  type        = string
  default     = "private"
  description = "How visible is the GitHub repo?"
  validation {
    condition     = var.repository_visibility == "private" || var.repository_visibility == "public"
    error_message = "The repository_visibility value must be either private or public."
  }
}

variable "branch" {
  type        = string
  default     = "main"
  description = "GitHub repository branch name"
}

variable "cluster_name" {
  type        = string
  default     = null
  description = "Kubernetes cluster name"
}

variable "use_flux_catalogue" {
  type        = bool
  default     = true
  description = "Should we install more manifests through Flux from another Git repo?"
}

variable "flux_catalogue_repo_url" {
  type        = string
  default     = "https://github.com/avnes/flux-catalogue"
  description = "GitHub repository name"
}

variable "flux_catalogue_branch" {
  type        = string
  default     = "main"
  description = "GitHub repository branch name"
}

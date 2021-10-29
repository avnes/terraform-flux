# terraform-flux

This module is strictly following the official documentation at <https://registry.terraform.io/providers/fluxcd/flux/latest/docs/guides/github>

But in addition to installing Flux CD in a Kubernetes cluster, it will optionally also install
and configure your own Flux recources.

By default it will use the Flux manifests at <https://github.com/avnes/flux-catalogue>, but this can be overridden by pointing to another repository URL through variables.

## Requirements

### Install Terraform

```bash
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install -y terraform
```

### Define variables

Create a file called terraform.tfvars with content similar to this:

```hcl
cluster_name = "dragonstone"
```

If you want to use a remote backend to store the state, also create a file called backend.tf

More info about Terraform backends at <https://www.terraform.io/docs/language/settings/backends/>

```bash
cd terraform-flux
terraform init  # Or: terraform init -backend-config=/path-to/backend.tf
terraform apply # Or: terraform apply -var-file=/path-to/terraform.tfvars
```

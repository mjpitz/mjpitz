# Helm Infrastructure

This directory contains configurations for Kubernetes deployments managed through Helm charts and Helmfile. This infrastructure was previously managed by ArgoCD, then Terraform, and is now simplified with Helmfile for better ergonomics.

## Overview

Helmfile provides a declarative way to manage multiple Helm releases with a single configuration file. This directory uses Helmfile to define and deploy Kubernetes services, providing a cleaner alternative to managing individual `helm install/upgrade` commands.

## Directory Structure

- [cert-manager](cert-manager/) - TLS certificate management
- [external-dns](external-dns/) - DNS record management for Kubernetes resources
- [longhorn](longhorn/) - Distributed storage system for Kubernetes
- [scripts](scripts/) - Utility scripts for helm deployments
- [helmfile.yaml](helmfile.yaml) - Helmfile declaring all releases and their configuration

## Component Details

### Core Services

- **cert-manager**: Manages TLS certificates used by systems in the cluster
- **external-dns**: Automatically manages DNS records for ingress and service objects
- **longhorn**: Provides persistent storage for stateful workloads in the cluster

## Secret Management

Secrets are managed using 1Password, which provides a secure and recoverable way to store sensitive information. The `.env` file maps environment variables to 1Password secret references:

```shell
brew install 1password-cli
brew install helmfile
```

Then apply deployments using:

```shell
# From infra/helm/ directory:
op run --env-file="./.env" -- helmfile apply

# Or preview changes before applying:
op run --env-file="./.env" -- helmfile diff

# Or sync specific releases:
op run --env-file="./.env" -- helmfile -l name=cert-manager apply
```

If apply outputs a plan but doesn't apply changes, try running `op` with the `--no-masking` flag.

## Prerequisites

1. **Helmfile** - Install with `brew install helmfile` or from https://github.com/roboll/helmfile
2. **Helm** - Should already be installed
3. **1Password CLI** - For secret injection
4. **kubectl** - Should already be configured
5. **Kubeconfig** - Ensure your kubeconfig points to the mya-nyc cluster:
   ```shell
   doctl kubernetes cluster kubeconfig save mya-nyc
   ```

## Deployment

### Update Dependencies

Chart dependencies are defined in each wrapper chart's `Chart.yaml`. Update them with:

```shell
make infra/helm/deps
```

This runs `helm dep up` on each wrapper chart to fetch upstream chart dependencies.

### Preview Changes

Before applying, preview what will change:

```shell
op run --env-file="./.env" -- helmfile diff
```

This shows a diff of the current cluster state vs. the helmfile configuration.

### Apply Changes

Deploy or update all releases:

```shell
op run --env-file="./.env" -- helmfile apply
```

Or use `sync` (equivalent to `apply` but always updates):

```shell
op run --env-file="./.env" -- helmfile sync
```

### Deploy Specific Releases

Deploy only a subset using label selectors:

```shell
# Deploy only cert-manager
op run --env-file="./.env" -- helmfile -l name=cert-manager apply
```

## Release Configuration

All three releases are independent with no dependencies between them:

1. **cert-manager** - Issues and manages TLS certificates
2. **external-dns** - Syncs Kubernetes resources to DNS providers
3. **longhorn** - Provides persistent block storage for the cluster

## Management

This infrastructure is managed through:
- Helmfile for release declaration and orchestration
- Helm for Kubernetes resource templating
- 1Password for secret management
- Wrapper charts in each subdirectory for custom configuration

## Troubleshooting

### Checking Release Status

List all releases:
```shell
helm list -A
```

Get details on a specific release:
```shell
helm status -n cert-manager cert-manager
```

View release history:
```shell
helm history -n cert-manager cert-manager
```

### Rolling Back a Release

If a deployment goes wrong, rollback to the previous version:
```shell
helm rollback -n cert-manager cert-manager
```

### Manual Helm Commands

While using Helmfile is recommended, you can also use Helm directly if needed:

```shell
# Template a release to see generated manifests
helm template ./cert-manager --values ./cert-manager/values.yaml

# Upgrade a release manually
helm upgrade --install cert-manager ./cert-manager \
  --namespace cert-manager \
  --create-namespace \
  -f ./cert-manager/values.yaml \
  --set "cloudflare.apiToken=$CLOUDFLARE_API_TOKEN"
```

## Notes on Migration from Terraform

This configuration was previously managed by Terraform. Key differences:

- **State**: Terraform stored state in a remote S3 backend. Helmfile is stateless — Helm's internal release history is the source of truth.
- **Credentials**: Previously required `DIGITALOCEAN_ACCESS_TOKEN` for cluster access. Now requires kubeconfig setup (one-time: `doctl kubernetes cluster kubeconfig save mya-nyc`).
- **Secrets**: Terraform used `set_sensitive {}` blocks. Helmfile uses `set {}` with environment variable interpolation via `{{ requiredEnv "VAR_NAME" }}`.
- **Dependencies**: Terraform used `depends_on`. Helmfile uses `needs:`.
- **Hashing**: Terraform used `scripts/hash.sh` to force upgrades when files changed. Helmfile natively diffs state and doesn't need this.

All wrapper chart directories, values files, and templates remain unchanged.

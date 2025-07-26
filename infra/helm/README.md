# Helm Infrastructure

This directory contains configurations for Kubernetes deployments managed through Helm charts and Terraform. This infrastructure was previously managed by ArgoCD but has been simplified to reduce complexity.

## Overview

Helm charts provide a templating mechanism for Kubernetes resources, allowing for consistent deployment and management of services. This directory uses Terraform to manage the deployment of these Helm charts, providing infrastructure-as-code capabilities.

## Directory Structure

- [cert-manager](cert-manager/) - TLS certificate management
- [external-dns](external-dns/) - DNS record management for Kubernetes resources
- [ingress-nginx](ingress-nginx/) - Ingress controller for routing external traffic
- [longhorn](longhorn/) - Distributed storage system for Kubernetes
- [pages](pages/) - Deployment of the [pages](https://github.com/mjpitz/pages) application
- [registry](registry/) - Docker registry backed by S3 and Redis cache
- [renovate](renovate/) - Dependency update automation
- [scripts](scripts/) - Utility scripts for helm deployments

## Component Details

### Core Services

- **cert-manager**: Manages TLS certificates used by systems in the cluster
- **external-dns**: Automatically manages DNS records for ingress and service objects
- **ingress-nginx**: Provides general ingress routing into the cluster for communication

### Applications

- **pages**: Manages, monitors, and reports on static applications
- **registry**: Docker registry backed by S3 and an AP Redis cache cluster
- **renovate**: Keeps dependencies updated in private repositories

## Secret Management

Secrets are managed using 1Password, which provides a secure and recoverable way to store sensitive information:

```shell
brew install 1password-cli

op run --env-file="./.env" -- terraform plan
op run --env-file="./.env" -- terraform apply --auto-approve
```

If apply outputs a plan but doesn't apply changes, try running `op` with the `--no-masking` flag.

## Management

This infrastructure is managed through:
- Terraform for orchestration
- Helm for Kubernetes resource templating
- 1Password for secret management

## Getting Started

1. Install required tools:
   - Terraform
   - Helm
   - 1Password CLI
   - kubectl

2. Configure access to your Kubernetes cluster

3. Set up 1Password integration with the provided .env file

4. Use Terraform to plan and apply changes

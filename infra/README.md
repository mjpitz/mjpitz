# Infrastructure

This directory contains configurations and references for the various infrastructure components that I manage across different environments. The infrastructure is organized into three main categories, each with its own purpose and management approach.

## Directory Structure

- [Digital Ocean](do/) - Public cloud resources running in DigitalOcean
- [Helm](helm/) - Kubernetes deployments managed via Helm and Terraform
- [Lab](lab/) - Personal homelab infrastructure running on local hardware

## Components

### [Digital Ocean](do/)

Resources running in the DigitalOcean cloud platform:

- **Admin Resources**: Administrative configurations and management tooling
- **Personal Projects**: Resources for personal applications and services
- **Experience Notes**: Documentation on service quality and past incidents

### [Helm](helm/)

Kubernetes deployments managed via Helm charts and Terraform:

- **Core Services**: cert-manager, external-dns, ingress-nginx
- **Storage**: longhorn for persistent storage
- **Applications**: pages, registry, renovate, and more
- **Secret Management**: Integration with 1Password for secure credential management

### [Lab](lab/)

Personal homelab infrastructure running on local hardware:

- **Container Orchestration**: Managed via Docker Compose
- **Package Management**: Uses PNPM workspaces
- **Automation**: Tasks automated via Taskfile
- **Service Categories**:
  - Admin tools and services
  - Ingress networking configuration
  - Media-related services
  - Monitoring and metrics collection
- **Remote Sync**: Bidirectional synchronization with lab server

## Management Approaches

Each infrastructure component uses different management techniques:

- **Digital Ocean**: Managed via DigitalOcean console and configuration files
- **Kubernetes/Helm**: Terraform and Helm for declarative infrastructure
- **Homelab**: Docker Compose with Taskfile automation for simplified operations

## Getting Started

Refer to the README in each subdirectory for specific instructions on how to work with that particular infrastructure component.

# Lab Infrastructure

This directory contains configuration for a personal homelab infrastructure managed through Docker Compose, PNPM workspaces, 
and Taskfile automation. The lab environment is organized into modular components for admin, ingress, media, and metrics 
services.

<!-- 
Chain of Density Summaries are hidden in this comment.

```yaml
- missing_entities: [Docker Compose, PNPM workspaces, Taskfile, Remote synchronization, Service configuration]
  denser_summary: >-
    The infra/lab directory contains configuration for a homelab infrastructure using Docker Compose, with task 
    automation through Taskfile, and package management via PNPM workspaces. It has infrastructure for admin, 
    ingress, media, and metrics services.

- missing_entities: [rsync for remote sync, service start/stop order, Docker volumes, container networking, configuration structure]
  denser_summary: >-
    This homelab setup uses Docker Compose for containerization, Taskfile for automation, and PNPM workspaces
    for managing admin, ingress, media, and metrics services. It includes rsync-based remote synchronization
    with a lab server and implements specific startup procedures prioritizing ingress services.

- missing_entities: [resource allocation, homepage integration, persistent data storage, port configuration, restart policies]
  denser_summary: >-
    This modular homelab infrastructure uses Docker Compose, Taskfile automation, and PNPM workspaces to manage
    services across admin, ingress, media, and metrics domains. It synchronizes with a remote server via rsync,
    orchestrates service startup order, and provides persistent storage and homepage integration for services.

- missing_entities: [conventional naming standards, Docker labels, service accessibility, configuration versioning, dependency management]
  denser_summary: >-
    This homelab infrastructure employs Docker Compose with conventional naming standards, Taskfile for
    orchestration, and PNPM workspaces for modular service management across admin, ingress, media, and
    metrics domains. It features bidirectional rsync synchronization, prioritized service startup, persistent
    storage, port exposure, and homepage integration via Docker labels.

- missing_entities: [specific port mappings, code organization principles, remote IP address, excluded files during sync, task dependencies]
  denser_summary: >-
    This homelab infrastructure orchestrates containerized services via Docker Compose with standardized
    naming conventions, PNPM workspaces for modular organization, and Taskfile automation for bidirectional
    synchronization with a remote server (192.168.4.30), excluding node_modules. It manages service
    dependencies across admin, ingress, media, and metrics domains with specific startup sequencing,
    persistent storage, and homepage integration for deployed services.
```
-->

## Usage

The lab environment can be managed using the following Taskfile commands:

```bash
# Pull configuration from remote server
task pull

# Push configuration to remote server
task push

# Install dependencies
task install

# Prepare Docker environments
task prep

# Start services (ingress first, then others)
task start

# Stop services (others first, then ingress)
task stop
```

## Components

- **admin**: Administration tools and services
- **ingress**: Network ingress configuration (started first, stopped last)
- **media**: Media-related services
- **metrics**: Monitoring and metrics collection

## Docker Configuration

The environment uses Docker Compose with the following conventions:
- Networks use underscores in naming
- Volumes use underscores in naming
- Services use hyphens in naming

See `docker-compose.yaml` for specific service configurations.

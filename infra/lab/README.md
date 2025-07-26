# Lab Infrastructure

This directory contains configurations for my personal homelab infrastructure, managed through Docker Compose, PNPM workspaces, and Taskfile automation.

## Overview

The lab environment provides a modular, containerized infrastructure running on local hardware. It's designed for flexibility, ease of management, and reliable operation with minimal intervention.

## Directory Structure

- [admin](admin/) - Administration tools and services
- [ingress](ingress/) - Network ingress configuration
- [media](media/) - Media-related services
- [metrics](metrics/) - Monitoring and metrics collection
- [single-pain](single-pain/) - Additional service configuration

## Component Details

### Infrastructure Components

- **Docker Compose**: Used for container orchestration with standardized naming conventions:
  - Networks use underscores in naming
  - Volumes use underscores in naming
  - Services use hyphens in naming

- **PNPM Workspaces**: Package management for JavaScript/Node.js components

- **Taskfile**: Task automation for common operations

### Service Categories

- **Admin**: Tools for infrastructure management and administration
- **Ingress**: Network traffic management (started first, stopped last)
- **Media**: Services for media storage, streaming, and management
- **Metrics**: Monitoring, alerting, and observability tooling

## Management

The lab environment is managed using Taskfile commands that provide simplified automation:

```bash
# Remote Synchronization
task pull       # Pull configuration from remote server
task push       # Push configuration to remote server

# Setup and Installation
task install    # Install dependencies
task prep       # Prepare Docker environments

# Service Management
task start      # Start services (ingress first, then others)
task stop       # Stop services (others first, then ingress)
```

## Remote Synchronization

The configuration synchronizes bidirectionally with a remote lab server, allowing for centralized management while maintaining local copies.

## Getting Started

1. Review the `docker-compose.yaml` file for service configurations
2. Use the Taskfile commands to manage the environment
3. Remember the service startup order (ingress first, others after)
4. Reference the specific component directories for detailed configuration

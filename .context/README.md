# Repository Overview

This repository (`mjpitz/mjpitz`) serves as Mya's personal project collection, infrastructure configurations, and knowledge sharing platform. It contains various infrastructure components, Helm charts, Docker containers, monitoring configurations, site content, and technical papers.

## Directory Structure

### `charts/`

A collection of Helm charts primarily for personal use but made available to others. These charts are published and accessible via `helm repo add mya https://mya.sh`.

**Key Charts:**
- `12factor` - Easily deploy applications conforming to 12factor patterns
- `cognative` - Business intelligence and operations platform
- `drone` - CI/CD server with optional runners (digitalocean or kubernetes)
- `gitea` - Self-hosted Git service
- `litestream` - SQLite database replication sidecar for any workload
- `maddy` - Single-tenant email server
- `raw` - Raw Kubernetes resource deployment
- `redis` - Inconsistent Redis cluster (intended for Envoy sidecar)
- `redis-queue` - Single durable Redis instance for work queue usage
- `redis-raft` - Consistent, partition-tolerant Redis cluster with Raft
- `registry` - Replicated container registry with optional Redis caching
- `renovate` - Dependency management automation
- `storj` - S3 Gateway sidecar for any workload

**Build Processes:**
- Dependencies from multiple sources (mya.sh, minio, opentelemetry, grafana, etc.)
- Standardized workflows for dependency management, documentation, and linting
- MIT licensed content

**Usage Pattern:**
```shell
helm repo add mya https://mya.sh
helm install my-release mya/<chart-name>
```

### `docker/`

Custom Docker containers built and maintained primarily for personal use, each with specific configuration and usage patterns.

**Key Containers:**
- `drone-server` - Unrestricted Drone.IO server for personal CI/CD
- `presto` - Minimal PrestoDB deployment optimized for S3 backends
- `redis` - Canonical Redis image for in-memory data structures
- `redis-raft` - Redis with RAFT consensus instead of traditional replication
- `rspamd` - Email spam filtering, packaged as a sidecar for maddy
- `taky` - Open source TAK Server implementation in Python

**Container Structure:**
- Dockerfile for build instructions
- docker-entrypoint.sh for initialization
- Configuration files specific to each service
- Platform-specific setup scripts (alpine.sh, ubuntu.sh)
- image.conf containing license information

**License Note:**
Unlike other directories, docker containers have varied licensing based on their contents, specified in each image.conf file.

### `infra/`

Infrastructure configurations across different environments, representing Mya's multi-environment deployment approach.

#### `infra/do/` - Digital Ocean Cloud Resources

**Overview:**
- Public cloud resources in DigitalOcean
- History of generally good support, with note of a past data loss incident with their Kubernetes CSI driver

**Components:**
- `admin/` - Administrative configurations and management tooling
- `mya/` - Personal project assets and configurations

**Management:**
- Primarily through DigitalOcean's web interface
- Configuration files in repository
- API-based automation where applicable

#### `infra/helm/` - Kubernetes via Helm and Terraform

**Overview:**
- Previously managed by ArgoCD, simplified to reduce complexity
- Terraform orchestration of Helm deployments
- 1Password integration for secret management

**Core Services:**
- `cert-manager/` - TLS certificate management
- `external-dns/` - DNS record automation for Kubernetes resources
- `ingress-nginx/` - Ingress controller for external traffic routing
- `longhorn/` - Distributed storage system

**Applications:**
- `pages/` - Static application management and monitoring
- `registry/` - Docker registry with S3 backend and Redis cache
- `renovate/` - Dependency updates for private repositories
- `scripts/` - Utility scripts for Helm deployments

**Secret Management:**
Integration with 1Password for secure credential handling:
```shell
op run --env-file="./.env" -- terraform apply
```

#### `infra/lab/` - Personal Homelab

**Overview:**
- Modular, containerized infrastructure on local hardware
- Designed for flexibility and minimal-intervention operation

**Technology Stack:**
- Docker Compose with standardized naming conventions
  - Networks: underscores in naming
  - Volumes: underscores in naming
  - Services: hyphens in naming
- PNPM workspaces for JavaScript package management
- Taskfile for operational automation

**Service Categories:**
- `admin/` - Infrastructure management tools
- `ingress/` - Network traffic handling (started first, stopped last)
- `media/` - Media storage and streaming services
- `metrics/` - Monitoring and observability
- `single-pain/` - Additional service configuration

**Operations:**
Managed via Taskfile commands for consistency:
```bash
task pull/push     # Remote synchronization
task install/prep  # Setup and installation
task start/stop    # Service lifecycle management
```

### `monitoring/`

Monitoring configurations for observing infrastructure components, built with Jsonnet and organized by service type.

**Technology Stack:**
- **Grafonnet Library**: Jsonnet library for Grafana dashboards
  - Source: https://github.com/grafana/grafonnet-lib
- **Grafana Builder**: Helper library for building complex Grafana dashboards
  - Source: https://github.com/grafana/jsonnet-libs

**Service-Specific Monitoring:**
- `drone/` - CI/CD server monitoring
- `gitea/` - Git service monitoring
- `go/` - Golang process monitoring
- `grpc/` - gRPC service monitoring
- `ingress-nginx/` - Ingress controller monitoring
- `litestream/` - SQLite replication monitoring
- `maddy/` - Email server monitoring
- `redis/` - Redis monitoring
- `registry/` - Container registry monitoring

**Implementation:**
- Common alerts, dashboards, metrics, and rules
- Jsonnet-based templates for consistency
- Integration with Grafana and Prometheus
- Service catalog integration for centralized access

**Workflows:**
```shell
make monitoring/deps    # Install dependencies (jsonnet libraries)
make monitoring/format  # Format configuration files
make monitoring/lint    # Validate configurations
make monitoring/build   # Generate dashboards and alerts
make monitoring/sync    # Deploy to monitoring stack
```

**Licensing:**
MIT licensed content

### `papers/`

Technical papers and research documents on various topics authored by Mya. These papers are accessible via the website at https://mya.sh/papers/.

### `site/`

Personal website built with a modern static site generator, containing blog posts, documentation, and project information.

**Technology Stack:**
- **Astro v5.0.0**: Modern, performance-focused static site generator
- **MDX**: Markdown with JSX for rich content authoring
- **TypeScript**: Type-safe JavaScript
- **Tailwind CSS**: Utility-first CSS framework
- **Preact**: Lightweight React alternative for interactive components

**Features:**
- RSS feed generation
- Sitemap generation
- Embedded content support (via astro-embed)
- Code formatting with Prettier

**Content Types:**
- Blog posts (like "Git Turns 20")
- Helm chart documentation
- Technical papers
- Project documentation

**Development Workflow:**
```shell
npm run dev        # Start development server
npm run build      # Build for production
npm run preview    # Preview production build
npm run lint       # Check formatting
npm run format     # Apply formatting
```

**Build Technology:**
- Node.js based build system
- Configuration via astro.config.mjs
- Package management with npm
- TypeScript support (via @astrojs/check)

## Content Organization Patterns

### `.context/` Directory

Contains context information and prompt templates for LLMs working with this repository:

- `README.md` - This file, providing repository overview
- `prompts/` - Reusable prompt templates
  - `chain-of-density.md` - For blog post summarization and density improvement
- `diagrams/` - Mermaid diagrams providing visual context
  - `repository-structure.mmd` - Overall repository structure and organization
  - `cicd-workflow.mmd` - CI/CD processes for charts and website
  - `component-integration.mmd` - How repository components integrate with each other
  - `monitoring-architecture.mmd` - Monitoring system architecture and workflows
  - `infrastructure-architecture.mmd` - Infrastructure environments and components
  - `development-workflow.mmd` - Development workflows for different components

### Common Workflows

#### Helm Chart Development
1. Add dependencies: `make charts/sources`
2. Update dependencies: `make charts/deps`
3. Generate documentation: `make charts/docs`
4. Validate: `make charts/lint`

#### Infrastructure Management
- Digital Ocean: Web interface and configuration files
- Kubernetes/Helm: 
  1. Update dependencies: `make infra/helm/deps`
  2. Apply with Terraform: `op run --env-file="./.env" -- terraform apply`
- Homelab:
  1. Pull latest config: `task pull`
  2. Make changes
  3. Start services: `task start`
  4. Push updates: `task push`

#### Monitoring Updates
1. Install dependencies: `make monitoring/deps`
2. Make configuration changes
3. Format and lint: `make monitoring/format` and `make monitoring/lint`
4. Build and deploy: `make monitoring/build` and `make monitoring/sync`

#### Website Development
1. Install dependencies: `npm install` or `make site/deps`
2. Run development server: `npm run dev` or `make site/serve`
3. Make content changes
4. Format code: `npm run format`
5. Build for production: `npm run build` or `make site/build`

## Repository Conventions

- **Documentation:** README.md files in most directories
- **Licensing:** Primarily MIT, with Docker images having service-specific licensing
- **Build System:** Make-based with consistent target naming
- **Code Organization:** Modular approach with clear separation of concerns
- **Configuration Management:** Infrastructure as code with Terraform and declarative configurations
- **Package Naming:** Namespace under `@mjpitz` (e.g., `@mjpitz/site`)

## Integration Patterns

- **Monitoring ↔ Infrastructure:** Dashboards and alerts for deployed services
- **Charts ↔ Infrastructure:** Helm charts used by infrastructure deployments
- **Docker ↔ Charts:** Custom containers referenced in Helm deployments
- **Site ↔ Charts:** Documentation for charts published on the website
- **Technology Ecosystem:** Consistent use of modern tools across projects (TypeScript, Jsonnet, Terraform, etc.)

## CI/CD Workflows

The repository uses GitHub Actions for continuous integration and deployment, with workflows defined in the `.github/workflows/` directory:

### Charts CI/CD

- **charts-lint-and-test.yaml**: Triggered on pull requests that modify chart files
  - Runs chart-testing (ct) to lint Helm charts
  - Validates chart structure and configuration
  - Uses Helm, Python, and chart-testing tools
  - Currently has test installation commented out (TODO noted in file)

- **charts-publish.yaml**: Triggered on merges to main branch affecting chart files
  - Configures Git for publishing
  - Sets up GPG signing for chart releases
  - Uses chart-releaser to package and publish Helm charts
  - Uploads charts to GitHub Pages as a Helm repository
  - Makes charts available via the `mya.sh` domain

### Site Deployment

- **pages-build.yaml**: Triggered on pull requests and merges affecting site files
  - Builds the website using the site's build system
  - Runs tests to verify the build
  - When merged to main, deploys to GitHub Pages
  - Preserves chart repository files during deployment
  - Uses `peaceiris/actions-gh-pages` for GitHub Pages publishing

The CI/CD system follows a pattern of testing on pull requests and deploying on merges to main, ensuring quality while automating the release process for both Helm charts and the website.

## Technical Skills Required

Working with this repository effectively requires familiarity with:

1. **Container Technologies:**
   - Docker and Docker Compose
   - Kubernetes and Helm

2. **Infrastructure as Code:**
   - Terraform
   - YAML configuration

3. **Web Technologies:**
   - JavaScript/TypeScript
   - Astro framework
   - MDX content authoring

4. **Monitoring and Observability:**
   - Grafana and Prometheus
   - Jsonnet templating

5. **Development Tools:**
   - Git version control
   - Make-based build systems
   - Package managers (npm, PNPM)

## LLM Interaction Guidelines

When working with this repository as an LLM assistant, follow the guidelines specified in the `.clinerules/context.md` file. These rules establish best practices for:

1. **Context Acquisition:** Always read this README first to understand the repository structure and components
2. **Task Execution:** Follow established workflows for different repository components
3. **Tool Usage:** Ensure commands and file modifications align with repository conventions
4. **Handling Uncertainty:** Make informed decisions based on repository patterns

The rules ensure that LLM assistance is properly contextualized within the repository's organization and purpose, leading to more effective and consistent help.

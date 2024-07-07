# Helm

This directory contains various Helm deployment definitions. I used to have this managed by ArgoCD, but opted for a
deployment scheme with less infrastructure. Feel free to poke around, but I doubt you'll find anything of value.

- [cert-manager](cert-manager) - manages TLS certificates used by systems in the cluster
- [external-dns](external-dns) - manages DNS records for ingress and service objects in Kubernetes
- [gitea](gitea) - provides a version control system, backed by sqlite, and replicated with [litestream][]
- [ingress-nginx](ingress-nginx) - provides general ingress routing into the cluster for communication
- [maddy](maddy) - deploys a simple email server, backed by sqlite, and replicated with [litestream][]
- [pages](pages) - deploys the [pages](https://github.com/mjpitz/pages) application to manage, monitor, and report on static applications
- [registry](registry) - deploys a docker registry backed by S3 and an AP Redis cache cluster
- [renovate](renovate) - deploys renovate to stay on top of dependencies for my private repositories
- [woodpecker](woodpecker) - deploys a CI solution for our version control system

[litestream]: https://litestream.io

## Secret Management

Secret management is handled using one-password. All secret data is stored in a vault that I have access to, and it's
injected into the environment similar to how my old envy workflow used to work. The big improvement here is that now I
have a recovery path for when I change machines without needing to fuss around with kubernetes secrets.

```shell
brew install 1password-cli

op run --env-file="./.env" -- terraform plan
op run --env-file="./.env" -- terraform apply --auto-approve
```

In the event that apply outputs the plan, but does not apply changes, try running `op` with the `--no-masking` flag.

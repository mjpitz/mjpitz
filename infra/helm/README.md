# Helm

This directory contains various Helm deployment definitions. I used to have this managed by ArgoCD, but opted for a
deployment scheme with less infrastructure. Feel free to poke around, but I doubt you'll find anything of value.

- [cert-manager](cert-manager) - manages TLS certificates used by systems in the cluster
- [dist](dist) - provides an asset distribution system, backed by S3
- [external-dns](external-dns) - manages DNS records for ingress and service objects in Kubernetes
- [gitea](gitea) - provides a version control system, backed by sqlite, and replicated with [litestream][]
- [ingress-nginx](ingress-nginx) - provides general ingress routing into the cluster for communication
- [kube-prometheus-stack](kube-prometheus-stack) - deploys a minimal monitoring stack
- [maddy](maddy) - deploys a simple email server, backed by sqlite, and replicated with [litestream][]
- [pages](pages) - deploys the [pages](https://github.com/mjpitz/pages) application to manage, monitor, and report on static applications
- [registry](registry) - deploys a docker registry backed by S3 and an AP Redis cache cluster

## Secret Management

Secret management is handled using one-password. All secret data is stored in a vault that I have access to, and it's
injected into the environment similar to how my old envy workflow used to work. The big improvement here is that now I
have a recovery path for when I change machines without needing to fuss around with kubernetes secrets.

```shell
brew install 1password-cli

op run --env-file="./.env" -- terraform plan
op run --env-file="./.env" -- terraform apply --auto-approve
```

[litestream]: https://litestream.io

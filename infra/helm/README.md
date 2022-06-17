# Helm

This directory contains various Helm deployment definitions. I used to have this managed by ArgoCD, but opted for a
deployment scheme with less infrastructure. Feel free to poke around, but I doubt you'll find anything of value.

- [catalog](catalog) - deploys a service catalog with everything consolidated in a single location
- [cert-manager](cert-manager) - manages TLS certificates used by systems in the cluster
- [dist](dist) - provides an asset distribution system, backed by S3
- [drone](drone) - provides continuous integration/deployment, backed by sqlite, and replicated using [litestream][]
- [external-dns](external-dns) - manages DNS records for ingress and service objects in Kubernetes
- [gitea](gitea) - provides a version control system, backed by sqlite, and replicated with [litestream][]
- [ingress-nginx](ingress-nginx) - provides general ingress routing into the cluster for communication
- [kube-prometheus-stack](kube-prometheus-stack) - deploys a minimal monitoring stack
- [maddy](maddy) - deploys a simple email server, backed by sqlite, and replicated with [litestream][]
- [pages](pages) - deploys the [pages](https://github.com/mjpitz/pages) application to manage, monitor, and report on static applications
- [registry](registry) - deploys a docker registry backed by S3 and an AP Redis cache cluster
- [sealed-secrets](sealed-secrets) - allows secrets to be managed in a declarative way and safely commit to repositories

[litestream]: https://litestream.io

---
title: "Reducing cost on DigitalOcean"
pubDate: "August 3 2020"
description: |
  In a Twitter thread between Vito Botta, Alex Ellis, and myself, 
  we talked about how expensive DigitalOcean can be for personal projects.
  You often start off small with just a cluster for compute.
  Eventually you need a database to store your user's information.
  As time goes on, these needs only continue to grow.
  In this post, I share some cost-saving techniques I've used to reduce my bill.

slug: 2020/08/03/digitalocean-setup
tags:
  - software development
---

In a [Twitter thread] between [Vito Botta], [Alex Ellis], and [myself], we talked about how expensive [DigitalOcean] can
be for personal projects. You often start off small with just a cluster for compute. Eventually you need a database to
store your user's information. As time goes on, these needs only continue to grow. In this post, I share some
cost-saving techniques I've used to reduce my bill.

<!--more-->

## Terraform

While not required, I found declarative infrastructure makes a lot of this easier. I decided to migrate my cluster
administration over to using to [Terraform] a few months ago. While my projects are small, I found it easy to use and
documentation easy to navigate. During cluster deployment, I provision an elastic node pool for my workloads. The
following provisions a Kubernetes 1.17 cluster with 1 node and a max of 5.

```hcl-terraform
data "digitalocean_kubernetes_versions" "version" {
  version_prefix = "1.17."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name = "my-cluster"
  region = "sfo2"
  version = data.digitalocean_kubernetes_versions.version.latest_version

  node_pool {
    name = "my-cluster-main"
    auto_scale = true
    min_nodes = 1
    max_nodes = 5
  }
}
```

When the cluster runs out of resources it can scale up to the max. This is done by adding one node at a time until the
cluster has sufficient resources. Sometimes, a single node configuration is not enough. For example, data science
workloads tend to require support for GPUs. In these cases, additional pools can be attached to the cluster.

```hcl-terraform
resource "digitalocean_kubernetes_node_pool" "gpu_pool" {
  cluster_id = digitalocean_kubernetes_cluster.cluster.id
  name = "my-cluster-gpu"
  auto_scale = true
  min_nodes = 0
  max_nodes = 3
}
```

By leveraging the auto-scaling capabilities of node pools, clusters can size themselves accordingly. As a result, we
better manage the cost of our clusters. While this is a large portion of the cost, it does not account for all of it.

## FluxCD

In talking about reducing cost, we must talk about the workloads running within the cluster. Kubernetes abstracts away
cloud providers from engineers, often incurring cost for workloads in cluster. I use what I would consider a pretty
minimal set up.

- [cert-manager] - Manages certificates
- [nginx-ingress] - Enables HTTP communication to systems in cluster (TLS, LetsEncrypt)
- [external-dns] - Automatically manage DNS `A` records for Ingress definitions in cluster
- [linkerd] - A service mesh technology (TLS, self-signed)

I used to run a [Prometheus] deployment, but opted to remove it by default. Over time, I found my hobby projects rarely
use custom metrics. I still run one when I need it, but it's no longer a part of my hobby clusters.

## Priority, quality of service, and eviction

Eviction in Kubernetes can get complicated, but it generally follows a predictable path.

1. pods who are using more memory than requested
1. by quality of service (best-effort, burstable, guaranteed)
1. by priority class

I found this blog post on
[replex](https://www.replex.io/blog/everything-you-need-to-know-about-kubernetes-quality-of-service-qos-classes) to be
really useful in understanding a lot of this. Once I understood how processes would be evicted in my cluster, I just
needed to configure everything properly. `external-dns`, `nginx-ingress`, `linkerd`, and `cert-manager` are all
guaranteed resources. Most workloads I want to be running for demonstrations tend to fall into the `burstable` category.
It's here that I make the most use of priority classes. Finally, any smaller projects I'm working on land on my pis or
in the `best-effort` category.

## Stateful workloads

With stateful workloads, I often find myself running math to figure out if a hosted service is worth it.

The way I see it, many of these services leverage a virtual machine and attached disk. The smallest configuration I
could put together for MySQL on DigitalOcean was $15 / month. At the same time, I could run the same workload from
within the cluster using an [operator] or [Helm chart]. This allowed for smaller deployment configurations that made
better use of the cluster I was already paying for.

When it comes to management, I'm indifferent about operators vs Helm charts. Similarly, they vary greatly on quantity
and quality. Unlike Helm charts, operators tend to handle other types of administrative level tasks. Regardless, I tend
to look for a few things when running StatefulSets in cluster:

_Is persistence enabled by default?_

Some systems don't enabled persistence by default. Not every cluster supports persistent volumes, and some solutions
support this use case.

_What does the shutdown hook look like?_

In some cases, shutting down a stateful system requires a pre-shutdown hook to be sent. Ensuring your stateful system is
shutdown properly is often critical to data integrity.

_Does my cluster support disk expansion?_

As you store more data, you'll likely need to grow your persistent volumes. If your cluster doesn't support volume
expansion, you'll need to size your volume for your expected distribution.

_Is monitoring available?_

At the end of the day, you want to know when something is wrong.

---

Anyway, that's all I have. Thanks for reading y'all.

[Twitter thread]: https://twitter.com/_mjpitz_/status/1290258134590603269
[Vito Botta]: https://twitter.com/vitobotta
[Alex Ellis]: https://twitter.com/alexellisuk
[myself]: https://twitter.com/_mjpitz_
[DigitalOcean]: https://digitalocean.com/
[Terraform]: https://www.terraform.io/
[Kubernetes]: https://kubernetes.io/
[FluxCD]: https://fluxcd.io/
[cert-manager]: https://cert-manager.io/
[nginx-ingress]: https://kubernetes.github.io/ingress-nginx/
[external-dns]: https://github.com/kubernetes-sigs/external-dns
[linkerd]: https://linkerd.io/
[Prometheus]: https://prometheus.io/
[operator]: https://kubernetes.io/docs/concepts/extend-kubernetes/operator/
[Helm chart]: https://helm.sh/

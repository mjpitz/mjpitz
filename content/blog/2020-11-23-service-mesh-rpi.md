---
slug: service-mesh-rpi
date: 2020-11-23
title: "Running a Service Mesh on Raspberry Pis"
tags:
  - software development

---

Many people have asked how to support deploying service mesh to Raspberry Pis.
It wasn't until September that this started to be possible.
[Linkerd] recently released support for arm64, but has had support for it in edge versions since August.
Many [envoy] based service mesh have been blocked by support for an arm-compatible envoy image.

[Consul] is a powerful service discovery and configuration management tool from [Hashicorp].
It has a long history of supporting a variety of execution platforms, operating systems, and architectures.
In 1.2, Hashicorp introduced [Consul Connect], an envoy based service mesh integration.
This allows Consul to control and direct clients in the service mesh data plane.

In this post, I'll demonstrate how to deploy Consul to support a service mesh on Raspberry Pis.
 
[Linkerd]: https://github.com/linkerd/linkerd2/releases/tag/stable-2.9.0
[envoy]: https://envoyproxy.io/
[Consul]: https://www.consul.io/
[Hashicorp]: https://www.hashicorp.com/
[Consul Connect]: https://www.consul.io/docs/connect

<!--more-->

## My setup

To offer some transparency here, I'm working with a fresh deployment of [k3s] `v1.19.1-k3s1`.
I run a single server agent in docker on top of a Raspberry Pi 4, and 4 worker nodes on Raspberry Pi 3b+.
There's nothing specific to my setup in this post, but I find it helpful to understand what I'm working with. 

As usual, all configuration for this post is available on [GitHub](https://gist.github.com/mjpitz/f88bac2edfaebd67f2a2148829e053bb).

[k3s]: https://k3s.io/

## Deploy consul

First, we'll want to deploy Consul.
The easiest way I found to do this was using the [Helm] chart provided by Hashicorp.
The default configuration won't work out of box, so we need to make a few modifications.
Below, you'll find a snippet from the `consul-values.yaml` file included in the Gist.
Here, we override the envoy image used by Consul connect to support arm64.
(`envoyproxy/envoy-alpine` does not yet support `arm64`.)

[Helm]: https://helm.sh

```yaml
global:
  # 1.16 supports both amd64 and arm64 compatible
  imageEnvoy: envoyproxy/envoy:v1.16.0

# ...

connectInject:
  enabled: true

# ...
```

Next, we can deploy consul.
Simply pass in our associated values.yaml file when performing the installation (or upgrade). 

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
# or `helm repo update` if you already have it
  
kubectl create ns consul
helm upgrade -i consul hashicorp/consul -n consul -f consul-values.yaml
```

That _should_ be it.
Consul should be up and running, ready to inject your workloads with an envoy sidecar. 

## Deploy a workload

With Cosnsul Connect running, we want to tell it to inject our workloads with an envoy container.
We do this by adding the `consul.hashicorp.com/connect-inject=true` annotation to the pods.
While you can deploy any project you want, I'll be demonstrating this with my project, [deps.cloud].
In order to run this system, we'll need a [PostgreSQL] database.
I provided a developer configuration that can be used with my postgresql-dev chart.

[deps.cloud]: https://deps.cloud
[PostgreSQL]: https://www.postgresql.org/

```bash
helm repo add mjpitz https://mjpitz.github.io/charts/
# or `helm repo update` if you already have it

helm upgrade -i postgresql-dev mjpitz/postgresql-dev -f postgresql-dev-values.yaml
```

Once PostgreSQL is running we can look at deploying our workloads.
In order for systems to connect to each other when using Consul connect, you need to specify the `consul.hashicorp.com/connect-service-upstreams` annotation.
This annotation lists the upstream services your process intends to connect to.
Below, you can find some examples on how to use the annotations.

```yaml
# for a single service
consul.hashicorp.com/connect-service-upstreams: 'postgresql-dev:5432'
---
# for multiple services
consul.hashicorp.com/connect-service-upstreams: 'depscloud-extractor:9000,depscloud-tracker:9001'
```

**Note:** the ports in the annotation do not have to be the same as the remote service port.
This really tripped me up when working with upstreams.
I was really confused when the value I expected to enter (`depscloud-extractor:8090,depscloud-tracker:8090`) yielded an error.

```bash
$ kubectl logs -n depscloud depscloud-gateway-7579687f59-w9g92 consul-connect-inject-init
Error: service "gateway-sidecar-proxy": 1 error occurred:
        * upstreams cannot contain duplicates by local bind address and port; "127.0.0.1:8090" is specified twice
```

In digging a little further, I learned Consul Connect binds these ports locally.
At first, it felt odd these ports even needed to be specified.
Many other service mesh solutions are able to do this without the need for specification.
It does make sense though.
You don't want your service mesh binding to a port already in use.
The easiest way to get around that is just by being explicit.
Now, you shouldn't need to modify how your services address your remotes.
For example, my applications still target port `8090` despite using different ports on the upstream annotation.

To deploy deps.cloud using the provided configuration, you will need to clone the deploy repository.
I expect the associated changes to be available in `v0.2.33`, once published.

```bash
# helm repo add depscloud https://depscloud.github.io/deploy/charts
# or `helm repo update` if you already have it

git clone https://github.com/depscloud/deploy.git
helm upgrade -i depscloud ./deploy/charts/depscloud -f depscloud-values.yaml
```

This will bring the deps.cloud ecosystem up on top of the Consul connect mesh.

## Next steps

For me, this was just a stepping stone.
Similar to Linkerd and Istio, Consul Connect doesn't quite handle cronjob termination properly.
Using proxy-based service mesh has some advantages, it's not always ideal.
In a resource constrained environment like Raspberry Pi's, the overhead of an additional proxy and sidecar per pod is rough.
In the next couple of weeks, I'll be playing around with [gRPC's XDS integration] for a proxy-less service mesh.

Stay tuned to see it all in action!

[gRPC's XDS integration]: https://github.com/grpc/grpc-go/blob/master/examples/features/xds/ 

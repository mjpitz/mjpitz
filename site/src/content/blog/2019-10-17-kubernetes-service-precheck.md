---
title: "Checking Service Dependencies in Kubernetes"
pubDate: "October 17 2019"
description: |
  Back in July, I found myself needing to better coordinate deployments of my applications to Kubernetes.
  After searching around, I found many ways that people where trying to solve this problem.
  Some used shell scripts to apply multiple YAML files with a fixed time sleep between them.

slug: 2019/10/17/kubernetes-service-precheck
tags:
  - software development

---

Back in July, I found myself needing to better coordinate deployments of my applications to [Kubernetes](https://kubernetes.io/).
After searching around, I found many ways that people where trying to solve this problem.
Some used shell scripts to apply multiple YAML files with a fixed time sleep between them.
Others used shell scripts and tailed the rollout using `kubectl rollout status -w`.
Now, I manage a lot of my deployments using [GitOps](https://www.weave.works/technologies/gitops/) and [Flux](https://github.com/fluxcd/flux).
So leveraging these shell scripts to manage my rollouts into clusters wasn't really an option.

It wasn't until I came across [Alibaba Cloud's](https://us.alibabacloud.com) blog post on [solving service dependencies](https://www.alibabacloud.com/blog/kubernetes-demystified-solving-service-dependencies_594110) that I felt like I had something to work with.
The article described two techniques. 
The first was inspecting dependencies within the application itself. 
At Indeed, we leverage our [status](http://github.com/indeedeng/status) library to do this. 
The second was to enable services to be checked, independent of the application.

In this post, I’ll demonstrate how to use my [service-precheck](https://hub.docker.com/r/mjpitz/service-precheck) initialization container (built off of the Alibaba blog post) to ensure upstream systems are up before attempting to start a downstream system.

<!--more-->

## Concepts

Before reading this blog post, it would be helpful to familiarize yourself with some Kubernetes concepts (if you don’t already know them).

[Liveness and readiness probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) are used to ensure your applications is live and ready. 
Readiness probes are used to determine when an application is ready and able to start receiving traffic. 
While liveness probes are used to check if the application is alive and running. 
A key difference here is that readiness probes control a pods entry in DNS. 
When a pod’s readiness probe is failing, no DNS entry will be available for the pod.

A [headless service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) is one who does not expose a `clusterIP`, and instead exposes the endpoints of a service as entries in DNS (when using a selector).

[initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) are a set of containers within a pod that run before all other containers. 
These containers tend to be relatively short-lived and are typically used to complete some work before the primary process. 
Examples include preparing temporary file systems, initializing some data on disk, as well as probing required services.

## Use Case: MySQL Primary and Replica

Consider the case laid out in the Alababa blog post using MySQL. 
Many applications expect to have both read-write and read-only connections. 
These connection strings often have two different targets. 
To ensure these connection strings resolve, simply pass the list of addresses as arguments to the precheck container.

```yaml
      initContainers:
      - name: service-precheck
        image: mjpitz/service-precheck:latest
        imagePullPolicy: IfNotPresent
        args:
        - "mysql-0.mysql.namespace"
        - "mysql-read.namespace"
```

This will ensure that the `nslookup` for `mysql-0.mysql.namespace` and `mysql-read.namespace` return entries before exiting successfully.

## Use Case: Zookeeper Quorum

Another popular use case is ensuring quorum amongst a coordinating service, like Zookeeper and etcd. 
A recent example where I’ve needed to add this precheck in was in some exploration with [HDFS on Kubernetes](https://github.com/apache-spark-on-k8s/kubernetes-HDFS). 
All the components of HDFS leverage Zookeeper for service discovery and leader election. 
Until Zookeeper is fully initializied, the namenodes, journalnodes, and datanodes will crash loop looking for the Zookeeper entries. 
With the addition of a service-precheck definition, the namenodes, journalnodes, and datanodes were all able to wait for Zookeeper before starting up.

```yaml
      initContainers:
      - name: service-precheck
        image: mjpitz/service-precheck:latest
        imagePullPolicy: IfNotPresent
        args:
        - "zookeeper-0.zookeeper-headless.namespace"
        - "zookeeper-1.zookeeper-headless.namespace"
        - "zookeeper-2.zookeeper-headless.namespace"
```

While letting a pod crash loop until it fixes itself is an option, it tends to come at a cost. 
The container engine on that host needs to continually restart the pod. 
More pod events means more load on your control plane. 
By using service-precheck, I’ve been able to better manage my cluster deployments using GitOps.

Check it out on [GitHub](https://github.com/mjpitz/service-precheck) and [Docker Hub](https://hub.docker.com/r/mjpitz/service-precheck).

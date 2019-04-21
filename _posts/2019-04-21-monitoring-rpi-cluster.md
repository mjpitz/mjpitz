---
layout: post
title: "Raspberry Pi Cluster Monitoring"
tags:
  - iot
  - raspberrypi
  - docker
  - docker-machine
  - monitoring
  - prometheus

---

In my last few posts, I talked a bit about my at home development cluster.
Due to the flexibility of my cluster, I wanted to provide a monitoring solution that was valuable across each technology I use.
In this post, I discuss how monitoring is setup on my cluster.
I'll walk through setting up each node, the prometheus server, and the graphana UI.

<!--more-->

First, if you haven't read my previous posts on my cluster setup I suggest going back and giving them a read.
* [Easy Steps to a 64bit Raspberry Pi 3 B/B+](/2019/03/17/64bit-raspberry-pi)
* [k3s on Raspberry Pi](/2019/04/10/k8s-k3s-rpi-oh-my)
* [Raspberry Pi Cluster Setup](/2019/04/12/rpi-cluster-setup)

Historically, I haven't put much monitoring in beyond the basic orchestrator level tooling.
This was due to the lack of native ARM support on the Prometheus project.
Sure there were a couple personal forks of that running out on the web.
Some of them were well documented, while others were documented much less.
Many people in the ARM community have been waiting for upstream support.

<center>
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Have we finally got upstream official Docker images for Prometheus on ARM? I&#39;ve been having to maintain one for several years...</p>&mdash; Alex Ellis (@alexellisuk) <a href="https://twitter.com/alexellisuk/status/1104361839813640193?ref_src=twsrc%5Etfw">March 9, 2019</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
</center>

6 days ago, [Prometheus](https://prometheus.io) merged in support for [ARM based architectures](https://github.com/prometheus/prometheus/pull/5031).
I briefly stumbled across a tweet this week where someone mentioned that native support was now offered upstream.
With some free time on my hands, I decided to go looking for the images and get a solution running on my cluster at home.

## Running node_exporter on each node

node_exporter is a project from the Prometheus team.
It provides host level information such as cpu, memory, and disk usage.
It also provides much lower detailed information such as open vs max file descriptor counts, memory swap, cpu steal, etc.
In order to get started with the project, you either had to use the container image or go out and compile your own binary.
With the recent introduction of the ARM image, running this has become a bit easier.

```bash
$ docker run -d \
    --name "node-exporter" \
    --network "host" \
    --pid "host" \
    --restart "always" \
    -v "/:/host:ro,rslave" \
    prom/node-exporter-linux-arm64:master \
    --path.rootfs /host
```

You can verify that this process started up successfully by curling the metrics endpoint of the process.
Over time, this page will be updated based on the current usage of the system.

```bash
$ curl http://${ip_address}:9100/metrics
```

Repeat this process for each node within your cluster.

## Picking a monitoring node

I want to explicitly call out to the "monitoring" node aspect of this section.
A monitoring node in this case is simply a node who has a large amount of disk space.
Alternatively, you can leverage an attachable storage solution.
Since my setup is rather minimum, I run this on my laptop during times of experimentation.

## Running Prometheus and Graphana

Before starting the Prometheus server, you need a configuration file.
This file tells Prometheus where it can gather metrics from.
In this case, we use a static_config that points at every node in the cluster.

```yaml
global:
  scrape_interval: 1m
  scrape_timeout: 10s
  evaluation_interval: 1m

scrape_configs:
  - job_name: node-exporter
    static_configs:
      - targets:
        - 192.168.1.100:9100
        - 192.168.1.101:9100
        - 192.168.1.102:9100
        - 192.168.1.103:9100
        - 192.168.1.104:9100
        - 192.168.1.105:9100
        - 192.168.1.106:9100
        - 192.168.1.107:9100
        - 192.168.1.108:9100
        - 192.168.1.109:9100
```

Once the configuration file is defined, I started to look into how to deploy this setup.
I wound up finding docker-compose files to be the best way to managed this.
By using something like `docker stack deploy`, we're able to leverage the `configs` semantic.

```yaml
version: "3.7"

volumes:
  prometheus-data:
  graphana-data:

configs:
  prometheus-config:
    file: ./prometheus.yaml

services:
  prometheus:
    hostname: prometheus
    configs:
      - source: prometheus-config
        target: /prometheus.yaml
    volumes:
      - prometheus-data:/prometheus
    ports:
      - 9090:9090
    image: prom/prometheus
    command: [
      --config.file, /prometheus.yaml,
      --storage.tsdb.path, /prometheus
    ]

  graphana:
    hostname: graphana
    volumes:
      - graphana-data:/var/lib/grafana
    ports:
      - 3000:3000
    image: grafana/grafana
```

Again, I did it this way due to the local server setup.
You can alternatively leverage the `docker run` command in a similar to node_exporter, but using a local volume mount instead.
Once these two processes are up and running you should be able to navigate to the UI in the browser.

```bash 
$ open http://${ip_address}:9090   # prometheus
$ open http://${ip_address}:3000   # graphana

## on linux, this will be "xdg-open" instead of "open"
```

### Adding Prometheus as a data source to Graphana

Once you have the Graphana interface open, you'll need to configure a data source.
Graphana supports Prometheus as a data source, so connecting them is easy.
In the address line, you'll want to point it at your Prometheus server.
For me, this was `http://prometheus:9090`.
Because docker sets up an overlay network by default, I'm able to connect services on the same networking using their `hostname`.

### Adding dashboards

Once the data source has been configured, you can start adding dashboards to Graphana for monitoring your application.
Graphana offers tons of pre-built dashboards.
They're all community driven, so finding a well maintained dashboard can be a bit tricky.
The first dashboard that I found extremely useful was the [full export of all node_exporter](https://grafana.com/dashboards/1860) metrics.

![Node Exporter Full](/statics/img/rpi-mon-node-exporter-full.png)

Using this dashboard, I'm able to get a detailed view of each node.
It encapsulates all metrics emitted by node_exporter into a single view.
While this might seem overwhelming, the dashboard collapses the more details panels.
This makes it easy to get a high level view of a node, and then dive in.

One thing that this dashboard did not enable was a complete overview of all nodes in the cluster.
This kind of dashboard has been an extremely valuable resource in Datadog when investigating capacity constraints.
Below, you'll see an example of this using aws-regions.

![Datadog Host Map](/statics/img/rpi-mon-dd.jpg)

After looking around for a bit, I wasn't able to find a rough equivalent.
So I started to build / prototype my own.
First, I started with a few of the queries from the Node Exporter Full dashboard.
With a few modifications, I was able to get something started.

![Cluster Overview](/statics/img/rpi-mon-cluster-overview.png)

While it may not look as nice as the host map in Datadog, I was able to get the same overview of information.
First, I look for the capacity of the cluster as a whole.
The 3 guages along the top monitor the current clusters usage across all nodes.
The 3 heatmaps below show the same usage broken down by each instance in the cluster, over time.
This allows me to be able to track drastic changes in compute, memory, or disk back to an originating point.

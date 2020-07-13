---
slug: rpi-cluster-setup
date: 2019-04-12
title: "Raspberry Pi Cluster Setup"
tags:
  - iot
  - raspberrypi
  - docker
  - docker-machine
  - k3s

---

Previously, I talked about the different orchestration technologies that I've run on my Raspberry Pi cluster.
That post was rather high level and only contained details relating to k3s.
In this post, we'll take a more in depth look at my cluster setup and my management process around it.

<!--more-->

The diagram below roughly shows how I have my home network setup.
I have 2 racks of 5 nodes.
Each rack is independently powered.
Each Raspberry Pi runs [Ubuntu 18.04](/blog/2019/03/17/64bit-raspberry-pi/), has cgroups enabled, and is assigned a static IP.

![Private Cloud](/statics/img/private-cloud.png)

For easy access to each node, I copy my ssh key to each Pi.

```
ssh-copy-id ubuntu@${ip_address}
```
<p></p>

Then, I use [docker-machine](https://docs.docker.com/machine/overview/) to setup and configure docker on each node.
To setup a Raspberry Pi this way, you'll want to use the `generic` machine driver.
The driver requires an IP address, ssh user, ssh key, and a name.
Note that docker-machine will set the hostname of the remote IP to be the name of the machine.

```
docker-machine create \
  --driver generic \
  --generic-ip-address ${ip_address} \
  --generic-ssh-user ubuntu \
  --generic-ssh-key ~/.ssh/id_rsa \
  ${name}
```
<p></p>

By leveraging docker-machine, I'm now able to treat my laptop as a remote control to my cluster.
I can see the status of all my machines without any additional monitoring or setup.

```
$ docker-machine ls
NAME        ACTIVE   DRIVER    STATE     URL                        SWARM   DOCKER     ERRORS
myriad-1    *        generic   Running   tcp://192.168.1.100:2376           v18.09.4   
myriad-2    -        generic   Running   tcp://192.168.1.101:2376           v18.09.4   
myriad-3    -        generic   Running   tcp://192.168.1.102:2376           v18.09.3   
myriad-4    -        generic   Running   tcp://192.168.1.103:2376           v18.09.3   
myriad-5    -        generic   Running   tcp://192.168.1.104:2376           v18.09.3   
myriad-6    -        generic   Running   tcp://192.168.1.105:2376           v18.09.3   
myriad-7    -        generic   Running   tcp://192.168.1.106:2376           v18.09.3   
myriad-8    -        generic   Running   tcp://192.168.1.107:2376           v18.09.3   
myriad-9    -        generic   Running   tcp://192.168.1.108:2376           v18.09.3   
myriad-10   -        generic   Running   tcp://192.168.1.109:2376           v18.09.3   
```
<p></p>

Using `docker-machine env`, I can configure my laptop's shell to point to specific nodes in the cluster.
This makes it easy to run, interact with, or extract contents from remote docker containers.

```
$ eval $(docker-machine env myriad-1)

$ docker ps -a
CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS               NAMES
c5ba1248a881        rancher/k3s:v0.3.0-arm64   "/bin/k3s agent"         3 days ago          Up 3 days                               k3s-exec
85aa7d46da72        rancher/k3s:v0.3.0-arm64   "/bin/k3s server --d…"   3 days ago          Up 3 days                               k3s-control

$ docker cp k3s-control:/etc/rancher/k3s/k3s.yaml ~/.kube/k3s
```
<p></p>

As a result, I'm now able to write some rather simple [scripts](https://github.com/mjpitz/terraform-rpi/tree/master/scripts) for automating cluster management.
Beyond that, there really isn't much.
I've found working with this setup at home to be really nice as I can easily debug remote issues quickly.

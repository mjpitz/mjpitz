---
layout: post
title: "k3s on Raspberry Pi"
tags:
  - iot
  - raspberrypi
  - kubernetes
  - k3s

---

Over the last few days, I've been playing [Kubernetes](https://kubernetes.io) on my cluster of Raspberry Pis.
I hope to share what I learned in the process and some of the tooling that I discovered along the way.

<!--more-->

When I first sat down to install Kubernetes, I wanted to start with something easier first.
Using [docker-machine](https://docs.docker.com/machine/), I was able to quickly put together a [swarm](https://docs.docker.com/engine/swarm/) cluster.
Once I had that running for a while, I started in on Kubernetes.
I don't recall what guide I was following, so it's hard to say where things went wrong.
All I can remember was spending several hours working on it, only to end up with a partially functional cluster.
As a result, I threw everything out and decided to try [Nomad](https://www.nomadproject.io).
Running both [Consul](https://www.consul.io/) and Nomad wound up taking a fraction of that time.
They required more provisioning compared to the docker-swarm cluster, but it was easy to automate.

<div class="row text-center">
  <div class="col-xs-12 col-sm-1"></div>
  <div class="col-xs-6 col-sm-5">
    <img title="Consul" alt="Consul" src="/statics/img/consul.png">
  </div>
  <div class="col-xs-6 col-sm-5">
    <img title="Nomad" alt="Nomad" src="/statics/img/nomad.png">
  </div>
  <div class="col-xs-12 col-sm-1"></div>
</div>
<p></p>

After working with swarm and nomad for a few months, I took a look to see what was new for k8s.
First, I came across [Rancher's RKE](https://github.com/rancher/rke) command line tool.
It makes provisioning production-ready Kubernetes clusters quick and painless.
Since it was configuration drive, I decided to give it a try and see how it ran on the Raspberry Pis.
I was impressed with how easy it was to get everything up.
I was able to connect to the cluster without an issue, and perform various commands.
One of it's biggest downsides though was the overhead of some of the integrations.
Many of my nodes, were already consuming half their memory, and I needed dedicated etcd and control plane nodes.

<div class="text-center">
  <img title="rancher" alt="Rancher" src="/statics/img/rancher.png">
</div>
<p></p>

The second tool was [k3s](https://k3s.io/).
k3s is a lightweight distribution of kubernetes that targets IOT devices.
k3s is intended to be deployed similarly to k8s so it follows a similar deployment.
Where as a solution like [MicroK8s](https://microk8s.io) is more intended to be used as a single node, running on an IOT device.
A pocket kubernetes cluster if you will.
Given I was looking for something closer to native k8s, I decided to give k3s a spin.

### Starting the control plane

I decided to try running all components in docker containers.
Typically, I run these processes in systemd but I wanted to consider other alternatives.
This came out of seeing how RKE provisioned resources under the hood.

k3s requires a docker volume to store the server data.
Once the volume is created, we can run the k3s server process.
Note that in the run command below, I'm explicitly disabling the agent.
This is because I run the agent as a separate docker-container on this host.
The agent requires the `--priviledged` flag, a permission I didn't want to grant to the api-server.

```
$ docker volume create k3s-control

$ docker run -d \
    --name "k3s-control" \
    --network "host" \
    --restart "always" \
    -e "K3S_CLUSTER_SECRET=<YOUR_SECRET_HERE>" \
    -v "k3s-control:/var/lib/rancher/k3s" \
    -p "6443:6443" \
    rancher/k3s:v0.3.0-arm64 \
    server --disable-agent
```
<p></p>

After about 30 seconds, the control node will be fully booted.
As a part of it's setup, the control node writes the kubeconfg file out to `/etc/rancher/k3s/k3s.yaml`.
Using the following `docker cp` command, you can copy the artifact out of the container and into your `.kube` directory.
Once you've retrieved the file, you'll want to export it so that `kubectl` can easily interact with the api-server.

```
$ docker cp k3s-control:/etc/rancher/k3s/k3s.yaml ~/.kube/${USER}-k3s
$ export KUBECONFIG=~/.kube/${USER}-k3s
```
<p></p>

_NOTE: you will need to modify the extracted kubeconfig file and change "https://localhost:6443" to point to the proper host._
_In my case, this was "https://192.168.1.100:6443"._
_If you do not change this, kubectl cannot communicate with the api-server._

### Starting the agents

Once the api-server is up and running, we need to add some agents.
Agents are the component of the stack that are responsible for managing the processes running on the host.
As a result, the need to be privileged so that they may spin up additional work where needed.

```
$ docker run -d \
    --name "k3s-exec" \
    --network "host" \
    --restart "always" \
    -e "K3S_CLUSTER_SECRET=<YOUR_SECRET_HERE>" \
    -e "K3S_URL=https://<CONTROL_IP>:6443" \
    --privileged \
    --tmpfs /run \
    --tmpfs /var/run \
    rancher/k3s:v0.3.0-arm64
```
<p></p>

The agents should start up quicker compared to the api-server.
You can verify that they connected to the api-server using kubectl.
Remember, you'll need to export the `KUBECONFIG` environment variable to point at the right config.

```
$ kubectl get node
NAME        STATUS    ROLES     AGE       VERSION
myriad-1    Ready     <none>    1d        v1.13.5-k3s.1
myriad-10   Ready     <none>    1d        v1.13.5-k3s.1
myriad-2    Ready     <none>    1d        v1.13.5-k3s.1
myriad-3    Ready     <none>    1d        v1.13.5-k3s.1
myriad-4    Ready     <none>    1d        v1.13.5-k3s.1
myriad-5    Ready     <none>    1d        v1.13.5-k3s.1
myriad-6    Ready     <none>    1d        v1.13.5-k3s.1
myriad-7    Ready     <none>    1d        v1.13.5-k3s.1
myriad-8    Ready     <none>    1d        v1.13.5-k3s.1
myriad-9    Ready     <none>    1d        v1.13.5-k3s.1
```
<p></p>

### Setup Details

There are a few key details about this setup that are worth noting.

`--network "host"`

This flag tells the docker container to leverage the hosts network instead of the bridge provided by docker.
([Documentation](https://docs.docker.com/engine/reference/run/#network-settings))

`--restart "always"`

This flag tells the docker daemon to restart the process regardless of it's exit status.
I'd use either `always` or `unless-stopped`.
In practice, the container is either present and running or removed so I tend to lean towards `always`.
([Documentation](https://docs.docker.com/engine/reference/run/#restart-policies---restart))

`-e "K3S_CLUSTER_SECRET=<YOUR_SECRET_HERE>"`

This is the shared secret that is used to bootstrap the cluster.
Alternatively, you can set the `K3S_TOKEN` which is generated by the control plane.
For a quick start, I suggest the cluster secret.
If you're looking to be able to dynamically add nodes on the fly, the token is a bit better.

## Resources
In [Easy Steps to a 64bit Raspberry Pi 3 B/B+](/blog/2019/03/17/64bit-raspberry-pi/), I talk about how easy it is to get a 64bit Raspberry Pi up and running.

Since starting my cluster, I've been committing the scripts I used to manage it to a [repository](https://github.com/mjpitz/terraform-rpi).
This repo has taken on a few different shapes, but it can be a good reference point for how all of this gets stood up.

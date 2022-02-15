---
slug: k8s-k3s-rpi-oh-my
date: 2019-04-10
title: "k3s on Raspberry Pi"
tags:
  - software development

---

Over the last few days, I've been revisiting [Kubernetes](https://kubernetes.io) on my Raspberry Pi cluster.
I hope to share what I learned in the process and some of the tooling that I discovered along the way.

<!--more-->

I first sat down to experiment with Kubernetes back when I first built my cluster.
I don't recall what guide I was following, so it's hard to say where things went wrong.
All I can remember was spending several hours working on it, only to end up with a partially functional cluster.
As a result, I threw everything out and switched to running [Nomad](https://www.nomadproject.io).
Running both [Consul](https://www.consul.io/) and Nomad wound up taking a fraction of the time.
They required more provisioning compared to Docker Swarm, but it was easy to automate.

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

After working with Swarm and Nomad for a few months, I took a look to see what was new for k8s.
First, I came across [Rancher's RKE](https://github.com/rancher/rke) command line tool.
It makes provisioning production-ready Kubernetes clusters quick and painless.
Since it was configuration driven, I decided to give it a try and see how it ran on the Raspberry Pis.
I was impressed with how easy it was to get everything up and running.
I was able to connect to and interact wtih the cluster without an issue.
One downside was the overhead of some of the integrations.
Many of my nodes were already consuming half their memory, and I needed dedicated etcd and control plane nodes.

<div class="text-center">
  <img title="rancher" alt="Rancher" src="/statics/img/rancher.png">
</div>
<p></p>

I also came across [k3s](https://k3s.io/).
k3s is a lightweight distribution of kubernetes that targets IOT devices.
This was appealing because it is intended to be deployed similar to k8s.
[MicroK8s](https://microk8s.io) presented another alternative, but it was intended to run as a single node.
A pocket kubernetes cluster if you will.
Given I was looking for something closer to native k8s, I decided to give k3s a spin.

### Starting the control plane

After seeing how RKE deployed k8s to the cluster, I decided to try running k3s out of docker.
Typically, I run these processes in systemd but I wanted to consider other alternatives.

k3s control plane requires a docker volume to store the server data.
Once the volume is created, we can run the k3s server process.
Note that in the run command below, I explicitly disable the agent.
The agent requires the `--priviledged` flag in order to run processes on the host.
The control plane doesn't require this permission.
As a result, I decided to run them as separate processes.

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

After about 30 seconds, the control plane should be running.
As a part of it's setup, it writes the kubeconfg out to `/etc/rancher/k3s/k3s.yaml`.
Using the following `docker cp` command, you can copy the file from the container and into your local `.kube` directory.
Once copied, you'll want to export it so that `kubectl` can easily interact with the remote control plane.

```
$ docker cp k3s-control:/etc/rancher/k3s/k3s.yaml ~/.kube/k3s
$ export KUBECONFIG=~/.kube/k3s
```
<p></p>

_NOTE: you will need to modify the extracted kubeconfig file and change "https://localhost:6443" to point to the proper host._
_In my case, this was "https://192.168.1.100:6443"._
_If you do not change this, kubectl cannot communicate with the api-server._

### Starting the agents

Once the control plane is up and running, we need to add the agents.
Agents are the component of the stack that are responsible for managing the processes running on the host.
As a result, they need to be privileged to spin up containers where needed.

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

The agents should start up quicker compared to the control plane.
You can verify that they connected successfully using kubectl.
Remember, you'll need to have the `KUBECONFIG` environment variable exported.

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
For this kind of process, I'd use either `always` or `unless-stopped`.
In practice, the container is either present and running or removed so I tend to lean towards `always`.
([Documentation](https://docs.docker.com/engine/reference/run/#restart-policies---restart))

`-e "K3S_CLUSTER_SECRET=<YOUR_SECRET_HERE>"`

This is the shared secret that is used to bootstrap the cluster.
Alternatively, you can set the `K3S_TOKEN` which is generated by the control plane.
For a quick start, I suggest the cluster secret.
If you're looking to be able to dynamically add nodes to the cluster, the token is a bit better.

## Resources
In [Easy Steps to a 64bit Raspberry Pi 3 B/B+](/blog/2019/03/17/64bit-raspberry-pi/), I talk about how easy it is to get a 64bit Raspberry Pi up and running.

Since starting my cluster, I've been committing the scripts I used to manage it to a [repository](https://github.com/mjpitz/terraform-rpi).
This repository has taken on a few different shapes, but it can be a good reference point for how all of this gets stood up.

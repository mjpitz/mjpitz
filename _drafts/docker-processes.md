---
layout: post
title: "Managing Processes with Docker"
tags:
  - iot
  - docker

---

When it comes to running daemon processes, I've typically used `systemd` to manage it's runtime.
`systemd` is an init system used to bootstrap the user space on a linux machine.
Over time, systemd has suffered from one big problem: [scope creep](http://without-systemd.org/wiki/index.php/Arguments_against_systemd).
More and more, components were added to `systemd` to expand it's capabilities.
Inspired by many folks in the open source community, I decided to give running my user space processes in `docker`.

<!--more-->

## Motivators

There were a few key motivators that influenced me to give this a try.

By specifying `--network "host"`, you instruct docker to leverage the host's network.
Using this argument means you do not need to specifying any port maps.
Any port that is exposed by the container image will be addressable on the host.

By specifying `--pid "host"`, you instruct docker to leverage the host's PID namespace.
This allows you to interact with the process through standard process management tools like `ps`.

```bash
ubuntu@myriad-1:~$ docker ps -a
CONTAINER ID        IMAGE                                   COMMAND                  CREATED             STATUS                     PORTS               NAMES
b594f14bab68        prom/node-exporter-linux-arm64:master   "/bin/node_exporter …"   2 days ago          Up 2 days                                      node-exporter

ubuntu@myriad-1:~$ ps aux | grep node_exporter
nobody    2271  0.0  1.3 113828 13024 ?        Ssl  Apr21   3:27 /bin/node_exporter --path.rootfs /host
```

By specifying `--restart "always"`, you instruct docker to restart the process regardless of the exit code.
This ensures that your process is always running.
Docker provides several restart policies out of box.
I tend to lean towards always, but do take a look at other [alternatives](https://docs.docker.com/engine/reference/commandline/run/#restart-policies---restart).

Using this series of flags, you can run any process you typically run in `systemd` using `docker`.

## In learning

Early in my career, I never really needed to worry about managing my own processes.
I started out coding PHP, HTML, JavaScript, CSS and running it all in a simple Apache web server.
As I shifted into industry, I found myself moving more and more down the stack.
Early versions of our development environment involved virtual machines and Chef.
Shortly after the release of docker, we started to investigate it for development use.
My team specifically was starting to feel some of the pain involved in managing such a large virtual machine.
In having a hand in that effort, I quickly learned how to manage and debug containers locally.
As a result, I found myself more familiar with the landscape of `docker` compared to `systemd`.

`docker`, or any container system for that matter, is more intuitive for people who haven't previously worked on systems.
Docker has a really low barrier and many engineers, regardless of skill level, are able to pick it up.

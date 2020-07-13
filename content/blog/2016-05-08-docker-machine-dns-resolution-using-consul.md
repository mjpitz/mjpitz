---
slug: docker-machine-dns-resolution-using-consul
date: 2016-05-08

layout: post
title: "Docker Machine DNS Resolution using Consul"
tags:
  - docker

---

Developers at [Indeed] have _recently_ switched over to using docker for local development.
Being one of the earlier adopters, I fell in love with the type of workflow that it enabled.
It allowed me to create seamless environments between both my desktop and portable workstation.
The tooling did this by allowing you to resolve container names as hosts in your web browser.
For example, if I had a web application named **indigo** running on port 4000, I could go to http://indigo:4000 to access that application.
After a few weeks of enjoying the simplicity of this development workflow, I craved a similar type of environment for some of the larger scale projects that I do at home.
In this blog post, I will cover some of the basics that allowed me to enable this type of development.

<!--more-->

<br/>
<div class="alert alert-success">
<b>Note:</b> I recently moved all of these utilities out into a separate code repository to make lives easier.
<a href="https://github.com/jpitz/docker-utils">https://github.com/jpitz/docker-utils</a>
</div>
<br/>

## Getting Started

To start, I want to explain the main differences between my workflow and the [Indeed] workflow.
I started using [docker-machine] and [docker-compose] as soon as I could.
These tools are still early on in their development and many people have yet to adopt the technology.
I saw power behind multi-machine tooling and the simplicity of defining containers through inheritance.
This has allowed me to build out some complex services quickly.
Additionally, I installed [dnsmasq] to set up a local development domain.
Since I only develop on an OSX machine at home, I needed a way to provide a multitude of domains quickly with very little configuration.
dnsmasq allows me to do this quickly and with very few lines of code.

### Install Dependencies

In order to be able to follow the examples and tutorial below, first insure that you have [docker-machine] installed on your machine.
Optionally, you can install [docker-compose] as it allows for machines to be created through definition inheritance rather than requiring a local docker registry.
I have provided the versions that are currently running on my box for each below.

```
[jpitz@jpitz ~/Development dev 2/2]
$ docker-machine --version
docker-machine version 0.7.0, build a650a40

[jpitz@jpitz ~/Development dev 2/2]
$ docker-compose --version
docker-compose version 1.7.0, build unknown
```

## Basic Setup

First, we need to get the docker instance inside of the machine to behave in a more expected way.
To do this, we set the bind ip of the docker engine to be one we can reference at a later time.

```
docker-machine create \
    --engine-opt bip=172.30.254.1/24 \
    --driver virtualbox \
    default
```

Next, ensure that your environment variables are set correctly.
You can do this by evaluating the result of the docker-machine env command.

```
eval $(docker-machine env default)
```

Now that our docker-machine is up and running, we can stand up our consul instance.
This consul instance will be used to register applications as nodes and resolve hostnames to docker-machine ips.
In the command below, we are doing several port mappings.
The first maps the docker-machine's port 53 (tcp) to port 53 (udp) of the consul container.
We bind this port because requests for DNS resolution come in on port 53.
By binding this port back to the host machine, it exposes the DNS resolution capabilities of consul.
The second maps the docker-machine's port 8301 (tcp) to port 8301 (udp) of the consul container.
These two ports play an important role in the DNS resolution process.
Port 8301 allows us to have consul instances be able to communicate with other instances of consul.
We expose this so that we can have various docker-machines speaking to one another.
Lastly, we map the consul web interface back to the docker machine to allow for direct communication with the consul api.

```
docker run -dt -h node \
    --name="consul" \
    --hostname="consul" \
    -p 53:53/udp \
    -p 8301:8301/udp \
    -p 8500:8500 \
    progrium/consul \
    -dc=default \
    -server \
    -bootstrap \
    -advertise $(docker-machine ip default)
```

Now that we have an instance of consul running, we need to register some nodes to be able to resolve.
Using the [docker-dns-register] command, we can retrieve the ip of a provided container name and register it as a node with the consul instance.
The [docker-dns-register-all] command will retrieve a list of all running containers for the current docker-machine and register each as a node with the consul instance.
Run the `docker-dns-register consul` command to register consul as a node with itself.

Lastly, we need to do some local routing table trickery to enable DNS resolution through our newly created consul instance.
This logic is encapsulated withing the [docker-dns-configure] command.
The process can be broken down to four simple steps.

1. For each available network, add 'node.consul' to possible search domains (if necessary).
2. Set the proper nameserver for the node.consul instance in the resolveconf `/etc/resolver/node.consul`.
3. Update the routing table to point requests to 172.30.254.0 through gateway $(docker-machine ip default)
4. Restart dnsmasq to pick of new DNS configurations

Using your web browser you should now be able to resolve [http://consul:8500/ui/]().
And that's it!
Anytime, you start a new docker container, simply re-run the `docker-dns-register ${container-name}` command and you will be able to access it using `http://${container_name}:${your_port}/`.

## Practical Applications

There are many practical applications for this technique.
Applications often have dependencies like [MongoDB] or [MySQL].
Using this technique we can enable container to container based communication without needing to manually link containers.
Another application of this DNS resolution is it's integration with [consul-template].
[consul-template] can be used to set up a dynamic proxy daemon that watches a consul instance and writes out proxy configurations.


### Container-to-Container Communication

A popular approach to making containers able to communicate with each other is through linking.
This is considered the 'legacy' way to do things as it requires additional overhead.
A better approach would be to use the DNS to resolve dependencies.
It removes the overhead and offers a more fluent approach to building software in a local development mode and in a production environment.
Say we have application requires a [MongoDB] and a [MySQL].
Using the docker-run wrapper, we can quickly stand up an instance of each.

```
docker-run --name="mongo" --hostname="mongo" mongo
docker-run --name="mysql" --hostname="mysql" -e "MYSQL_ROOT_PASSWORD=root" mysql
```

The docker-run wrapper adds consul as a DNS resolver using the `--dns` flag and as a search domain using `--dns-search`.
It also kicks the tool off as a daemon using the `-d` flag.

After registering the new containers, you can test connecting to your services using the command link clients as well as the browser.

```
mongo --host mongo
mysql -h mysql -uroot -proot
```

### Consul Template Proxy and dnsmasq

Using [dnsmasq], developers can set up a local domain for their machine.
For my machine, I set up `jpitz.local`.
The blog post [here](https://passingcuriosity.com/2013/dnsmasq-dev-osx/) does a great job explaining how to setup development domains.

[consul-template] is a tool developed by hashicorp that monitors a consul instance.
It's specifically used to dynamically re-write configurations based on services and nodes registered in the instance.
Such configurations can be nginx proxy configurations, apache vhost configurations, or HASProxy configurations.
The [consul-template] GitHub page has some excellent examples to follow.
For my environment, I set up proxies to resolve to subdomains off of jpitz.local.

<pre>
&#123;&#123; range nodes }}
&#123;&#123; .Name }}.jpitz.local
&#123;&#123; end }}
</pre>


Enjoy!


## References

* [Overview of DNS Resolution](http://www.tcpipguide.com/free/t_DNSNameResolutionProcess-2.htm)
* [docker-machine]
* [docker-compose]
* docker-dns commands from [dotfiles]
* docker-run wrapper from [dotfiles]

[Indeed]: http://www.indeed.com
[docker-machine]: https://docs.docker.com/machine/install-machine
[docker-compose]: https://docs.docker.com/compose/install/
[dotfiles]: https://github.com/jpitz/dotfiles
[docker-dns-configure]: https://github.com/jpitz/dotfiles/blob/master/bin/docker-dns-configure
[docker-dns-register]: https://github.com/jpitz/dotfiles/blob/master/bin/docker-dns-register
[docker-dns-register-all]: https://github.com/jpitz/dotfiles/blob/master/bin/docker-dns-register-all
[MongoDB]: https://hub.docker.com/_/mongo/
[MySQL]: https://hub.docker.com/_/mysql/
[consul-template]: https://github.com/hashicorp/consul-template
[hashicorp]: https://www.hashicorp.com
[dnsmasq]: https://wiki.debian.org/HowTo/dnsmasq

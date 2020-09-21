---
slug: protobuf-experience
date: 2020-09-21
title: "Working with Protocol Buffers"
tags:
  - protobuf
  - grpc
  - grpc-streaming
  - golang
  - python
  - nodejs
  - java

---

Google's [Protocol Buffers] can be a power piece of technology.
Yet, I often feel they are undervalued, underutilized, and underappreciated.
Since joining [Indeed] back in 2013, I've had a fair amount of experience working with them.
[Boxcar] (Indeed's distributed services framework) was built on protocol buffers.
As a previous maintainer of Boxcar, I've had hands on experience with low level components of protocol buffers.
In this post, I discuss many of the benefits to using the technology.

[Protocol Buffers]: https://developers.google.com/protocol-buffers/docs/
[Indeed]: https://www.indeed.com
[Boxcar]: https://engineering.indeedblog.com/blog/2012/12/boxcar-self-balancing-distributed-services-protocol/

<!--more-->

Over the last decade, I've written services of different shapes and forms.
In college, I started writing RESTful services using PHP and CodeIgniter.
Over time, I switched to C# and continued with RESTful patterns.
It wasn't until I started working at Indeed that I was first exposed to protocol buffers.

## Language agnostic contract

My first exposure to Protocol Buffers was in Indeed's Boxcar framework.
The first benefit I saw was the language agnostic contract.
Back then, I worked regularly between JavaScript and Java regularly.
Having a technology that wasn't specifically tied to any language was promising.

This contract defines the services and methods available, as well as the messages used throughout.
Versioning is the responsibility of authors and is often built into the package.
For example, `company.application.v1beta` or `project.v1beta.resource`.
This contract is also extensible.
We can provide custom extensions to enrich the contract and add metadata.

## gRPC, REST, and swagger

I'm a long time supporter of [gRPC].
I think it's been a great addition to open source, and the suite of tools surrounding it shows.
For example, [grpc-gateway] makes it easy for gRPC processes to expose RESTful interfaces.
It works by annotating protocol buffer services with RESTful routing semantics.
We can provide these annotations inline or in an external yaml file.

```yaml
type: google.api.Service
config_version: 3

http:
  rules:
    # /v1beta/graph
    ## GraphStore
    ### Put
    - selector: graphstore.api.v1beta.GraphStore.Put
      put: /v1beta/graph
      body: "*"
    ### Delete
    - selector: graphstore.api.v1beta.GraphStore.Delete
      delete: /v1beta/graph
      body: "*"
    ### List
    - selector: graphstore.api.v1beta.GraphStore.List
      get: /v1beta/graph
    - selector: graphstore.api.v1beta.GraphStore.List
      get: /v1beta/graph/{kind}
    ### Neighbors
    #### all neighbors
    - selector: graphstore.api.v1beta.GraphStore.Neighbors
      get: /v1beta/graph/{node.key}/neighbors
    #### neighbors on the receiving end of edges
    - selector: graphstore.api.v1beta.GraphStore.Neighbors
      get: /v1beta/graph/{from.key}/neighbors/from
    #### neighbors on the initiating end of edges
    - selector: graphstore.api.v1beta.GraphStore.Neighbors
      get: /v1beta/graph/{to.key}/neighbors/to
```

During compilation, the plugin uses this information to generate code that supports binding gRPC services to an HTTP 1.1 interface.
This same metadata can be used to generate [swagger] documentation for an API.
You simply need to modify a single file, and let code generation take care of the REST.

[gRPC]: https://grpc.io/
[grpc-gateway]: https://github.com/grpc-ecosystem/grpc-gateway
[swagger]: https://swagger.io/

## Client generated code

Finally, one of the most powerful feature of gRPC and protocol buffers is the ability to code generate clients for many languages.
While there are solutions for taking swagger definitions and generating clients from them, I've found issues with many and few support more than one language (well).
This has been one of the core tenants to protocol buffers since it was released in 2008.
Define a service and generate clients or servers for your language.

If you're contemplating starting a new project, I encourage you to take a look at protocol buffers and gRPC.
These two pieces of technology are essential building blocks I added to my toolkit a long time ago.
With them, I've been able to quickly develop prototypes and reduce a lot of boilerplate on new systems.
If you'd like any help getting started, feel free to reach out to me on [twitter].

[twitter]: https://twitter.com/myajpitz 

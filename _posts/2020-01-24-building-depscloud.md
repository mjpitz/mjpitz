---
layout: post
title: "Building deps.cloud"
tags:
  - docker
  - kubernetes
  - microservices
  - dependencies

---

Over the last year, I've been heavily working on [deps.cloud](https://deps.cloud).
deps.cloud draws it's inspiration from a project that I worked on at [Indeed.com](https://indeed.com).
Since it's original inception, there had been a heavy push to move it into the open source space.
In this post, I'll discuss the process and rationale I applied as I rewrote this project in the open.

<!--more-->

## V1 - Origin

At Indeed, I had built and prototyped the process internally known as Darwin (not to be confused with [Apple's Darwin](https://en.wikipedia.org/wiki/Darwin_(operating_system))).
I named it this way as it was intended to help evolve Indeed's projects and libraries.
It facilitated many operations that could be automated across our ecosystem.
Such operations included (but were not limited to):

* Evaluating risk of library upgrades across our infrastructure
* Perform on the fly API compatibility checks
* Apply patches and open pull requests to affected repositories

There were many downsides with the way that this system was originally written.

* Only supported [Apache Ivy](https://ant.apache.org/ivy/)
* Long start up time with no backing store (kept all information in memory)
* Inability to expand support to other languages

Even over time, I needed to expand this system to be able to start up faster and reduce load on our version control system.
This inevitably created a tight coupling with our [Resilient Artifact Distribution](https://www.youtube.com/watch?v=lDXdf5q8Yw8).
As time went on, this system became increasingly more difficult to open source.

## V2 - Private GitLab

During my hiatus from Indeed in 2018, I decided to try and rewrite the system.
I found myself really wanting the set of tooling I built and all the automation that came with it.
Given I worked at a small start up at the time, I decided to keep the code closed source.
To do so, I started a single monorepo in GitLab.

As I began the first rewrite, I wanted to work with a more flexible language.
The original system was written in Java which made interacting with arbitrary structures rather difficult.
To reduce the cognitive load, I decided to work with [TypeScript](https://www.typescriptlang.org/).
It had given me the best of both worlds: being able to have static and duck types when needed.

After having this iteration done, I started to run several tests.
What I found was that the TypeScript solution worked well for a subset of operations, but did not scale for others.
After learning this, I went back to the drawing board.

## V3 - Public GitHub

In late 2018, I returned to Indeed to work on our Kubernetes related efforts.
Around the same time, I had started to port some of the code from closed to open source.
It all started out under my user, just hacking on few different ideas.
Having recently been thrown into the [Golang](https://golang.org/) ecosystem, I decided to give it a try.
I quickly found Golang provided much more efficient solution over the previous TypeScript solution.
But like Java, it lacked the flexibility I needed in some places.

One thing I was able to adapt from the closed source model was the [gRPC](https://grpc.io/) interfaces.
gRPC does a really good job of enabling multi-language systems by providing a standard RPC mechanism. 
Having put some good service interfaces in place, I was able to leverage part of the V2 solution.
In the end, I wound up with a good chunk of the services being written in Golang and a single service written in TypeScript.

## Get Started

Once the open sourced code base was in a stable position, I wanted to focus on making the system easy to run.
I had seen many similar solutions starting to arise in open source.
Many of them, like [Tidelift](https://tidelift.com/) and [Snyk](https://snyk.io/), require you to leverage their cloud hosted solution which comes at a cost.
I wanted to meet companies where they were, no matter their size.
This inspired me to focus on [Docker](https://www.docker.com/) support first and foremost.
Then, I was able to quickly follow that with [Kubernetes](http://kubernetes.io/) and [Helm](https://helm.sh/) support.

For more information on how to get started, see our [documentation](https://deps.cloud/docs/).
Cheers!

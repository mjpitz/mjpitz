---
slug: learning-jsonnet
date: 2020-10-12
title: "Learning Jsonnet"
tags:
  - slo
  - sli
  - reliability
  - open-source
  - oss
  - sre
  - jsonnet
  - grafana
  - prometheus
  - alerts
  - dashboards
  - rules

---

[Jsonnet] is a powerful data templating language.
It extends JSON with variables, conditionals, functions, imports and more.
As an engineer who never touched the technology before, I often struggled to understand it.
In this post, I share my experience learning Jsonnet and my thoughts behind developing a starter.

[Jsonnet]: https://jsonnet.org/

<!--more-->

With my departure from Indeed, coworkers asked that I provide monitoring for my open source project.
As I searched around looking for examples to follow, I quickly discovered Jsonnet.
While it appeared to be a powerful tool, I couldn't find any good starters for it.
Many existing projects out there were great references, but lacked set up and direction.
To keep things simple, I started with the [kubernetes-mixin] project structure.

[kubernetes-mixin]: https://github.com/kubernetes-monitoring/kubernetes-mixin

### Fighting through the trough

When I learn something new, I often go through the [Hype Cycle].
At first, there are high expectations for what I'll be able to do with a given tool.
After gaining some familiarity, I dig in.
Then, the trough of disillusionment hits.
Here, I spend most of my time learning (often hands on).
While here, I try not to expect anything to work the first time.
Only that I'm making progress, both iteratively and visibly.
Eventually, I reach the plateau of productivity.
At this point,  I'm familiar enough with the semantics and sharp edges to be productive.

With Jsonnet, I found the trough to be longer than I initially expected.
Like many languages, issues with files were identified by line and character numbers.
Where I ran into more problems was at the command-line tool / language interface.
There were several moments where the output of the jsonnet CLI stumped me.
At one point, I pushed up my changes and gave it a break.
After some needed rest, I was able to track down the issue and was back on track.
(Granted, I was attempting to build **_four_** [Grafana] dashboards my first time through.)

_References were key_ to making it through the trough.
Without them, I would still be working through the pull request.
They can provide great examples, reference points, and even ideas on what you should monitor.

[Hype Cycle]: https://en.wikipedia.org/wiki/Hype_cycle
[Grafana]: https://grafana.com

### Composition

[deps.cloud] is an open source project of mine that helps track, monitor, and connect project dependencies across languages and toolchains.
I built it as a [successor to a previous system] I implemented at Indeed.
Unlike it's predecessor, deps.cloud supports many different languages.
It implements a common set of [gRPC] microservices that can be swapped out or reconfigured.
For example, https://api.deps.cloud is backed by a read-only version of the `tracker` process (for now).
As the operator of that service, I might want a dedicated dashboard or set of alerts for that deployment.

Remember, iterative and visible progress.
When I started the dashboards, I used a similar layout to the kubernetes-mixin project.
Once I had something working and checked in, I started to look at how I could improve it.
For one, I found their format didn't support the composition model I was hoping for.
It used a few tools like [jsonnet-bundler] which allows for package management.
With a few modifications, I was able to get a more modular structure in place.

[deps.cloud]: https://deps.cloud/
[successor to a previous system]: https://mjpitz.com/blog/2020/01/24/building-depscloud/
[gRPC]: https://grpc.io

### jsonnet-monitoring-starter

I created the [jsonnet-monitoring-starter] repository to help others get started with monitoring tools in a declarative way.
Each service in your system is given space for alerts, dashboards, recording rules, and default configuration.

```
└── service-template
    ├── config.libsonnet
    ├── mixin.libsonnet
    ├── alerts
    │   ├── alert-template.libsonnet
    │   └── alerts.libsonnet
    ├── dashboards
    │   ├── dashboard-template.libsonnet
    │   └── dashboards.libsonnet
    └── rules
        ├── rule-template.libsonnet
        └── rules.libsonnet
```

`mixin.libsonnet` allows services to be composed into higher level abstractions.
This is done using the `import` directive in jsonnet.
For an example of how this is done, see any `mixin.libsonnet` file in the repository.
Finally, the starter provides some boilerplate for generating output files.

```
└── pkg
    ├── alerts.jsonnet
    ├── dashboards.jsonnet
    └── rules.jsonnet
```

To see this approach in action, stop on over at [depscloud/deploy] and take a look at the [monitoring] setup there.

[jsonnet-monitoring-starter]: https://github.com/mjpitz/jsonnet-monitoring-starter
[depscloud/deploy]: https://github.com/depscloud/deploy
[monitoring]: https://github.com/depscloud/deploy/tree/main/monitoring

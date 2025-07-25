---
title: "Observability from Scratch"
pubDate: "October 5 2024"
description: |
  Back in February, I found myself quite frustrated with many of the "modern" observability stacks on the open source
  market. At my previous company, my infrastructure engineer spent a good amount of time fighting with the LGTP stack.
  After work, I found myself venting to a friend about how unnecessarily complex the open source ecosystem has become.
  Having worked at startups for the last 4 years, I've seen just how hard it can be to deploy a comprehensive
  observability and business intelligence solution. In this post, I'll discuss my rationale for abandoning many popular
  stacks out there today in favor of one of my own design.

slug: 2024/10/05/observability-from-scratch
---

Back in February, I found myself quite frustrated with many of the "modern" observability stacks on the open source
market. At my previous company, my infrastructure engineer spent a good amount of time fighting with the LGTP stack.
After work, I found myself venting to a friend about how unnecessarily complex the open source ecosystem has become.
Having worked at startups for the last 4 years, I've seen just how hard it can be to deploy a comprehensive
observability and business intelligence solution. In this post, I'll discuss my rationale for abandoning many popular
stacks out there today in favor of one of my own design.

<br/>

_The problem with... LGTM/P_

[Prometheus and its friends][] have brought us far in our observability journey. So credit where credit is due. Thank
you for bringing us as far as you have.

Unfortunately, deploying this system at a startup poses a lot of challenges. Startups are quite often limited in their
operations staff. While adopting stateless services often require limited support, the LGTM/P stack brings in 3 stateful
systems, drastically increasing the demand on your already limited operations team.

Another downside here is that this stack doesn't consider the broader needs of business intelligence. With information
divided among a number of data sources, you need to know where to look to track down information. Higher level metrics
can't be derived without the addition of another datastore.

Despite its downsides, this stack is still heavily used today due to its fantastic community support, and prevalence in
[Kubernetes][].

[Prometheus and its friends]: https://grafana.com/go/webinar/getting-started-with-grafana-lgtm-stack/
[Kubernetes]: https://github.com/kubernetes-monitoring/kubernetes-mixin

<br/>

_The problem with... ElasticStack_

To paraphrase Shakespeare, "Open source, or not open source… that is the question."

Back in August, [Elastic announced][] that ElasticSearch and Kibana would be made open source once again. While I'm a
big proponent of the [AGPL-3.0 license][] for this kind of use case, I still feel stuck in limbo about whether to adopt
them or not. Given they've already changed licenses a number of times, it's hard to say if this one will be the last
one.

On the bright side, some [research][] has been done to investigate how these kinds of license changes have impacted a
company's financial outcome. While research is currently limited by the number of companies with this information
publicly available, I wonder how continued research in this space will impact a company's decision around licensing
later on.

So Elastic was out for me… (at least for now).

[OpenSearch][] was another option, and while I'm generally supportive of forks, Amazon has less trust from me than
Elastic does.

[Elastic announced]:
  https://ir.elastic.co/news/news-details/2024/Elastic-Announces-Open-Source-License-for-Elasticsearch-and-Kibana-Source-Code/default.aspx
[AGPL-3.0 license]: https://fossa.com/blog/open-source-software-licenses-101-agpl-license/
[research]: https://redmonk.com/rstephens/2024/08/26/software-licensing-changes-and-their-impact-on-financial-outcomes/
[OpenSearch]: https://opensearch.org/

<br/>

_What's in a stack?_

Before I began ideating on what a new stack would look like, I first considered my experience with a variety of
solutions out there.

- I really enjoyed working with [Indeed's][] analytics platform. It had some rough edges, but it was key to helping us
  grow throughout my time at the company.
- My experience at [effx][] showed me the inefficiencies in solutions like [Retool][] and [Redash][]. They're OK when
  you're a startup, but pose significant challenges for the security minded.
- At [Storj][], we used [InfluxDB][] which showed me how a project that started with non-[SQL][] based queries found
  itself implementing its own [SQL-like][] language.
- And as I stated earlier, my time at [CrabNebula][] showed me just how complicated the Prometheus stack can get, and
  how much work can go into it.

What was more interesting to me was that we still treat business intelligence (BI) as an entirely different concern, and
even as an entirely different stack. While at Indeed, I saw countless feature requests go into our analytics platform to
support features like more real-time insights, being able to trigger alerts on a metric, different indexing solutions
for fields, you name it. To me, it made sense to try and collapse these stacks into a single solution to reduce the
burden on my future operations teams.

So, the requirements as I saw them were:

- Drop in solution (changing the status quo is hard)
- Import data from production databases (securely… obvi)
- SQL support out-of-box (love it or hate it, everyone knows it)
- Ability to derive higher level metrics (without the addition of another system)
- Real-time-ish (a little delay here is OK, but closer to real-time is always better)
- Single pane of glass (no more confusion about where to go)
- Dashboards & Alerting (support for email, twilio, pagerduty, etc)
- Support a more secure future (start small, build out)
- Extensible data pipeline (add more later as needed)

As far as I can tell, there is no turn-key solution that makes it easy for a small business, like many I've worked at
throughout the years, to get a comprehensive platform off the ground with minimal support. Sure, we could pay for some
third-party services to manage this complexity, but cost is an influencing factor for small businesses. But what do I
know? Maybe I'm asking for too much, but I don't think so.

[Indeed's]: https://indeed.com/
[effx]: https://www.crunchbase.com/organization/effx
[Retool]: https://retool.com/
[Redash]: https://redash.io/
[Storj]: https://www.crunchbase.com/organization/storj
[InfluxDB]: https://www.influxdata.com/index/
[SQL]: https://en.wikipedia.org/wiki/SQL
[SQL-like]: https://docs.influxdata.com/influxdb/v1/query_language/
[CrabNebula]: https://www.crunchbase.com/organization/crabnebula

<br/>

_Storage and persistence_

In 2018, I was talking to a co-worker from our data infrastructure team at Indeed about the things I missed while I was
away. Our [wide-ish events][] system and [analytics platform][] were the biggest ones. That was when he pointed me at
[ClickHouse][]. While it wasn't relevant to my work, I did play around with it, and it offered a very reasonable
alternative for projects beyond work.

Given my experience with other solutions, ClickHouse definitely jumped to the front of the list when setting out to
select a data store for this stack. Beyond my tinkering and experience with other technologies, ClickHouse has seen use
at companies like [Cloudflare][], [Lyft][], [Segment][], and many more.

As I dug in further, ClickHouse started to check a lot of boxes. With support for a number of [SQL drivers][], the
ability to import data from a [wide-range of integrations][], and support for querying data using SQL, and even having
the ability to tier data storage between local disk and object stores, it seemed more and more like the obvious choice.

[wide-ish events]: https://www.youtube.com/watch?v=y0WC1cxLsfo
[analytics platform]: https://www.youtube.com/watch?v=LBDZFtqL-ck
[ClickHouse]: https://clickhouse.com/
[Cloudflare]: https://blog.cloudflare.com/http-analytics-for-6m-requests-per-second-using-clickhouse/
[Lyft]: https://eng.lyft.com/druid-deprecation-and-clickhouse-adoption-at-lyft-120af37651fd
[Segment]: https://segment.com/blog/modernizing-segments-clickhouse-olap-platform/
[SQL drivers]: https://clickhouse.com/docs/en/interfaces/overview
[wide-range of integrations]: https://clickhouse.com/docs/en/integrations

<br/>

_Instrumentation and collection_

In 2020, I stopped working on my [okit][] library because I came across [OpenTelemetry][] (Otel). While my solution went
a little further than theirs did, they wound up addressing my needs at the time. ("Why do I need 3 libraries for
observability?") While it was still early on in development back then, I figured it was worth putting a bookmark in for
later on and to just deal with things for now.

My first use case for Otel was to deploy it as a metrics collection gateway back in December so our edge services
running in Cloudflare could emit metrics back to our control plane. Because Otel speaks HTTP and [gRPC][], we were able
to expose an endpoint and password protect it. This prevents random data from being sent to our backend. The more I
built with Otel, the more it was clear that this system had come a long way since I first found it.

The biggest thing I have come to love about the Otel community is that they meet companies where they're at when it
comes to observability. Regardless of your transport protocol for metrics and traces, Otel has you covered. They support
a wide-range of receivers and logs can be shipped using the same collector process. No code change required.

So I was sold. If I wanted to build a solution that could reach a wide-range of users and use-cases, then it needed to
include Otel. I can honestly say a lot more here, but I'll save that for later.

[okit]: https://code.pitz.tech/mya/okit
[OpenTelemetry]: https://opentelemetry.io/
[gRPC]: https://grpc.io/

<br/>

_A single pane of glass_

Since our storage layer could import data, our presentation layer could focus on fewer tasks. A major influencing factor
here turned out to be the alerting component. While there are a number of solutions on the market today, [Grafana's][]
built-in [alerting][] support is hard to beat. On top of that, we have OIDC support, declarative dashboards, an
extensive community, and the ability to query a number of different sources.

By centralizing our information behind a single pane of glass and data store, we save ourselves a lot of pain later on.
I've seen first hand the efforts companies have taken to centralize information and the work needed to maintain those
pipelines. Even [Charity Majors][] touches on it in her segment discussing Observability 2.0 on [Screaming in the
Cloud][]. She points out that having more sources of information tends to lead to less value.

Finally, Grafana offers an iterative path on security. [Organizations][] offer system operators a means to control
access to data sources, folders, dashboards, and much more. Startups can start small, and build out. They can also
reduce the cognitive burden on your engineers by prioritizing information based on their role.

[Grafana's]: https://grafana.com/
[alerting]: https://grafana.com/docs/grafana/latest/alerting/
[Charity Majors]: https://charity.wtf/
[Screaming in the Cloud]:
  https://www.lastweekinaws.com/podcast/screaming-in-the-cloud/shifting-from-observability-1-0-to-2-0-with-charity-majors/
[Organizations]: https://grafana.com/docs/grafana/latest/administration/organization-management/

<br/>

_Introducing Cognative_

Cognative is a [portmanteau][] that uses an acronym of the technologies involved (see sections above) and the suffix
"native" from the "cloud native" space, meaning "of indigenous origin". It's designed to provide a base layer that your
company can build on top of. OpenTelemetry's collector process enables companies to compose complex data pipelines
without modifying the base tech stack. Want to add a queue before your data hits the warehouse? Feel free to add
whichever queuing technology your organization prefers.

[Deploying][] the stack is relatively easy to do using Docker and a minimal Helm chart is available for deploying to
Kubernetes. As it stands, the solution is ideal for small scale environments but can support plugging in a custom
ClickHouse (such as an [Altinity operator][] instance) and Grafana deployments.

If you're interested or want to learn more, check us out on [GitHub][]! There's still a lot more work to do and plenty
of discussions to have. We want to involve the voices of others from the community early on while keeping the focus of a
simplified stack for BI and Observability in mind.

- Replicating [monitoring-mixins][] discussion
- [Simplify query construction][] in JSONNET, inspired by work from [Justin Mason][]

[portmanteau]: https://www.merriam-webster.com/dictionary/portmanteau
[Deploying]: https://github.com/mjpitz/cognative/blob/main/docs/QUICKSTART.md
[Altinity operator]: https://github.com/Altinity/clickhouse-operator
[GitHub]: https://github.com/mjpitz/cognative
[monitoring-mixins]: https://github.com/mjpitz/cognative/discussions/48
[Simplify query construction]: https://github.com/mjpitz/cognative/pull/57
[Justin Mason]: https://github.com/JustinMason/opentelemetry-collector-exporter-client

<br/>

Until next time. ~ Ciao Bella

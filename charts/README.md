# Charts

While I'm the primary consumer of these charts, I have made them generally available for others to use. You may be able 
to find some of these charts elsewhere, but many of my deployments vary quite a bit from existing ones.

```shell
helm repo add mya https://mya.sh
```

- [`12factor`][12factor-chart] - Easily deploy an application that conforms to 12factor application patterns.
- [`cognative`][cognative-chart] - Deploy the [Cognative][] business intelligence and operations platform.
- [`drone`][drone-chart] - Deploys a [Drone][] server and optionally configure a `digitalocean` or `kubernetes` runner.
- [`gitea`][gitea-chart] - Git with a cup of tea. [Gitea][] is a painless, self-hosted Git Service.
- [`litestream`][litestream-chart] - Easily add a [Litestream][] sidecar to any `Deployment`, `DaemonSet`, or `StatefulSet`.
- [`maddy`][maddy-chart] - Deploys a single-tenant Maddy email server.
- [`raw`][raw-chart] - Deploys raw Kubernetes resources to the cluster.
- [`redis`][redis-chart] - Deploys an inconsistent Redis cluster, intended to be fronted by an [Envoy][] sidecar.
- [`redis-queue`][redis-queue-chart] - Deploy a single durable Redis instance, intended to be used as a work queue.
- [`redis-raft`][redis-raft-chart] - Deploy a consistent, partition-tolerant Redis cluster backed by the Raft consensus protocol.
- [`registry`][registry-chart] - Deploys a replicated container registry, with optional caching provided by `redis`.
- [`renovate`][renovate-chart] - Deploys Renovate for automatically managing your software dependencies.
- [`storj`][storj-chart] - Easily add a Storj S3 Gateway as a sidecar to any `Deployment`, `DaemonSet`, or `StatefulSet`.

[12factor-chart]: 12factor
[cognative-chart]: cognative
[drone-chart]: drone
[gitea-chart]: gitea
[litestream-chart]: litestream
[maddy-chart]: maddy
[raw-chart]: raw
[redis-chart]: redis
[redis-queue-chart]: redis-queue
[redis-raft-chart]: redis-raft
[registry-chart]: registry
[renovate-chart]: renovate
[storj-chart]: storj

[Cognative]: https://mjpitz.github.io/cognative
[Drone]: https://www.drone.io
[Gitea]: https://gitea.com
[Litestream]: https://litestream.io
[Envoy]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis

## License

The contents of this directory are licensed under the `MIT` license.

See the [`LICENSE`](LICENSE) file for more details.

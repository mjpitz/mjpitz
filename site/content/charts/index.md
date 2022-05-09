# Charts

My personal helm charts are provided under the [MIT License][license]. While I'm the primary consumer of these charts, I
have made them generally available for others to use. You may be able to find some of these charts elsewhere, but many
of my deployments vary quite a bit from existing ones.

```text
helm repo add mjpitz https://mjpitz.com
```

- [`auth`][auth-chart] - Deploys a replicated token authorization server for use with the `registry`.
- [`drone`][drone-chart] - Deploys a [Drone][] server and optionally configure a `digitalocean` or `kubernetes` runner.
- [`gitea`][gitea-chart] - Git with a cup of tea. [Gitea][] is a painless, self-hosted Git Service.
- [`litestream`][litestream-chart] - Easily add a [litestream][] sidecar to any `Deployment`, `DaemonSet`, or `StatefulSet`.
- [`maddy`][maddy-chart] - Deploys a single-tenant Maddy email server.
- [`redis`][redis-chart] - Deploys an inconsistent Redis cluster, intended to be fronted by an [envoy][] sidecar.
- [`redis-queue`][redis-queue-chart] - Deploy a single durable Redis instance, intended to be used as a work queue.
- [`redis-raft`][redis-raft-chart] - Deploy a consistent, partition-tolerant Redis cluster backed by the Raft consensus protocol.
- [`registry`][registry-chart] - Deploys a replicated container registry, with optional caching provided by `redis`.
- [`storj`][storj-chart] - Easily add a Storj S3 Gateway as a sidecar to any `Deployment`, `DaemonSet`, or `StatefulSet`.

[license]: https://github.com/mjpitz/mjpitz/tree/main/charts/LICENSE

[auth-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/auth
[drone-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/drone
[gitea-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/gitea
[litestream-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/litestream
[maddy-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/maddy
[redis-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/redis
[redis-queue-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/redis-queue
[redis-raft-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/redis-raft
[registry-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/registry
[storj-chart]: https://github.com/mjpitz/mjpitz/tree/main/charts/storj

[Drone]: https://www.drone.io
[Gitea]: https://gitea.io
[litestream]: https://litestream.io
[envoy]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis

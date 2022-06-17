# Charts

While I'm the primary consumer of these charts, I have made them generally available for others to use. You may be able 
to find some of these charts elsewhere, but many of my deployments vary quite a bit from existing ones.

```shell
helm repo add mjpitz https://mjpitz.com
```

- [`12factor`][12factor-chart] - Easily deploy an application that conforms to 12factor application patterns.
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

[12factor-chart]: 12factor
[auth-chart]: auth
[drone-chart]: drone
[gitea-chart]: gitea
[litestream-chart]: litestream
[maddy-chart]: maddy
[redis-chart]: redis
[redis-queue-chart]: redis-queue
[redis-raft-chart]: redis-raft
[registry-chart]: registry
[storj-chart]: storj

[Drone]: https://www.drone.io
[Gitea]: https://gitea.com
[litestream]: https://litestream.io
[envoy]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis

## License

The contents of this directory are licensed under the `MIT` license.

See the [`LICENSE`](LICENSE) file for more details.

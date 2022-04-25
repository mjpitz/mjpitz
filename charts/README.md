# Charts

My personal helm charts are provided under the [MIT License][license]. While I'm the primary consumer of these charts, I
have made them generally available for others to use. You may be able to find some of these charts elsewhere, but many
of my deployments vary quite a bit from existing ones.

```shell
helm repo add mjpitz https://mjpitz.com
```

- [`auth`][auth-chart] - Deploys a replicated token authorization server for use with the `registry`.
- [`litestream`][litestream-chart] - Easily add a [litestream][] sidecar to any `Deployment`, `DaemonSet`, or `StatefulSet`.
- [`maddy`][maddy-chart] - Deploys a single-tenant Maddy email server.
- [`redis`][redis-chart] - Deploys an inconsistent Redis cluster, intended to be fronted by an [envoy][] sidecar.
- [`registry`][registry-chart] - Deploys a replicated container registry, with optional caching provided by `redis`.
- [`storj`][storj-chart] - Easily add a Storj S3 Gateway as a sidecar to any `Deployment`, `DaemonSet`, or `StatefulSet`.

[license]: LICENSE

[auth-chart]: auth
[litestream-chart]: litestream
[maddy-chart]: maddy
[redis-chart]: redis
[registry-chart]: registry
[storj-chart]: storj

[litestream]: https://litestream.io
[envoy]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis

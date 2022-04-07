# Charts

Charts are provided under the [MIT License](LICENSE).

```shell
helm repo add mjpitz https://mjpitz.com
```

- [`auth`](auth) - Deploys a replicated token authorization server for use with the `registry`.
- [`maddy`](maddy) - Deploys a maddy email server.
- [`redis`](redis) - Deploys an inconsistent Redis cluster, intended to be fronted by an [envoy][] sidecar.
- [`registry`](registry) - Deploys a replicated container registry, with optional caching provided by `redis`.
- [`storj`](storj) - Easily add a Storj S3 Gateway as a sidecar to any `Deployment`, `DaemonSet`, or `StatefulSet`.

[envoy]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis

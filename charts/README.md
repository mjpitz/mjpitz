# Charts

```shell
helm repo add mjpitz https://mjpitz.com
```

- [`auth`](auth) - Deploys a replicated token authorization server for use with the `registry`.
- [`redis`](redis) - Deploys an inconsistent Redis cluster, intended to be fronted by an [envoy][] sidecar.
- [`registry`](registry) - Deploys a replicated container registry, with optional caching provided by `redis`.

[envoy]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis

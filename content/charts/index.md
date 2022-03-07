# Charts

```shell
helm repo add mjpitz https://mjpitz.com
```

- [`auth`](https://github.com/mjpitz/mjpitz/tree/main/charts/auth) - Deploys a replicated token authorization server for use with the `registry`.
- [`redis`](https://github.com/mjpitz/mjpitz/tree/main/charts/redis) - Deploys an inconsistent Redis cluster, intended to be fronted by an [envoy][] sidecar.
- [`registry`](https://github.com/mjpitz/mjpitz/tree/main/charts/registry) - Deploys a replicated container registry, with optional caching provided by `redis`.

[envoy]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis

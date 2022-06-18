# Monitoring

This directory contains the various alerts, dashboards, metrics, and rules I use for monitor and observe various 
infrastructure components. These are built so that service catalogs can easily collect the links to all related
components that should be monitored.

- [drone](drone) - Provides common alerts, dashboards, metrics, and rules for [Drone][] deployments.
- [gitea](gitea) - Provides common alerts, dashboards, metrics, and rules for [Gitea][] deployments.
- [go](go) - Provides common alerts, dashboards, metrics, and rules for any [golang][] process.
- [grpc](grpc) - Provides common alerts, dashboards, metrics, and rules for any [grpc][] process.
- [ingress-nginx](ingress-nginx) - Provides common alerts, dashboards, metrics, and rules for [ingress-nginx][] deployments.
- [litestream](litestream) - Provides common alerts, dashboards, metrics, and rules for [litestream][] deployments.
- [maddy](maddy) - Provides common alerts, dashboards, metrics, and rules for maddy deployments.
- [redis](redis) - Provides common alerts, dashboards, metrics, and rules for redis deployments.
- [registry](registry) - Provides common alerts, dashboards, metrics, and rules for registry deployments.

[Drone]: https://www.drone.io
[Gitea]: https://gitea.com
[golang]: https://go.dev/
[grpc]: https://grpc.io/
[ingress-nginx]: https://kubernetes.github.io/ingress-nginx
[litestream]: https://litestream.io

## Targets

There are four operations that can be performed from this directory. Every operation is intended to operate on a single
`TARGET` at a time. When invoking the operation, simply pass in the `TARGET=name` argument to build the named set of
alerts, dashboards, and rules.

```shell
make format TARGET=drone
make lint TARGET=drone
make build TARGET=drone
make sync TARGET=drone
```

To build all available targets, invoke `make grafana/build` from the root of this repository.

## License

The contents of this directory are licensed under the `MIT` license.

See the [`LICENSE`](LICENSE) file for more details.

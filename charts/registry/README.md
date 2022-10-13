# registry

![Version: 22.4.5](https://img.shields.io/badge/Version-22.4.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.8.0](https://img.shields.io/badge/AppVersion-2.8.0-informational?style=flat-square)

Easily deploy and configure a production-ready container registry backed by your favorite cloud storage provider.
Optionally add a highly-available, partition-tolerant Redis cache that's fronted by Envoy.

## Maintainers

| Name          | Email | Url                  |
| ------------- | ----- | -------------------- |
| Mya Pitzeruse |       | <https://mjpitz.com> |

## Source Code

- <https://github.com/distribution/distribution>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/registry>

## Requirements

| Repository         | Name  | Version |
| ------------------ | ----- | ------- |
| https://mjpitz.com | auth  | 22.4.1  |
| https://mjpitz.com | redis | 22.4.6  |
| https://mjpitz.com | storj | 22.4.3  |

## Values

| Key                                        | Type   | Default                                | Description                                                                                                                                                       |
| ------------------------------------------ | ------ | -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                                   | Specify affinity rules for the pods.                                                                                                                              |
| auth.config.token.realm                    | string | `""`                                   | The realm used for authentication.                                                                                                                                |
| auth.config.token.service                  | string | `""`                                   | The service authenticating on behalf of the end user.                                                                                                             |
| auth.enabled                               | bool   | `false`                                | Whether to enable token authentication and authorization for the server.                                                                                          |
| autoscaling.enabled                        | bool   | `false`                                | Enable autoscaling for the deployment.                                                                                                                            |
| autoscaling.maxReplicas                    | int    | `100`                                  | Specify the maximum number of replicas.                                                                                                                           |
| autoscaling.minReplicas                    | int    | `1`                                    | Specify the minimum number of replicas.                                                                                                                           |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                                   | Specify the percent CPU utilization that causes the pods to autoscale.                                                                                            |
| config.compatibility                       | object | `{}`                                   | Used to configure older / deprecated features.                                                                                                                    |
| config.http.secret                         | string | `""`                                   | A common secret shared between the registry servers.                                                                                                              |
| config.log.accesslog.disabled              | bool   | `true`                                 | Disable access log logging.                                                                                                                                       |
| config.log.formatter                       | string | `"json"`                               | Specifies the log format.                                                                                                                                         |
| config.log.level                           | string | `"info"`                               | - Specify the minimum log level.                                                                                                                                  |
| config.middleware                          | object | `{}`                                   | Configure the middleware layer such as a Cloudfront CDN for host.                                                                                                 |
| config.notifications                       | object | `{}`                                   | Configure the docker notification layer.                                                                                                                          |
| config.proxy                               | object | `{}`                                   | Allows the registry to be configured as a pull-through cache to Docker Hub.                                                                                       |
| config.reporting                           | object | `{}`                                   | Configure the reporting layer such as the bugsnag and newrelic endpoints.                                                                                         |
| config.storage                             | object | `{}`                                   | Configures the persistence layer for blobs.                                                                                                                       |
| config.validation                          | object | `{}`                                   | Configure validation rules for image manifests.                                                                                                                   |
| externalConfig.secretRef.name              | string | `""`                                   | Specify the name of the secret containing the raw configuration.                                                                                                  |
| extraVolumeMounts                          | list   | `[]`                                   | Add additional volume mounts to the pod.                                                                                                                          |
| extraVolumes                               | list   | `[]`                                   | Add additional volumes to the pod.                                                                                                                                |
| fullnameOverride                           | string | `""`                                   | Override the full name of the release.                                                                                                                            |
| gc.enabled                                 | bool   | `false`                                | Whether to enable the garbage collection process. This is not supported when using the Storj sidecar.                                                             |
| gc.schedule                                | string | `"@daily"`                             | How frequently to run the garbage collection process.                                                                                                             |
| image.pullPolicy                           | string | `"IfNotPresent"`                       | The pull policy to use for the registry image.                                                                                                                    |
| image.repository                           | string | `"distribution/distribution"`          | The repository hosting the container registry image.                                                                                                              |
| image.tag                                  | string | `""`                                   | Overrides the image tag whose default is the chart appVersion.                                                                                                    |
| imagePullSecrets                           | list   | `[]`                                   | Specify the secret containing the registry credentials.                                                                                                           |
| ingress.annotations                        | object | `{}`                                   | Specify annotations for the ingress.                                                                                                                              |
| ingress.enabled                            | bool   | `false`                                | Configure the ingress for the registry.                                                                                                                           |
| ingress.hosts[0].host                      | string | `"chart-example.local"`                | Specify the domain host for the ingress.                                                                                                                          |
| ingress.tls                                | list   | `[]`                                   | Configure TLS for the ingress.                                                                                                                                    |
| metrics.serviceMonitor.enabled             | bool   | `false`                                | Add a Prometheus ServiceMonitor that scrapes the registry deployment.                                                                                             |
| metrics.serviceMonitor.interval            | string | `"10s"`                                | How frequently prometheus should pull metrics from your registry deployment.                                                                                      |
| nameOverride                               | string | `""`                                   | Override the name of the release.                                                                                                                                 |
| nodeSelector                               | object | `{}`                                   | Specify the node selector used to control which nodes registry pods are deployed to.                                                                              |
| podAnnotations                             | object | `{}`                                   | Annotations to add to the pod, typically used for assume roles.                                                                                                   |
| podSecurityContext                         | object | `{}`                                   | Specify the security context for the entire pod.                                                                                                                  |
| redis.config.db                            | int    | `0`                                    | What redis database to connect to.                                                                                                                                |
| redis.config.dialtimeout                   | string | `"200ms"`                              | The timeout to use when connecting to redis.                                                                                                                      |
| redis.config.pool.idletimeout              | string | `"300s"`                               | How long before a connection is marked idle.                                                                                                                      |
| redis.config.pool.maxactive                | int    | `64`                                   | The maximum number of active connections.                                                                                                                         |
| redis.config.pool.maxidle                  | int    | `16`                                   | The maximum number of idle connections.                                                                                                                           |
| redis.config.readtimeout                   | string | `"200ms"`                              | The timeout used when reading data from redis.                                                                                                                    |
| redis.config.writetimeout                  | string | `"200ms"`                              | The timeout used when writing data to redis.                                                                                                                      |
| redis.enabled                              | bool   | `false`                                | Whether to enable a partitioned Redis cluster for caching.                                                                                                        |
| replicaCount                               | int    | `1`                                    | The number of registry replicas to deploy.                                                                                                                        |
| resources                                  | object | `{}`                                   | Specify the resources for the pod.                                                                                                                                |
| securityContext                            | object | `{}`                                   | Specify the security context for the `registry` container.                                                                                                        |
| service.type                               | string | `"ClusterIP"`                          | Specify the type of service to create.                                                                                                                            |
| serviceAccount.annotations                 | object | `{}`                                   | Annotations to add to the service account.                                                                                                                        |
| serviceAccount.create                      | bool   | `true`                                 | Specifies whether a service account should be created.                                                                                                            |
| serviceAccount.name                        | string | `""`                                   | The name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                           |
| storj.config.accessGrant                   | string | `""`                                   | The access grant that enables communication with Storj.                                                                                                           |
| storj.config.accessKeyId                   | string | `""`                                   | A shared access key id for the Storj gateway sidecar.                                                                                                             |
| storj.config.bucket                        | string | `""`                                   | The name of your Storj bucket to store image layers in.                                                                                                           |
| storj.config.region                        | string | `""`                                   | The region of the Storj satellite.                                                                                                                                |
| storj.config.secretAccessKey               | string | `""`                                   | A shared secret access key for the Storj gateway sidecar.                                                                                                         |
| storj.enabled                              | bool   | `false`                                | Configure the registry to use Storj as a backend. Assuming our pull request to the docker distribution is accepted, this configuration block will likely go away. |
| tolerations                                | list   | `[]`                                   | Specify taints that the registry pods are willing to tolerate.                                                                                                    |
| ui.config.auth.basic.password              | string | `""`                                   | Specify the password for basic authentication.                                                                                                                    |
| ui.config.auth.basic.username              | string | `""`                                   | Specify the username for basic authentication.                                                                                                                    |
| ui.config.auth.token.password              | string | `""`                                   | Specify the password for the token based authentication.                                                                                                          |
| ui.config.auth.token.username              | string | `""`                                   | Specify the username for token based authentication.                                                                                                              |
| ui.config.domain                           | string | `""`                                   | Configure the domain for the UI to render push/pull.                                                                                                              |
| ui.enabled                                 | bool   | `false`                                | Whether to enable a UI for exploring the registry.                                                                                                                |
| ui.image.pullPolicy                        | string | `"IfNotPresent"`                       | The policy used when pulling the UI image.                                                                                                                        |
| ui.image.repository                        | string | `"klausmeyer/docker-registry-browser"` | The image that contains the registry UI.                                                                                                                          |
| ui.image.tag                               | string | `"1.5.0"`                              | The tag of the image that contains the registry UI.                                                                                                               |

---

Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)

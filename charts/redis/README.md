# redis

![Version: 22.3.4](https://img.shields.io/badge/Version-22.3.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.2.6](https://img.shields.io/badge/AppVersion-6.2.6-informational?style=flat-square)

Deploy a highly-available, partition-tolerant Redis cluster fronted by an envoy sidecar. Envoy partitions keys among
members of the cluster using a consistent hashing algorithm making it great as a best-effort cache.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/redis/redis>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/redis>

## Values

| Key                                        | Type   | Default                           | Description                                                                                                             |
| ------------------------------------------ | ------ | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                              | Specify affinity rules for the pods.                                                                                    |
| autoscaling.enabled                        | bool   | `false`                           | Enable autoscaling for the deployment.                                                                                  |
| autoscaling.maxReplicas                    | int    | `100`                             | Specify the maximum number of replicas.                                                                                 |
| autoscaling.minReplicas                    | int    | `1`                               | Specify the minimum number of replicas.                                                                                 |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                              | Specify the percent CPU utilization that causes the pods to autoscale.                                                  |
| cluster.enabled                            | bool   | `true`                            | Enable the Envoy cluster.                                                                                               |
| cluster.image.pullPolicy                   | string | `"IfNotPresent"`                  | The pull policy used when pulling the Envoy proxy.                                                                      |
| cluster.image.repository                   | string | `"envoyproxy/envoy"`              | The repository hosting the Envoy proxy.                                                                                 |
| cluster.image.tag                          | string | `"v1.21-latest"`                  | The version of Envoy to run.                                                                                            |
| config.data.appendOnlyFile.enabled         | bool   | `false`                           | Whether to enable an append-only file.                                                                                  |
| config.data.appendOnlyFile.fsync           | string | `"everysec"`                      | When fsyncs should occur when using an append-only file.                                                                |
| config.data.directory                      | string | `""`                              | Where the append-only file and snapshots should be stored.                                                              |
| config.data.snapshot.compression           | bool   | `true`                            | Compress the snapshot.                                                                                                  |
| config.data.snapshot.enabled               | bool   | `false`                           | Whether to enable snapshots.                                                                                            |
| config.data.snapshot.schedules             | list   | `[[3600,1],[300,100],[60,10000]]` | When to take a snapshot. [ seconds, key changes ]                                                                       |
| config.databases                           | int    | `1`                               | How many databases to make available.                                                                                   |
| config.maxMemory.evictionPolicy            | string | `"allkeys-lru"`                   | The eviction policy to use when the maximum memory is reached or exceeded.                                              |
| config.maxMemory.size                      | string | `""`                              | The number of bytes representing the maximum amount of memory that can be consumed.                                     |
| config.password                            | string | `""`                              | Specify the password used for authentication.                                                                           |
| config.username                            | string | `""`                              | Specify the username used for authentication.                                                                           |
| externalConfig.secretRef.name              | string | `""`                              | Specify the name of the secret containing the raw configuration.                                                        |
| extraVolumeMounts                          | list   | `[]`                              | Add additional volume mounts to the pod.                                                                                |
| extraVolumes                               | list   | `[]`                              | Add additional volumes to the pod.                                                                                      |
| fullnameOverride                           | string | `""`                              | Override the full name of the release.                                                                                  |
| image.pullPolicy                           | string | `"IfNotPresent"`                  | The pull policy to use for the registry image.                                                                          |
| image.repository                           | string | `"redis"`                         | The repository hosting the redis image.                                                                                 |
| image.tag                                  | string | `""`                              | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                           | list   | `[]`                              | Specify the secret containing the registry credentials.                                                                 |
| metrics.serviceMonitor.enabled             | bool   | `false`                           | Add a Prometheus ServiceMonitor that scrapes the registry deployment.                                                   |
| metrics.serviceMonitor.interval            | string | `"10s"`                           | How frequently prometheus should pull metrics from your registry deployment.                                            |
| nameOverride                               | string | `""`                              | Override the name of the release.                                                                                       |
| nodeSelector                               | object | `{}`                              | Specify the node selector used to control which nodes registry pods are deployed to.                                    |
| podAnnotations                             | object | `{}`                              | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext                         | object | `{}`                              | Specify the security context for the entire pod.                                                                        |
| replicaCount                               | int    | `1`                               | The number of redis instances to deploy.                                                                                |
| resources                                  | object | `{}`                              | Specify the resources for the pod.                                                                                      |
| securityContext                            | object | `{}`                              | Specify the security context for the `redis` container.                                                                 |
| serviceAccount.annotations                 | object | `{}`                              | Annotations to add to the service account.                                                                              |
| serviceAccount.create                      | bool   | `true`                            | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name                        | string | `""`                              | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                                | list   | `[]`                              | Specify taints that the registry pods are willing to tolerate.                                                          |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

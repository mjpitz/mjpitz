# redis-queue

![Version: 22.4.2](https://img.shields.io/badge/Version-22.4.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.2.6](https://img.shields.io/badge/AppVersion-6.2.6-informational?style=flat-square)

Deploy a single durable Redis instance, intended to be used as a work queue.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/redis/redis>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/redis-queue>

## Values

| Key                                | Type   | Default                           | Description                                                                                                             |
| ---------------------------------- | ------ | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                           | object | `{}`                              | Specify affinity rules for the pods.                                                                                    |
| config.data.appendOnlyFile.enabled | bool   | `true`                            | Whether to enable an append-only file.                                                                                  |
| config.data.appendOnlyFile.fsync   | string | `"everysec"`                      | When fsyncs should occur when using an append-only file.                                                                |
| config.data.directory              | string | `"/data"`                         | Where the append-only file and snapshots should be stored.                                                              |
| config.data.snapshot.compression   | bool   | `true`                            | Compress the snapshot.                                                                                                  |
| config.data.snapshot.enabled       | bool   | `false`                           | Whether to enable snapshots.                                                                                            |
| config.data.snapshot.schedules     | list   | `[[3600,1],[300,100],[60,10000]]` | When to take a snapshot. [ seconds, key changes ]                                                                       |
| config.databases                   | int    | `16`                              | How many databases to make available.                                                                                   |
| config.maxMemory.evictionPolicy    | string | `"allkeys-lru"`                   | The eviction policy to use when the maximum memory is reached or exceeded.                                              |
| config.maxMemory.size              | string | `""`                              | The number of bytes representing the maximum amount of memory that can be consumed.                                     |
| config.password                    | string | `""`                              | Specify the password used for authentication.                                                                           |
| config.username                    | string | `""`                              | Specify the username used for authentication.                                                                           |
| externalConfig.secretRef.name      | string | `""`                              | Specify the name of the secret containing the raw configuration.                                                        |
| extraVolumeMounts                  | list   | `[]`                              | Add additional volume mounts to the pod.                                                                                |
| extraVolumes                       | list   | `[]`                              | Add additional volumes to the pod.                                                                                      |
| fullnameOverride                   | string | `""`                              | Override the full name of the release.                                                                                  |
| image.pullPolicy                   | string | `"IfNotPresent"`                  | The pull policy to use for the image.                                                                                   |
| image.repository                   | string | `"img.pitz.tech/mya/redis"`       | The repository hosting the redis image.                                                                                 |
| image.tag                          | string | `"6.2.7-alpine"`                  | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                   | list   | `[]`                              | Specify the secret containing the registry credentials.                                                                 |
| metrics.serviceMonitor.enabled     | bool   | `false`                           | Add a Prometheus ServiceMonitor that scrapes the service.                                                               |
| metrics.serviceMonitor.interval    | string | `"10s"`                           | How frequently prometheus should pull metrics from your service.                                                        |
| nameOverride                       | string | `""`                              | Override the name of the release.                                                                                       |
| nodeSelector                       | object | `{}`                              | Specify the node selector used to control which nodes pods are deployed to.                                             |
| persistence.accessMode             | string | `"ReadWriteOnce"`                 | Configure the access mode of the volume.                                                                                |
| persistence.enabled                | bool   | `true`                            | Enable persistence for this deployment.                                                                                 |
| persistence.existingClaim          | string | `""`                              | Specify the name of an existing PersistentVolumeClaim to use.                                                           |
| persistence.resources.storage      | string | `"10Gi"`                          | Specify the size of the volume.                                                                                         |
| persistence.storageClass           | string | `""`                              | Specify the storage class that should provision this claim.                                                             |
| podAnnotations                     | object | `{}`                              | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext                 | object | `{}`                              | Specify the security context for the entire pod.                                                                        |
| resources                          | object | `{}`                              | Specify the resources for the pod.                                                                                      |
| securityContext                    | object | `{}`                              | Specify the security context for the `redis-queue` container.                                                           |
| service.annotations                | object | `{}`                              | Annotations to add to the service, typically used for ingress control.                                                  |
| serviceAccount.annotations         | object | `{}`                              | Annotations to add to the service account.                                                                              |
| serviceAccount.create              | bool   | `true`                            | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name                | string | `""`                              | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                        | list   | `[]`                              | Specify taints that the pods are willing to tolerate.                                                                   |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

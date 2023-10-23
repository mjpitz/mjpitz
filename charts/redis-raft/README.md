# redis-raft

![Version: 22.5.3](https://img.shields.io/badge/Version-22.5.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.2.6](https://img.shields.io/badge/AppVersion-6.2.6-informational?style=flat-square)

Deploy a consistent, partition-tolerant Redis cluster backed by the Raft consensus protocol. All supported commands
are executed in a strongly-consistent manner. See the
[RedisRaft](https://github.com/RedisLabs/redisraft/blob/master/docs/Using.md#supported-commands) documentation for
more information about supported commands.

## Maintainers

| Name          | Email | Url                  |
| ------------- | ----- | -------------------- |
| Mya Pitzeruse |       | <https://mjpitz.com> |

## Source Code

- <https://github.com/redis/redis>
- <https://github.com/RedisLabs/redisraft>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/redis-raft>

## Values

| Key                             | Type   | Default                          | Description                                                                                                             |
| ------------------------------- | ------ | -------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                        | object | `{}`                             | Specify affinity rules for the pods.                                                                                    |
| extraVolumeMounts               | list   | `[]`                             | Add additional volume mounts to the pod.                                                                                |
| extraVolumes                    | list   | `[]`                             | Add additional volumes to the pod.                                                                                      |
| fullnameOverride                | string | `""`                             | Override the full name of the release.                                                                                  |
| image.pullPolicy                | string | `"IfNotPresent"`                 | The pull policy to use for the image.                                                                                   |
| image.repository                | string | `"img.pitz.tech/mya/redis-raft"` | The repository hosting the redis image.                                                                                 |
| image.tag                       | string | `"22.5.0-alpine"`                | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                | list   | `[]`                             | Specify the secret containing the registry credentials.                                                                 |
| metrics.serviceMonitor.enabled  | bool   | `false`                          | Add a Prometheus ServiceMonitor that scrapes the deployment.                                                            |
| metrics.serviceMonitor.interval | string | `"10s"`                          | How frequently prometheus should pull metrics from your deployment.                                                     |
| nameOverride                    | string | `""`                             | Override the name of the release.                                                                                       |
| nodeSelector                    | object | `{}`                             | Specify the node selector used to control which nodes pods are deployed to.                                             |
| persistence.accessMode          | string | `"ReadWriteOnce"`                | Configure the access mode of the volume.                                                                                |
| persistence.enabled             | bool   | `true`                           | Enable persistence for this deployment.                                                                                 |
| persistence.existingClaim       | string | `""`                             | Specify the name of an existing PersistentVolumeClaim to use.                                                           |
| persistence.resources.storage   | string | `"10Gi"`                         | Specify the size of the volume.                                                                                         |
| persistence.storageClass        | string | `""`                             | Specify the storage class that should provision this claim.                                                             |
| podAnnotations                  | object | `{}`                             | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext              | object | `{}`                             | Specify the security context for the entire pod.                                                                        |
| replicaCount                    | int    | `1`                              |                                                                                                                         |
| resources                       | object | `{}`                             | Specify the resources for the pod.                                                                                      |
| securityContext                 | object | `{}`                             | Specify the security context for the `redis-raft` container.                                                            |
| service.annotations             | object | `{}`                             | Annotations to add to the service, typically used for ingress control.                                                  |
| serviceAccount.annotations      | object | `{}`                             | Annotations to add to the service account.                                                                              |
| serviceAccount.create           | bool   | `true`                           | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name             | string | `""`                             | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                     | list   | `[]`                             | Specify taints that the pods are willing to tolerate.                                                                   |

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

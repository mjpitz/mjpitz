# maddy

![Version: 22.4.1](https://img.shields.io/badge/Version-22.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.5.4](https://img.shields.io/badge/AppVersion-0.5.4-informational?style=flat-square)

Easily deploy and configure a maddy mail server. This chart handles a fair bit of setup, however, additional work
needs to be done to properly configure all the DNS records. For a complete guide on setting up DNS for maddy, see the
user guide: https://maddy.email/tutorials/setting-up/

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/foxcpp/maddy>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/maddy>

## Values

| Key                                        | Type   | Default                   | Description                                                                                                             |
| ------------------------------------------ | ------ | ------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                      | Specify affinity rules for the pods.                                                                                    |
| autoscaling.enabled                        | bool   | `false`                   | Enable autoscaling for the deployment.                                                                                  |
| autoscaling.maxReplicas                    | int    | `100`                     | Specify the maximum number of replicas.                                                                                 |
| autoscaling.minReplicas                    | int    | `1`                       | Specify the minimum number of replicas.                                                                                 |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                      | Specify the percent CPU utilization that causes the pods to autoscale.                                                  |
| config.database.dsn                        | string | `""`                      | Configure the DSN used to connect to a Postgres database.                                                               |
| config.domains.mx                          | string | `""`                      | Configure the mx domain used by the system. This _should_ align with the ingress address for the service.               |
| config.domains.primary                     | string | `""`                      | Configure the primary email domain that is managed by this server.                                                      |
| config.tls.certPath                        | string | `""`                      | Configure the full chain certificate path for TLS.                                                                      |
| config.tls.keyPath                         | string | `""`                      | Configure the private key path for TLS.                                                                                 |
| externalConfig.secretRef.name              | string | `""`                      | Specify the name of the secret containing the raw configuration.                                                        |
| extraVolumeMounts                          | list   | `[]`                      | Add additional volume mounts to the pod.                                                                                |
| extraVolumes                               | list   | `[]`                      | Add additional volumes to the pod.                                                                                      |
| fullnameOverride                           | string | `""`                      | Override the full name of the release.                                                                                  |
| image.pullPolicy                           | string | `"IfNotPresent"`          | The pull policy to use for the image.                                                                                   |
| image.repository                           | string | `"foxcpp/maddy"`          | The repository hosting the email server image.                                                                          |
| image.tag                                  | string | `""`                      | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                           | list   | `[]`                      | Specify the secret containing the registry credentials.                                                                 |
| metrics.serviceMonitor.enabled             | bool   | `false`                   | Add a Prometheus ServiceMonitor that scrapes the registry deployment.                                                   |
| metrics.serviceMonitor.interval            | string | `"10s"`                   | How frequently prometheus should pull metrics from your registry deployment.                                            |
| mta_sts.enabled                            | bool   | `false`                   | Whether to enable MTA-STS to proactively protect against attacks.                                                       |
| mta_sts.image.pullPolicy                   | string | `"IfNotPresent"`          | The pull policy to use for the nginx image.                                                                             |
| mta_sts.image.repository                   | string | `"nginx"`                 | The repository hosting the nginx server image.                                                                          |
| mta_sts.image.tag                          | string | `"1.21-alpine"`           | Configure the version of nginx to run.                                                                                  |
| mta_sts.ingress.annotations                | object | `{}`                      | Specify annotations for the ingress.                                                                                    |
| mta_sts.ingress.enabled                    | bool   | `false`                   | Configure an ingress for the MTA-STS well-known configuration.                                                          |
| mta_sts.ingress.hosts[0].host              | string | `"chart-example.local"`   | Specify the domain host for the ingress.                                                                                |
| mta_sts.ingress.tls                        | list   | `[]`                      | Configure TLS for the ingress.                                                                                          |
| nameOverride                               | string | `""`                      | Override the name of the release.                                                                                       |
| nodeSelector                               | object | `{}`                      | Specify the node selector used to control which nodes registry pods are deployed to.                                    |
| persistence.accessMode                     | string | `"ReadWriteOnce"`         | Configure the access mode of the volume.                                                                                |
| persistence.enabled                        | bool   | `true`                    | Enable persistence for this deployment. This will configure a SQLite driver for storing information.                    |
| persistence.existingClaim                  | string | `""`                      | Specify the name of an existing PersistentVolumeClaim to use.                                                           |
| persistence.resources.storage              | string | `"10Gi"`                  | Specify the size of the volume.                                                                                         |
| persistence.storageClass                   | string | `""`                      | Specify the storage class that should provision this claim.                                                             |
| podAnnotations                             | object | `{}`                      | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext                         | object | `{}`                      | Specify the security context for the entire pod.                                                                        |
| replicaCount                               | int    | `1`                       | The number of registry replicas to deploy.                                                                              |
| resources                                  | object | `{}`                      | Specify the resources for the pod.                                                                                      |
| rspamd.enabled                             | bool   | `true`                    | Whether to enable rspamd to handle spam assignment.                                                                     |
| rspamd.image.pullPolicy                    | string | `"IfNotPresent"`          | The pull policy to use for the rspamd image.                                                                            |
| rspamd.image.repository                    | string | `"ghcr.io/mjpitz/rspamd"` | The repository hosting the rspamd image                                                                                 |
| rspamd.image.tag                           | string | `"22.4.0-alpine"`         | Configure the container version of rspamd to run.                                                                       |
| securityContext                            | object | `{}`                      | Specify the security context for the `registry` container.                                                              |
| service.annotations                        | object | `{}`                      | Annotations to add to the service, typically used for ingress control.                                                  |
| service.type                               | string | `"LoadBalancer"`          | Specify the type of service to create.                                                                                  |
| serviceAccount.annotations                 | object | `{}`                      | Annotations to add to the service account.                                                                              |
| serviceAccount.create                      | bool   | `true`                    | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name                        | string | `""`                      | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                                | list   | `[]`                      | Specify taints that the registry pods are willing to tolerate.                                                          |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

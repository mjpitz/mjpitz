# clickhouse

![Version: 0.2403.0](https://img.shields.io/badge/Version-0.2403.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

(BETA) Deploy a standalone Clickhouse instance. ClickHouse is a high-performance, column-oriented SQL database
management system (DBMS) for online analytical processing (OLAP).

## Maintainers

| Name                  | Email | Url                                   |
| --------------------- | ----- | ------------------------------------- |
| Mya Pitzeruse         |       | <https://mya.sh>                      |
| The cognative authors |       | <https://github.com/mjpitz/cognative> |

## Values

| Key                           | Type   | Default                          | Description                                                                                                             |
| ----------------------------- | ------ | -------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                      | object | `{}`                             | Specify affinity rules for the pods.                                                                                    |
| auth.password                 | string | `"clickhouse"`                   | Specify the password used to authenticate with the clickhouse cluster.                                                  |
| auth.username                 | string | `"clickhouse"`                   | Specify the username used to authenticate with the clickhouse cluster.                                                  |
| fullnameOverride              | string | `""`                             | Override the full name of the release.                                                                                  |
| image.pullPolicy              | string | `"IfNotPresent"`                 | The pull policy to use for the image.                                                                                   |
| image.repository              | string | `"clickhouse/clickhouse-server"` | The repository hosting the clickhouse image.                                                                            |
| image.tag                     | float  | `24.2`                           | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets              | list   | `[]`                             | Specify the secret containing the registry credentials.                                                                 |
| nameOverride                  | string | `""`                             | Override the name of the release.                                                                                       |
| nodeSelector                  | object | `{}`                             | Specify the node selector used to control which nodes pods are deployed to.                                             |
| persistence.accessMode        | string | `"ReadWriteOnce"`                | Configure the access mode of the volume.                                                                                |
| persistence.annotations       | object | `{}`                             | Provide additional annotations to attach to the volume claim.                                                           |
| persistence.enabled           | bool   | `true`                           | Enable persistence for this deployment.                                                                                 |
| persistence.existingClaim     | string | `""`                             | Specify the name of an existing PersistentVolumeClaim to use.                                                           |
| persistence.labels            | object | `{}`                             | Provide additional labels to attach to the volume claim.                                                                |
| persistence.resources.storage | string | `"10Gi"`                         | Specify the size of the volume.                                                                                         |
| persistence.storageClass      | string | `""`                             | Specify the storage class that should provision this claim.                                                             |
| podAnnotations                | object | `{}`                             | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext            | object | `{}`                             | Specify the security context for the entire pod.                                                                        |
| resources                     | object | `{}`                             | Specify the resources for the pod.                                                                                      |
| securityContext               | object | `{}`                             | Specify the security context for the `redis-raft` container.                                                            |
| service.annotations           | object | `{}`                             | Annotations to add to the service, typically used for ingress control.                                                  |
| serviceAccount.annotations    | object | `{}`                             | Annotations to add to the service account.                                                                              |
| serviceAccount.create         | bool   | `true`                           | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name           | string | `""`                             | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                   | list   | `[]`                             | Specify taints that the pods are willing to tolerate.                                                                   |

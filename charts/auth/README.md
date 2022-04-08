# auth

![Version: 22.4.0](https://img.shields.io/badge/Version-22.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.6.0](https://img.shields.io/badge/AppVersion-1.6.0-informational?style=flat-square)

Deploy a container registry token authorization server. Easily add authentication and authorization to your container
registry and control what images authenticated and unauthenticated users are allowed to pull.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/cesanta/docker_auth>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/auth>

## Values

| Key                                        | Type   | Default                 | Description                                                                                                             |
| ------------------------------------------ | ------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                    | Specify affinity rules for the pods.                                                                                    |
| autoscaling.enabled                        | bool   | `false`                 | Enable autoscaling for the deployment.                                                                                  |
| autoscaling.maxReplicas                    | int    | `100`                   | Specify the maximum number of replicas.                                                                                 |
| autoscaling.minReplicas                    | int    | `1`                     | Specify the minimum number of replicas.                                                                                 |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                    | Specify the percent CPU utilization that causes the pods to autoscale.                                                  |
| config.acl                                 | list   | `[]`                    | Control what users are able to do. Access is denied by default.                                                         |
| config.acl_mongo                           | object | `{}`                    | Configure Mongo authorization.                                                                                          |
| config.acl_xorm                            | object | `{}`                    | Configure SQL authorization.                                                                                            |
| config.casbin_authz                        | object | `{}`                    | Configure casbin authorization.                                                                                         |
| config.ext_auth                            | object | `{}`                    | Configure external authentication.                                                                                      |
| config.ext_authz                           | object | `{}`                    | Configure external authorization.                                                                                       |
| config.github_auth                         | object | `{}`                    | Configure GitHub authentication.                                                                                        |
| config.gitlab_auth                         | object | `{}`                    | Configure GitLab authentication.                                                                                        |
| config.google_auth                         | object | `{}`                    | Configure Google authentication.                                                                                        |
| config.ldap_auth                           | object | `{}`                    | Configure LDAP authentication.                                                                                          |
| config.mongo_auth                          | object | `{}`                    | Configure Mongo authentication.                                                                                         |
| config.oidc_auth                           | object | `{}`                    | Configure OIDC authentication.                                                                                          |
| config.token.certificate                   | string | `""`                    | The path to the certificate used for verifying tokens.                                                                  |
| config.token.expiration                    | int    | `900`                   | Configure the expiration.                                                                                               |
| config.token.issuer                        | string | `"Acme Auth Server"`    | Configure the name of the token issuer.                                                                                 |
| config.token.key                           | string | `""`                    | The path to the key used for signing tokens.                                                                            |
| config.users                               | object | `{}`                    | Configure static authentication.                                                                                        |
| config.xorm_auth                           | object | `{}`                    | Configure SQL authentication.                                                                                           |
| externalConfig.secretRef.name              | string | `""`                    | Specify the name of the secret containing the raw configuration.                                                        |
| extraVolumeMounts                          | list   | `[]`                    | Add additional volume mounts to the pod.                                                                                |
| extraVolumes                               | list   | `[]`                    | Add additional volumes to the pod.                                                                                      |
| fullnameOverride                           | string | `""`                    | Override the full name of the release.                                                                                  |
| image.pullPolicy                           | string | `"IfNotPresent"`        | The pull policy to use for the registry auth image.                                                                     |
| image.repository                           | string | `"cesanta/docker_auth"` | The repository hosting the container registry auth image.                                                               |
| image.tag                                  | string | `""`                    | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                           | list   | `[]`                    | Specify the secret containing the registry credentials.                                                                 |
| nameOverride                               | string | `""`                    | Override the name of the release.                                                                                       |
| nodeSelector                               | object | `{}`                    | Specify the node selector used to control which nodes registry pods are deployed to.                                    |
| podAnnotations                             | object | `{}`                    | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext                         | object | `{}`                    | Specify the security context for the entire pod.                                                                        |
| replicaCount                               | int    | `1`                     | The number of registry authorization servers to deploy.                                                                 |
| resources                                  | object | `{}`                    | Specify the resources for the pod.                                                                                      |
| securityContext                            | object | `{}`                    | Specify the security context for the `registry` container.                                                              |
| service.type                               | string | `"ClusterIP"`           | Specify the type of service to create.                                                                                  |
| serviceAccount.annotations                 | object | `{}`                    | Annotations to add to the service account.                                                                              |
| serviceAccount.create                      | bool   | `true`                  | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name                        | string | `""`                    | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                                | list   | `[]`                    | Specify taints that the registry pods are willing to tolerate.                                                          |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

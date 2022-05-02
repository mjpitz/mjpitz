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

# drone

![Version: 22.5.0](https://img.shields.io/badge/Version-22.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.11.1](https://img.shields.io/badge/AppVersion-2.11.1-informational?style=flat-square)

Easily deploy a Drone.IO, a container-native, continuous delivery platform. This chart provisions a Drone server
instance intended for smaller

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/harness/drone>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/drone>

## Requirements

| Repository         | Name        | Version |
| ------------------ | ----------- | ------- |
| https://mjpitz.com | litestream  | 22.4.0  |
| https://mjpitz.com | redis-queue | 22.4.0  |

## Values

| Key                                       | Type   | Default                         | Description                                                                                                                                                                         |
| ----------------------------------------- | ------ | ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| affinity                                  | object | `{}`                            | Specify affinity rules for the pods.                                                                                                                                                |
| config.bitbucket.clientId                 | string | `""`                            | Configures the Bitbucket OAuth client id.                                                                                                                                           |
| config.bitbucket.clientSecret             | string | `""`                            | Configures the Bitbucket OAuth client secret.                                                                                                                                       |
| config.bitbucket.debug                    | bool   | `false`                         | Configures detailed trace logging for the Bitbucket authentication provide. This should be used to troubleshoot problems with login when installing Drone server.                   |
| config.bitbucket.enabled                  | bool   | `false`                         |                                                                                                                                                                                     |
| config.blobs.accessKeyId                  | string | `""`                            | The access key id used for authentication.                                                                                                                                          |
| config.blobs.bucket                       | string | `""`                            | Configures the S3 bucket name.                                                                                                                                                      |
| config.blobs.endpoint                     | string | `""`                            | Configures the S3 endpoint. The is often used with S3-compatible services such as Minio.                                                                                            |
| config.blobs.pathStyle                    | bool   | `false`                         | Configures the S3 client to use path style. The is often used with S3-compatible services such as Minio.                                                                            |
| config.blobs.prefix                       | string | `""`                            | Configures the S3 client to store log files in a bucket subdirectory.                                                                                                               |
| config.blobs.region                       | string | `""`                            | The region where blobs will be stored.                                                                                                                                              |
| config.blobs.secretAccessKey              | string | `""`                            | The secret access key used for authentication.                                                                                                                                      |
| config.cleanup.deadline.pending           | string | `"24h"`                         | Configures the interval after which a pending job will be killed by the reaper.                                                                                                     |
| config.cleanup.deadline.running           | string | `"24h"`                         | Configures the interval after which a running job will be killed by the reaper.                                                                                                     |
| config.cleanup.enabled                    | bool   | `true`                          |                                                                                                                                                                                     |
| config.cleanup.interval                   | string | `"24h"`                         | Configures the interval at which the reaper is run.                                                                                                                                 |
| config.cookie.secret                      | string | `""`                            | Configures the secret key used to sign authentication cookies. If unset, a random value is generated each time the server is started.                                               |
| config.cookie.timeout                     | string | `"720h"`                        | Configures the authentication cookie expiration.                                                                                                                                    |
| config.cron.enabled                       | bool   | `true`                          |                                                                                                                                                                                     |
| config.cron.interval                      | string | `"1h"`                          | Configures the interval at which the cron scheduler is run. The cron scheduler is not meant to be accurate and batches pending jobs every hour by default.                          |
| config.database.datasource                | string | `"/data/drone.sqlite"`          | Configures the database connection string.                                                                                                                                          |
| config.database.driver                    | string | `"sqlite3"`                     | Configures the database driver name. The default value is the sqlite3 driver. Alternate drivers are postgres and mysql.                                                             |
| config.database.maxConnections            | int    | `0`                             | Set the maximum number of open DB connections from Drone. It is set to 0 by default and must be configured before the system is first used.                                         |
| config.database.secret                    | string | `""`                            | Configures the secret key used to encrypt secrets in the database. Encryption is disabled by default and must be configured before the system is first used.                        |
| config.git.alwaysAuth                     | bool   | `false`                         | Configures Drone to authenticate when cloning public repositories. This is only required when your source code management system (e.g. GitHub Enterprise) has private mode enabled. |
| config.git.enabled                        | bool   | `false`                         |                                                                                                                                                                                     |
| config.git.password                       | string | `""`                            | Overrides the default git password used to authenticate and clone private repositories.                                                                                             |
| config.git.username                       | string | `""`                            | Overrides the default git username used to authenticate and clone private repositories.                                                                                             |
| config.gitea.clientId                     | string | `""`                            | Configures the Gitea OAuth client id.                                                                                                                                               |
| config.gitea.clientSecret                 | string | `""`                            | Configures the Gitea OAuth client secret.                                                                                                                                           |
| config.gitea.enabled                      | bool   | `false`                         |                                                                                                                                                                                     |
| config.gitea.server                       | string | `""`                            | Configures the Gitea server address. Example: `https://try.gitea.io`.                                                                                                               |
| config.gitea.skipVerify                   | bool   | `false`                         | Disables tls verification when establishing a connection to the remote Gitea server.                                                                                                |
| config.gitee.enabled                      | bool   | `false`                         |                                                                                                                                                                                     |
| config.gitee.redirectUrl                  | string | `""`                            | Configures the Gitee OAuth authorize redirect url.                                                                                                                                  |
| config.gitee.scope                        | list   | `[]`                            | A list of additional OAuth scopes.                                                                                                                                                  |
| config.gitee.skipVerify                   | bool   | `false`                         | Disables TLS verification when establishing a connection to the remote Gitee server.                                                                                                |
| config.github.clientId                    | string | `""`                            | Configures the GitHub OAuth client id.                                                                                                                                              |
| config.github.clientSecret                | string | `""`                            | Configures the GitHub OAuth client secret.                                                                                                                                          |
| config.github.enabled                     | bool   | `false`                         |                                                                                                                                                                                     |
| config.github.scope                       | list   | `[]`                            | A list of additional OAuth scopes.                                                                                                                                                  |
| config.github.server                      | string | `""`                            | Configures the GitHub server address.                                                                                                                                               |
| config.github.skipVerify                  | bool   | `false`                         | Disables TLS verification when establishing a connection to the remote GitHub server.                                                                                               |
| config.gitlab.clientId                    | string | `""`                            | Configures the GitLab OAuth client id.                                                                                                                                              |
| config.gitlab.clientSecret                | string | `""`                            | Configures the GitLab OAuth client secret.                                                                                                                                          |
| config.gitlab.enabled                     | bool   | `false`                         |                                                                                                                                                                                     |
| config.gitlab.server                      | string | `""`                            | Configures the GitLab server address.                                                                                                                                               |
| config.gitlab.skipVerify                  | bool   | `false`                         | Disables TLS verification when establishing a connection to the remote GitLab server.                                                                                               |
| config.gogs.enabled                       | bool   | `false`                         |                                                                                                                                                                                     |
| config.gogs.server                        | string | `""`                            | Configures the Gogs server address.                                                                                                                                                 |
| config.gogs.skipVerify                    | bool   | `false`                         | Disables TLS verification when establishing a connection to the remote Gogs server.                                                                                                 |
| config.overrides                          | object | `{}`                            |                                                                                                                                                                                     |
| config.rpc.secret                         | string | `""`                            | This is used to authenticate the RPC connection to the server. The server and runners must be provided the same secret value.                                                       |
| config.stash.consumerKey                  | string | `""`                            | Configures your Bitbucket server consumer key.                                                                                                                                      |
| config.stash.enabled                      | bool   | `false`                         |                                                                                                                                                                                     |
| config.stash.privateKeyFile               | string | `""`                            | Configures your Bitbucket server private key file.                                                                                                                                  |
| config.stash.server                       | string | `""`                            | Configures the Bitbucket server address.                                                                                                                                            |
| config.stash.skipVerify                   | bool   | `false`                         | Disables TLS verification when establishing a connection to the remote Bitbucket server.                                                                                            |
| config.validate.endpoint                  | string | `""`                            | Configures the endpoint for the validation plugin, used to enforce custom linting rules for your pipeline configuration.                                                            |
| config.validate.secret                    | string | `""`                            | Shared secret used to create an http-signature.                                                                                                                                     |
| config.validate.skipVerify                | bool   | `false`                         | Disables TLS verification when establishing a connection to the remote validation server.                                                                                           |
| config.webhook.endpoint                   | list   | `[]`                            | Configures a comma-separated list of webhook endpoints, to which global system events are delivered.                                                                                |
| config.webhook.events                     | list   | `[]`                            | Provides a comma-separated list of events and actions that trigger webhooks.                                                                                                        |
| config.webhook.secret                     | string | `""`                            | Shared secret used to create an http-signature.                                                                                                                                     |
| config.webhook.skipVerify                 | bool   | `false`                         | Disables TLS verification when establishing a connection to the remote webhook servers.                                                                                             |
| externalConfig.secretRef.name             | string | `""`                            | Specify the name of the secret containing the raw configuration.                                                                                                                    |
| fullnameOverride                          | string | `""`                            | Override the full name of the release.                                                                                                                                              |
| global.rpc.host                           | string | `""`                            | Configure the public host address of drone.                                                                                                                                         |
| global.rpc.proto                          | string | `""`                            | Configure the protocol used by drone.                                                                                                                                               |
| global.rpc.secret                         | string | `""`                            | This is used to authenticate the RPC connection to the server. The server and runners must be provided the same secret value.                                                       |
| image.pullPolicy                          | string | `"IfNotPresent"`                | Specify the pull policy for the image.                                                                                                                                              |
| image.repository                          | string | `"ghcr.io/mjpitz/drone-server"` | Where can the image be found.                                                                                                                                                       |
| image.tag                                 | string | `"2.11.1-alpine"`               | Configure which version of the image to use.                                                                                                                                        |
| imagePullSecrets                          | list   | `[]`                            | Specify the secret containing the registry credentials.                                                                                                                             |
| ingress.annotations                       | object | `{}`                            | Specify annotations for the ingress.                                                                                                                                                |
| ingress.enabled                           | bool   | `false`                         | Configure the ingress for Drone.                                                                                                                                                    |
| ingress.hosts[0].host                     | string | `"chart-example.local"`         | Specify the domain host for the ingress.                                                                                                                                            |
| ingress.tls                               | list   | `[]`                            | Configure TLS for the ingress.                                                                                                                                                      |
| litestream.config.dbs[0].path             | string | `"/data/drone.sqlite"`          |                                                                                                                                                                                     |
| litestream.config.dbs[0].replicas         | list   | `[]`                            |                                                                                                                                                                                     |
| litestream.enabled                        | bool   | `false`                         |                                                                                                                                                                                     |
| litestream.extraVolumeMounts[0].mountPath | string | `"/data"`                       |                                                                                                                                                                                     |
| litestream.extraVolumeMounts[0].name      | string | `"data"`                        |                                                                                                                                                                                     |
| nameOverride                              | string | `""`                            | Override the name of the release.                                                                                                                                                   |
| nodeSelector                              | object | `{}`                            | Specify the node selector used to control which nodes pods are deployed to.                                                                                                         |
| persistence.accessMode                    | string | `"ReadWriteOnce"`               | Configure the access mode of the volume.                                                                                                                                            |
| persistence.enabled                       | bool   | `true`                          | Enable persistence for this deployment. This will configure a SQLite driver for storing information.                                                                                |
| persistence.existingClaim                 | string | `""`                            | Specify the name of an existing PersistentVolumeClaim to use.                                                                                                                       |
| persistence.resources.storage             | string | `"10Gi"`                        | Specify the size of the volume.                                                                                                                                                     |
| persistence.storageClass                  | string | `""`                            | Specify the storage class that should provision this claim.                                                                                                                         |
| podAnnotations                            | object | `{}`                            | Annotations to add to the pod, typically used for assume roles.                                                                                                                     |
| podSecurityContext                        | object | `{}`                            | Specify the security context for the entire pod.                                                                                                                                    |
| redis-queue.enabled                       | bool   | `false`                         | Enable redis for task queueing.                                                                                                                                                     |
| resources                                 | object | `{}`                            | Specify the resources for the drone container.                                                                                                                                      |
| runners.digitalocean.enabled              | bool   | `false`                         |                                                                                                                                                                                     |
| runners.kubernetes.enabled                | bool   | `false`                         |                                                                                                                                                                                     |
| securityContext                           | object | `{}`                            | Specify the security context for the drone container.                                                                                                                               |
| service.annotations                       | object | `{}`                            | Annotations to add to the service, typically used for ingress control.                                                                                                              |
| service.type                              | string | `"ClusterIP"`                   | Specify the type of service to create.                                                                                                                                              |
| serviceAccount.annotations                | object | `{}`                            | Annotations to add to the service account.                                                                                                                                          |
| serviceAccount.create                     | bool   | `true`                          | Specifies whether a service account should be created.                                                                                                                              |
| serviceAccount.name                       | string | `""`                            | The name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                                             |
| tolerations                               | list   | `[]`                            | Specify taints that the pods are willing to tolerate.                                                                                                                               |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# runners

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/mjpitz/mjpitz/tree/main/charts/drone>

## Requirements

| Repository | Name         | Version |
| ---------- | ------------ | ------- |
|            | digitalocean | \*      |
|            | kubernetes   | \*      |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# digitalocean

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

Deploy the Drone.IO DigitalOcean Runner.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/mjpitz/mjpitz/tree/main/charts/drone>

## Values

| Key                        | Type   | Default                             | Description                                                                                                                   |
| -------------------------- | ------ | ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| affinity                   | object | `{}`                                | Specify affinity rules for the pods.                                                                                          |
| config.overrides           | object | `{}`                                |                                                                                                                               |
| config.privateKeyFile      | string | `""`                                |                                                                                                                               |
| config.publicKeyFile       | string | `""`                                |                                                                                                                               |
| config.rpc.host            | string | `""`                                | Configure the public host address of drone.                                                                                   |
| config.rpc.proto           | string | `""`                                | Configure the protocol used by drone.                                                                                         |
| config.rpc.secret          | string | `""`                                | This is used to authenticate the RPC connection to the server. The server and runners must be provided the same secret value. |
| fullnameOverride           | string | `""`                                | Override the full name of the release.                                                                                        |
| global.rpc.host            | string | `""`                                | Configure the public host address of drone.                                                                                   |
| global.rpc.proto           | string | `""`                                | Configure the protocol used by drone.                                                                                         |
| global.rpc.secret          | string | `""`                                | This is used to authenticate the RPC connection to the server. The server and runners must be provided the same secret value. |
| image.pullPolicy           | string | `"Always"`                          | Specify the pull policy for the image.                                                                                        |
| image.repository           | string | `"drone/drone-runner-digitalocean"` | Where can the image be found.                                                                                                 |
| image.tag                  | string | `""`                                | Configure which version of the image to use.                                                                                  |
| imagePullSecrets           | list   | `[]`                                | Specify the secret containing the registry credentials.                                                                       |
| nameOverride               | string | `""`                                | Override the name of the release.                                                                                             |
| nodeSelector               | object | `{}`                                | Specify the node selector used to control which nodes pods are deployed to.                                                   |
| podAnnotations             | object | `{}`                                | Annotations to add to the pod, typically used for assume roles.                                                               |
| podSecurityContext         | object | `{}`                                | Specify the security context for the entire pod.                                                                              |
| resources                  | object | `{}`                                | Specify the resources for the digitalocean runner container.                                                                  |
| securityContext            | object | `{}`                                | Specify the security context for the digitalocean runner container.                                                           |
| serviceAccount.annotations | object | `{}`                                | Annotations to add to the service account.                                                                                    |
| serviceAccount.create      | bool   | `true`                              | Specifies whether a service account should be created.                                                                        |
| serviceAccount.name        | string | `""`                                | The name of the service account to use. If not set and create is true, a name is generated using the fullname template.       |
| tolerations                | list   | `[]`                                | Specify taints that the pods are willing to tolerate.                                                                         |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# kubernetes

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

Deploy the Drone.IO Kubernetes Runner.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/mjpitz/mjpitz/tree/main/charts/drone>

## Values

| Key                        | Type   | Default                     | Description                                                                                                                   |
| -------------------------- | ------ | --------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| affinity                   | object | `{}`                        | Specify affinity rules for the pods.                                                                                          |
| config.overrides           | object | `{}`                        |                                                                                                                               |
| config.rpc.host            | string | `""`                        | Configure the public host address of drone.                                                                                   |
| config.rpc.proto           | string | `""`                        | Configure the protocol used by drone.                                                                                         |
| config.rpc.secret          | string | `""`                        | This is used to authenticate the RPC connection to the server. The server and runners must be provided the same secret value. |
| fullnameOverride           | string | `""`                        | Override the full name of the release.                                                                                        |
| global.rpc.host            | string | `""`                        | Configure the public host address of drone.                                                                                   |
| global.rpc.proto           | string | `""`                        | Configure the protocol used by drone.                                                                                         |
| global.rpc.secret          | string | `""`                        | This is used to authenticate the RPC connection to the server. The server and runners must be provided the same secret value. |
| image.pullPolicy           | string | `"Always"`                  | Specify the pull policy for the image.                                                                                        |
| image.repository           | string | `"drone/drone-runner-kube"` | Where can the image be found.                                                                                                 |
| image.tag                  | string | `""`                        | Configure which version of the image to use.                                                                                  |
| imagePullSecrets           | list   | `[]`                        | Specify the secret containing the registry credentials.                                                                       |
| nameOverride               | string | `""`                        | Override the name of the release.                                                                                             |
| nodeSelector               | object | `{}`                        | Specify the node selector used to control which nodes pods are deployed to.                                                   |
| podAnnotations             | object | `{}`                        | Annotations to add to the pod, typically used for assume roles.                                                               |
| podSecurityContext         | object | `{}`                        | Specify the security context for the entire pod.                                                                              |
| resources                  | object | `{}`                        | Specify the resources for the kubernetes runner container.                                                                    |
| securityContext            | object | `{}`                        | Specify the security context for the kubernetes runner container.                                                             |
| serviceAccount.annotations | object | `{}`                        | Annotations to add to the service account.                                                                                    |
| serviceAccount.create      | bool   | `true`                      | Specifies whether a service account should be created.                                                                        |
| serviceAccount.name        | string | `""`                        | The name of the service account to use. If not set and create is true, a name is generated using the fullname template.       |
| tolerations                | list   | `[]`                        | Specify taints that the pods are willing to tolerate.                                                                         |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# gitea

![Version: 22.4.0](https://img.shields.io/badge/Version-22.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.6](https://img.shields.io/badge/AppVersion-1.16.6-informational?style=flat-square)

Git with a cup of tea. A painless, self-hosted Git Service.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/go-gitea/gitea>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/gitea>

## Requirements

| Repository         | Name        | Version |
| ------------------ | ----------- | ------- |
| https://mjpitz.com | litestream  | 22.4.0  |
| https://mjpitz.com | redis       | 22.4.2  |
| https://mjpitz.com | redis-queue | 22.4.0  |

## Values

| Key                                                 | Type   | Default                                                                                            | Description                                                                                                                                              |
| --------------------------------------------------- | ------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| affinity                                            | object | `{}`                                                                                               | Specify affinity rules for the pods.                                                                                                                     |
| config.attachment.overrides                         | object | `{}`                                                                                               | Override configuration for the `attachment` block of the configuration file.                                                                             |
| config.blobs                                        | object | `{"accessKeyId":"","bucket":"","endpoint":"","region":"","secretAccessKey":"","useSSL":true}`      | Provide configuration for the backing blob store.                                                                                                        |
| config.blobs.accessKeyId                            | string | `""`                                                                                               | The access key id used to authenticate the session.                                                                                                      |
| config.blobs.bucket                                 | string | `""`                                                                                               | Specify the bucket to store information in.                                                                                                              |
| config.blobs.endpoint                               | string | `""`                                                                                               | The endpoint hosting the S3 implementation. Setting this value enables object storage for blobs.                                                         |
| config.blobs.region                                 | string | `""`                                                                                               | Specify the region where the blob data is hosted.                                                                                                        |
| config.blobs.secretAccessKey                        | string | `""`                                                                                               | The secret access key used to authenticate with the S3 implementation.                                                                                   |
| config.blobs.useSSL                                 | bool   | `true`                                                                                             | Configure SSL for the blob storage.                                                                                                                      |
| config.cors.overrides                               | object | `{}`                                                                                               | Override configuration for the `cors` block of the configuration file.                                                                                   |
| config.database                                     | object | `{"host":"","log":false,"name":"","password":"","schema":"","sslMode":"","type":"","username":""}` | Provide configuration for the backing database. If not provided, SQLite will be used.                                                                    |
| config.database.host                                | string | `""`                                                                                               | Configure the host of the database server.                                                                                                               |
| config.database.log                                 | bool   | `false`                                                                                            | Database logging.                                                                                                                                        |
| config.database.name                                | string | `""`                                                                                               | Configure the name of the database.                                                                                                                      |
| config.database.password                            | string | `""`                                                                                               | Specify the password used to connect to the database.                                                                                                    |
| config.database.schema                              | string | `""`                                                                                               | Specify the schema to use.                                                                                                                               |
| config.database.sslMode                             | string | `""`                                                                                               | Specify the SSL mode to use for the database connection.                                                                                                 |
| config.database.type                                | string | `""`                                                                                               | Specify what type of database we're connecting to.                                                                                                       |
| config.database.username                            | string | `""`                                                                                               | Specify the username used to connect to the database.                                                                                                    |
| config.email.from                                   | string | `""`                                                                                               | Who to send emails from.                                                                                                                                 |
| config.email.host                                   | string | `""`                                                                                               | The host hosting the email server.                                                                                                                       |
| config.email.password                               | string | `""`                                                                                               | The password to use when authenticating with the mail server.                                                                                            |
| config.email.port                                   | int    | `465`                                                                                              | The port hosting the SMTP server.                                                                                                                        |
| config.email.username                               | string | `""`                                                                                               | The username to use when authenticating with the mail server.                                                                                            |
| config.index.code.connectionString                  | string | `""`                                                                                               | Specify the connection string to connect to an external elasticsearch instance.                                                                          |
| config.index.code.enabled                           | bool   | `false`                                                                                            | Enable code search capabilities.                                                                                                                         |
| config.index.code.type                              | string | `""`                                                                                               | Configure the code index backend. Can be `elasticsearch`, defaults to `bleve`.                                                                           |
| config.index.issues.connectionString                | string | `""`                                                                                               | Specify the connection string to connect to an external elasticsearch instance.                                                                          |
| config.index.issues.type                            | string | `""`                                                                                               | Configure the issue index backend. Can be `elasticsearch`, defaults to `bleve`.                                                                          |
| config.lfs.overrides                                | object | `{}`                                                                                               | Override configuration for the `lfs` block of the configuration file.                                                                                    |
| config.log.overrides                                | object | `{}`                                                                                               | Override configuration for the `log` block of the configuration file.                                                                                    |
| config.markdown.overrides                           | object | `{}`                                                                                               | Override configuration for the `markdown` block of the configuration file.                                                                               |
| config.metrics.overrides                            | object | `{}`                                                                                               | Override configuration for the `metrics` block of the configuration file.                                                                                |
| config.overrides                                    | object | `{}`                                                                                               | Override configuration for the `DEFAULT` block of the configuration file.                                                                                |
| config.packages.enabled                             | bool   | `true`                                                                                             | Enable package management.                                                                                                                               |
| config.picture.overrides                            | object | `{}`                                                                                               | Override configuration for the `picture` block of the configuration file.                                                                                |
| config.queues.code_indexer.connectionString         | string | `""`                                                                                               | Specify a connection string for the `code_indexer` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.              |
| config.queues.code_indexer.db                       | int    | `1`                                                                                                | Specify which database should be used for the `code_indexer` queue. Only applicable for `redis` queues.                                                  |
| config.queues.code_indexer.length                   | int    | `20`                                                                                               | Specify the length of the `code_indexer` queue.                                                                                                          |
| config.queues.connectionString                      | string | `""`                                                                                               | Specify a connection string for the queues. Only applicable for `redis` queues. Example: `redis://127.0.0.1:6379`.                                       |
| config.queues.issue_indexer.connectionString        | string | `""`                                                                                               | Specify a connection string for the `issue_indexer` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.             |
| config.queues.issue_indexer.db                      | int    | `0`                                                                                                | Specify which database should be used for the `issue_indexer` queue. Only applicable for `redis` queues.                                                 |
| config.queues.issue_indexer.length                  | int    | `20`                                                                                               | Specify the length of the `issue_indexer` queue.                                                                                                         |
| config.queues.mail.connectionString                 | string | `""`                                                                                               | Specify a connection string for the `mail` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.                      |
| config.queues.mail.db                               | int    | `4`                                                                                                | Specify which database should be used for the `mail` queue. Only applicable for `redis` queues.                                                          |
| config.queues.mail.length                           | int    | `100`                                                                                              | Specify the length of the `mail` queue.                                                                                                                  |
| config.queues.mirror.connectionString               | string | `""`                                                                                               | Specify a connection string for the `mirror` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.                    |
| config.queues.mirror.db                             | int    | `8`                                                                                                | Specify which database should be used for the `mirror` queue. Only applicable for `redis` queues.                                                        |
| config.queues.mirror.length                         | int    | `1000`                                                                                             | Specify the length of the `mirror` queue.                                                                                                                |
| config.queues.notification_service.connectionString | string | `""`                                                                                               | Specify a connection string for the `notification-service` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.      |
| config.queues.notification_service.db               | int    | `2`                                                                                                | Specify which database should be used for the `notification-service` queue. Only applicable for `redis` queues.                                          |
| config.queues.notification_service.length           | int    | `20`                                                                                               | Specify the length of the `notification-service` queue.                                                                                                  |
| config.queues.pr_patch_checker.connectionString     | string | `""`                                                                                               | Specify a connection string for the `pr_patch_checker` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.          |
| config.queues.pr_patch_checker.db                   | int    | `9`                                                                                                | Specify which database should be used for the `pr_patch_checker` queue. Only applicable for `redis` queues.                                              |
| config.queues.pr_patch_checker.length               | int    | `1000`                                                                                             | Specify the length of the `pr_patch_checker` queue.                                                                                                      |
| config.queues.push_update.connectionString          | string | `""`                                                                                               | Specify a connection string for the `push_update` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.               |
| config.queues.push_update.db                        | int    | `5`                                                                                                | Specify which database should be used for the `push_update` queue. Only applicable for `redis` queues.                                                   |
| config.queues.push_update.length                    | int    | `20`                                                                                               | Specify the length of the `push_update` queue.                                                                                                           |
| config.queues.repo_archive.connectionString         | string | `""`                                                                                               | Specify a connection string for the `repo-archive` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.              |
| config.queues.repo_archive.db                       | int    | `7`                                                                                                | Specify which database should be used for the `repo-archive` queue. Only applicable for `redis` queues.                                                  |
| config.queues.repo_archive.length                   | int    | `20`                                                                                               | Specify the length of the `repo-archive` queue.                                                                                                          |
| config.queues.repo_stats_update.connectionString    | string | `""`                                                                                               | Specify a connection string for the `repo_stats_update` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.         |
| config.queues.repo_stats_update.db                  | int    | `6`                                                                                                | Specify which database should be used for the `repo_stats_update` queue. Only applicable for `redis` queues.                                             |
| config.queues.repo_stats_update.length              | int    | `20`                                                                                               | Specify the length of the `repo_stats_update` queue.                                                                                                     |
| config.queues.task.connectionString                 | string | `""`                                                                                               | Specify a connection string for the `task` queue. Only applicable for `redis` queues. Defaults to `config.queues.connectionString`.                      |
| config.queues.task.db                               | int    | `3`                                                                                                | Specify which database should be used for the `task` queue. Only applicable for `redis` queues.                                                          |
| config.queues.task.length                           | int    | `20`                                                                                               | Specify the length of the `task` queue.                                                                                                                  |
| config.queues.type                                  | string | `""`                                                                                               | Specify how queues are managed. If `redis-queue.enabled` is `true`, then this value defaults to `redis`. Otherwise, we default to `persistable-channel`. |
| config.repository.editor.overrides                  | object | `{}`                                                                                               | Override configuration for the `repository.editor` block of the configuration file.                                                                      |
| config.repository.issue.overrides                   | object | `{}`                                                                                               | Override configuration for the `repository.issue` block of the configuration file.                                                                       |
| config.repository.local.overrides                   | object | `{}`                                                                                               | Override configuration for the `repository.local` block of the configuration file.                                                                       |
| config.repository.mimeMapping.overrides             | object | `{}`                                                                                               | Override configuration for the `repository.mimetype_mapping` block of the configuration file.                                                            |
| config.repository.overrides                         | object | `{}`                                                                                               | Override configuration for the `repository` block of the configuration file.                                                                             |
| config.repository.pullRequest.overrides             | object | `{}`                                                                                               | Override configuration for the `repository.pull-request` block of the configuration file.                                                                |
| config.repository.release.overrides                 | object | `{}`                                                                                               | Override configuration for the `repository.release` block of the configuration file.                                                                     |
| config.repository.signing.overrides                 | object | `{}`                                                                                               | Override configuration for the `repository.signing` block of the configuration file.                                                                     |
| config.repository.upload.overrides                  | object | `{}`                                                                                               | Override configuration for the `repository.upload` block of the configuration file.                                                                      |
| config.security.installLock                         | bool   | `false`                                                                                            | Set to `true` to lock the installation screen.                                                                                                           |
| config.security.internalToken                       | string | `""`                                                                                               | Secret used to validate communication within Gitea binary.                                                                                               |
| config.security.secretKey                           | string | `""`                                                                                               | Global secret key used by the Gitea instances.                                                                                                           |
| config.server.overrides                             | object | `{}`                                                                                               | Override configuration for the `server` block of the configuration file.                                                                                 |
| config.service.explore.overrides                    | object | `{}`                                                                                               | Override configuration for the `service.explore` block of the configuration file.                                                                        |
| config.service.overrides                            | object | `{}`                                                                                               | Override configuration for the `service` block of the configuration file.                                                                                |
| config.ui.overrides                                 | object | `{}`                                                                                               | Override configuration for the `ui` block of the configuration file.                                                                                     |
| externalConfig.secretRef.name                       | string | `""`                                                                                               | Specify the name of the secret containing the raw configuration.                                                                                         |
| extraVolumeMounts                                   | list   | `[]`                                                                                               | Add additional volume mounts to the pod.                                                                                                                 |
| extraVolumes                                        | list   | `[]`                                                                                               | Add additional volumes to the pod.                                                                                                                       |
| fullnameOverride                                    | string | `""`                                                                                               | Override the full name of the release.                                                                                                                   |
| image.pullPolicy                                    | string | `"IfNotPresent"`                                                                                   | The pull policy to use for the image.                                                                                                                    |
| image.repository                                    | string | `"gitea/gitea"`                                                                                    | The repository hosting the gitea server image.                                                                                                           |
| image.tag                                           | string | `""`                                                                                               | Overrides the image tag whose default is the chart appVersion.                                                                                           |
| imagePullSecrets                                    | list   | `[]`                                                                                               | Specify the secret containing the registry credentials.                                                                                                  |
| ingress.annotations                                 | object | `{}`                                                                                               | Specify annotations for the ingress.                                                                                                                     |
| ingress.enabled                                     | bool   | `false`                                                                                            | Configure the ingress for Gitea.                                                                                                                         |
| ingress.hosts[0].host                               | string | `"chart-example.local"`                                                                            | Specify the domain host for the ingress.                                                                                                                 |
| ingress.tls                                         | list   | `[]`                                                                                               | Configure TLS for the ingress.                                                                                                                           |
| litestream.config.dbs                               | list   | `[{"path":"/data/gitea/gitea.db","replicas":[]}]`                                                  | Configure the database replicas.                                                                                                                         |
| litestream.config.dbs[0].path                       | string | `"/data/gitea/gitea.db"`                                                                           | Replicate the gitea database.                                                                                                                            |
| litestream.config.dbs[0].replicas                   | list   | `[]`                                                                                               | Configure the replica targets.                                                                                                                           |
| litestream.enabled                                  | bool   | `false`                                                                                            | Whether litestream should be enabled for SQLite backups.                                                                                                 |
| litestream.extraVolumeMounts[0].mountPath           | string | `"/data/gitea"`                                                                                    | Where the volume with the given name needs to be mounted. This may change if you're providing your own volume.                                           |
| litestream.extraVolumeMounts[0].name                | string | `"gitea"`                                                                                          | Name of the volume containing the sqlite database.                                                                                                       |
| metrics.enabled                                     | bool   | `false`                                                                                            | Whether metrics should be enabled.                                                                                                                       |
| metrics.serviceMonitor.enabled                      | bool   | `false`                                                                                            | Add a Prometheus ServiceMonitor that scrapes the registry deployment.                                                                                    |
| metrics.serviceMonitor.interval                     | string | `"10s"`                                                                                            | How frequently prometheus should pull metrics from your registry deployment.                                                                             |
| nameOverride                                        | string | `""`                                                                                               | Override the name of the release.                                                                                                                        |
| nodeSelector                                        | object | `{}`                                                                                               | Specify the node selector used to control which nodes registry pods are deployed to.                                                                     |
| persistence.accessMode                              | string | `"ReadWriteOnce"`                                                                                  | Configure the access mode of the volume.                                                                                                                 |
| persistence.blobs.accessMode                        | string | `"ReadWriteOnce"`                                                                                  | Configure the access mode of the volume.                                                                                                                 |
| persistence.blobs.enabled                           | bool   | `true`                                                                                             | Enable persistence for the blob directories.                                                                                                             |
| persistence.blobs.existingClaim                     | string | `""`                                                                                               | Specify the name of an existing PersistentVolumeClaim to use.                                                                                            |
| persistence.blobs.resources.storage                 | string | `"10Gi"`                                                                                           | Specify the size of the volume.                                                                                                                          |
| persistence.blobs.storageClass                      | string | `""`                                                                                               | Specify the storage class that should provision this claim.                                                                                              |
| persistence.enabled                                 | bool   | `true`                                                                                             | Enable persistence for this deployment. This will configure a SQLite driver for storing information.                                                     |
| persistence.existingClaim                           | string | `""`                                                                                               | Specify the name of an existing PersistentVolumeClaim to use.                                                                                            |
| persistence.git.accessMode                          | string | `"ReadWriteOnce"`                                                                                  | Configure the access mode of the volume.                                                                                                                 |
| persistence.git.enabled                             | bool   | `true`                                                                                             | Enable persistence for the Git directories. This directory is managed separately from the SQLite configuration.                                          |
| persistence.git.existingClaim                       | string | `""`                                                                                               | Specify the name of an existing PersistentVolumeClaim to use.                                                                                            |
| persistence.git.resources.storage                   | string | `"10Gi"`                                                                                           | Specify the size of the volume.                                                                                                                          |
| persistence.git.storageClass                        | string | `""`                                                                                               | Specify the storage class that should provision this claim.                                                                                              |
| persistence.resources.storage                       | string | `"10Gi"`                                                                                           | Specify the size of the volume.                                                                                                                          |
| persistence.storageClass                            | string | `""`                                                                                               | Specify the storage class that should provision this claim.                                                                                              |
| podAnnotations                                      | object | `{}`                                                                                               | Annotations to add to the pod, typically used for assume roles.                                                                                          |
| podSecurityContext                                  | object | `{}`                                                                                               | Specify the security context for the entire pod.                                                                                                         |
| redis-queue.config.databases                        | int    | `10`                                                                                               | Overrides the default number of databases to match the number of queues that we need.                                                                    |
| redis-queue.enabled                                 | bool   | `false`                                                                                            | Set to `true` to enable a redis backed queueing solution. By default, queues are backed using a `persistable-channel`.                                   |
| redis.cluster.enabled                               | bool   | `true`                                                                                             | Enables the envoy cluster out of box.                                                                                                                    |
| redis.enabled                                       | bool   | `false`                                                                                            | Set to `true` to enable a redis backed cache for sessions and other cachable elements.                                                                   |
| resources                                           | object | `{}`                                                                                               | Specify the resources for the pod.                                                                                                                       |
| securityContext                                     | object | `{"runAsGroup":1000,"runAsUser":1000}`                                                             | Specify the security context for the `registry` container.                                                                                               |
| securityContext.runAsGroup                          | int    | `1000`                                                                                             | `git` is added as user 1000 to the container and must run as that group.                                                                                 |
| securityContext.runAsUser                           | int    | `1000`                                                                                             | `git` is added as user 1000 to the container and must run as that user.                                                                                  |
| service.annotations                                 | object | `{}`                                                                                               | Annotations to add to the service, typically used for ingress control.                                                                                   |
| service.type                                        | string | `"ClusterIP"`                                                                                      | Specify the type of service to create.                                                                                                                   |
| serviceAccount.annotations                          | object | `{}`                                                                                               | Annotations to add to the service account.                                                                                                               |
| serviceAccount.create                               | bool   | `true`                                                                                             | Specifies whether a service account should be created.                                                                                                   |
| serviceAccount.name                                 | string | `""`                                                                                               | The name of the service account to use. If not set and create is true, a name is generated using the fullname template.                                  |
| tolerations                                         | list   | `[]`                                                                                               | Specify taints that the registry pods are willing to tolerate.                                                                                           |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# litestream

![Version: 22.4.0](https://img.shields.io/badge/Version-22.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.3.8](https://img.shields.io/badge/AppVersion-0.3.8-informational?style=flat-square)

Easily add litestream to any sqlite backed application as a sidecar. This chart optionally deploys the required
configuration and provides template functions that render the necessary init and sidecar containers.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/benbjohnson/litestream>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/litestream>

## Values

| Key                           | Type   | Default                   | Description                                                                                                                                            |
| ----------------------------- | ------ | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| config.accessKeyId            | string | `""`                      | Specify a single access key id to use for all replicas who do not provide their own.                                                                   |
| config.dbs                    | list   | `[]`                      | A list of databases that should be replicated by litestream.                                                                                           |
| config.secretAccessKey        | string | `""`                      | Specify a single secret access key to use for all replica who do not provide their own.                                                                |
| externalConfig.secretRef.name | string | `""`                      | Specify the name of the secret containing the raw configuration. The secret should have a single litestream.yml entry that contains the configuration. |
| extraVolumeMounts             | list   | `[]`                      | Add additional volume mounts to the pod.                                                                                                               |
| fullnameOverride              | string | `""`                      | Override the full name of the release.                                                                                                                 |
| image.pullPolicy              | string | `"IfNotPresent"`          | The pull policy to use for the litestream image.                                                                                                       |
| image.repository              | string | `"litestream/litestream"` | The repository hosting the litestream image.                                                                                                           |
| image.tag                     | string | `"0.3.8"`                 | Overrides the image tag whose default is the chart appVersion.                                                                                         |
| imagePullSecrets              | list   | `[]`                      | Specify the secret containing the registry credentials.                                                                                                |
| metrics.enabled               | bool   | `false`                   | Whether metrics reporting should be enabled.                                                                                                           |
| metrics.port                  | int    | `9090`                    | The port to run the metrics server on.                                                                                                                 |
| nameOverride                  | string | `""`                      | Override the name of the release.                                                                                                                      |
| resources                     | object | `{}`                      | Specify the resources for the pod.                                                                                                                     |
| securityContext               | object | `{}`                      | Specify the security context for the `litestream` container.                                                                                           |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# maddy

![Version: 22.4.4](https://img.shields.io/badge/Version-22.4.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.5.4](https://img.shields.io/badge/AppVersion-0.5.4-informational?style=flat-square)

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

## Requirements

| Repository         | Name       | Version |
| ------------------ | ---------- | ------- |
| https://mjpitz.com | litestream | 22.4.0  |

## Values

| Key                                          | Type   | Default                   | Description                                                                                                             |
| -------------------------------------------- | ------ | ------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                                     | object | `{}`                      | Specify affinity rules for the pods.                                                                                    |
| autoscaling.enabled                          | bool   | `false`                   | Enable autoscaling for the deployment.                                                                                  |
| autoscaling.maxReplicas                      | int    | `100`                     | Specify the maximum number of replicas.                                                                                 |
| autoscaling.minReplicas                      | int    | `1`                       | Specify the minimum number of replicas.                                                                                 |
| autoscaling.targetCPUUtilizationPercentage   | int    | `80`                      | Specify the percent CPU utilization that causes the pods to autoscale.                                                  |
| config.database.dsn                          | string | `""`                      | Configure the DSN used to connect to a Postgres database.                                                               |
| config.domains.mx                            | string | `""`                      | Configure the mx domain used by the system. This _should_ align with the ingress address for the service.               |
| config.domains.primary                       | string | `""`                      | Configure the primary email domain that is managed by this server.                                                      |
| config.tls.certPath                          | string | `""`                      | Configure the full chain certificate path for TLS.                                                                      |
| config.tls.keyPath                           | string | `""`                      | Configure the private key path for TLS.                                                                                 |
| externalConfig.secretRef.name                | string | `""`                      | Specify the name of the secret containing the raw configuration.                                                        |
| extraVolumeMounts                            | list   | `[]`                      | Add additional volume mounts to the pod.                                                                                |
| extraVolumes                                 | list   | `[]`                      | Add additional volumes to the pod.                                                                                      |
| fullnameOverride                             | string | `""`                      | Override the full name of the release.                                                                                  |
| image.pullPolicy                             | string | `"IfNotPresent"`          | The pull policy to use for the image.                                                                                   |
| image.repository                             | string | `"foxcpp/maddy"`          | The repository hosting the email server image.                                                                          |
| image.tag                                    | string | `""`                      | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                             | list   | `[]`                      | Specify the secret containing the registry credentials.                                                                 |
| litestream.enabled                           | bool   | `false`                   | Whether to enable litestream for SQLite backup, recovery, and replication.                                              |
| litestream.extraVolumeMounts[0].mountPath    | string | `"/data"`                 | The path where the databases can be located.                                                                            |
| litestream.extraVolumeMounts[0].name         | string | `"data"`                  | The name of the data directory to mount. Defaults to the database volume created by `persistence.enabled`.              |
| metrics.serviceMonitor.enabled               | bool   | `false`                   | Add a Prometheus ServiceMonitor that scrapes the registry deployment.                                                   |
| metrics.serviceMonitor.interval              | string | `"10s"`                   | How frequently prometheus should pull metrics from your registry deployment.                                            |
| mta_sts.enabled                              | bool   | `false`                   | Whether to enable MTA-STS to proactively protect against attacks.                                                       |
| mta_sts.image.pullPolicy                     | string | `"IfNotPresent"`          | The pull policy to use for the nginx image.                                                                             |
| mta_sts.image.repository                     | string | `"nginx"`                 | The repository hosting the nginx server image.                                                                          |
| mta_sts.image.tag                            | string | `"1.21-alpine"`           | Configure the version of nginx to run.                                                                                  |
| mta_sts.ingress.annotations                  | object | `{}`                      | Specify annotations for the ingress.                                                                                    |
| mta_sts.ingress.enabled                      | bool   | `false`                   | Configure an ingress for the MTA-STS well-known configuration.                                                          |
| mta_sts.ingress.hosts[0].host                | string | `"chart-example.local"`   | Specify the domain host for the ingress.                                                                                |
| mta_sts.ingress.tls                          | list   | `[]`                      | Configure TLS for the ingress.                                                                                          |
| nameOverride                                 | string | `""`                      | Override the name of the release.                                                                                       |
| nodeSelector                                 | object | `{}`                      | Specify the node selector used to control which nodes registry pods are deployed to.                                    |
| persistence.accessMode                       | string | `"ReadWriteOnce"`         | Configure the access mode of the volume.                                                                                |
| persistence.enabled                          | bool   | `true`                    | Enable persistence for this deployment. This will configure a SQLite driver for storing information.                    |
| persistence.existingClaim                    | string | `""`                      | Specify the name of an existing PersistentVolumeClaim to use.                                                           |
| persistence.resources.storage                | string | `"10Gi"`                  | Specify the size of the volume.                                                                                         |
| persistence.storageClass                     | string | `""`                      | Specify the storage class that should provision this claim.                                                             |
| podAnnotations                               | object | `{}`                      | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext                           | object | `{}`                      | Specify the security context for the entire pod.                                                                        |
| replicaCount                                 | int    | `1`                       | The number of registry replicas to deploy.                                                                              |
| resources                                    | object | `{}`                      | Specify the resources for the pod.                                                                                      |
| rspamd.config."actions.conf"                 | string | `""`                      | Override configuration in the actions.conf file.                                                                        |
| rspamd.config."antivirus.conf"               | string | `""`                      | Override configuration in the antivirus.conf file.                                                                      |
| rspamd.config."antivirus_group.conf"         | string | `""`                      | Override configuration in the antivirus_group.conf file.                                                                |
| rspamd.config."arc.conf"                     | string | `""`                      | Override configuration in the arc.conf file.                                                                            |
| rspamd.config."asn.conf"                     | string | `""`                      | Override configuration in the asn.conf file.                                                                            |
| rspamd.config."chartable.conf"               | string | `""`                      | Override configuration in the chartable.conf file.                                                                      |
| rspamd.config."classifier-bayes.conf"        | string | `""`                      | Override configuration in the classifier-bayes.conf file.                                                               |
| rspamd.config."clickhouse.conf"              | string | `""`                      | Override configuration in the clickhouse.conf file.                                                                     |
| rspamd.config."composites.conf"              | string | `""`                      | Override configuration in the composites.conf file.                                                                     |
| rspamd.config."content_group.conf"           | string | `""`                      | Override configuration in the content_group.conf file.                                                                  |
| rspamd.config."dcc.conf"                     | string | `""`                      | Override configuration in the dcc.conf file.                                                                            |
| rspamd.config."dkim.conf"                    | string | `""`                      | Override configuration in the dkim.conf file.                                                                           |
| rspamd.config."dkim_signing.conf"            | string | `""`                      | Override configuration in the dkim_signing.conf file.                                                                   |
| rspamd.config."dmarc.conf"                   | string | `""`                      | Override configuration in the dmarc.conf file.                                                                          |
| rspamd.config."elastic.conf"                 | string | `""`                      | Override configuration in the elastic.conf file.                                                                        |
| rspamd.config."emails.conf"                  | string | `""`                      | Override configuration in the emails.conf file.                                                                         |
| rspamd.config."excessb64_group.conf"         | string | `""`                      | Override configuration in the excessb64_group.conf file.                                                                |
| rspamd.config."excessqp_group.conf"          | string | `""`                      | Override configuration in the excessqp_group.conf file.                                                                 |
| rspamd.config."external_services.conf"       | string | `""`                      | Override configuration in the external_services.conf file.                                                              |
| rspamd.config."external_services_group.conf" | string | `""`                      | Override configuration in the external_services_group.conf file.                                                        |
| rspamd.config."fann_redis.conf"              | string | `""`                      | Override configuration in the fann_redis.conf file.                                                                     |
| rspamd.config."file.conf"                    | string | `""`                      | Override configuration in the file.conf file.                                                                           |
| rspamd.config."force_actions.conf"           | string | `""`                      | Override configuration in the force_actions.conf file.                                                                  |
| rspamd.config."forged_recipients.conf"       | string | `""`                      | Override configuration in the forged_recipients.conf file.                                                              |
| rspamd.config."fuzzy_group.conf"             | string | `""`                      | Override configuration in the fuzzy_group.conf file.                                                                    |
| rspamd.config."greylist.conf"                | string | `""`                      | Override configuration in the greylist.conf file.                                                                       |
| rspamd.config."groups.conf"                  | string | `""`                      | Override configuration in the groups.conf file.                                                                         |
| rspamd.config."headers_group.conf"           | string | `""`                      | Override configuration in the headers_group.conf file.                                                                  |
| rspamd.config."hfilter.conf"                 | string | `""`                      | Override configuration in the hfilter.conf file.                                                                        |
| rspamd.config."hfilter_group.conf"           | string | `""`                      | Override configuration in the hfilter_group.conf file.                                                                  |
| rspamd.config."history_redis.conf"           | string | `""`                      | Override configuration in the history_redis.conf file.                                                                  |
| rspamd.config."http_headers.conf"            | string | `""`                      | Override configuration in the http_headers.conf file.                                                                   |
| rspamd.config."logging.inc"                  | string | `""`                      | Override configuration in the logging.inc file.                                                                         |
| rspamd.config."maillist.conf"                | string | `""`                      | Override configuration in the maillist.conf file.                                                                       |
| rspamd.config."metadata_exporter.conf"       | string | `""`                      | Override configuration in the metadata_exporter.conf file.                                                              |
| rspamd.config."metric_exporter.conf"         | string | `""`                      | Override configuration in the metric_exporter.conf file.                                                                |
| rspamd.config."metrics.conf"                 | string | `""`                      | Override configuration in the metrics.conf file.                                                                        |
| rspamd.config."mid.conf"                     | string | `""`                      | Override configuration in the mid.conf file.                                                                            |
| rspamd.config."milter_headers.conf"          | string | `""`                      | Override configuration in the milter_headers.conf file.                                                                 |
| rspamd.config."mime_types.conf"              | string | `""`                      | Override configuration in the mime_types.conf file.                                                                     |
| rspamd.config."mime_types_group.conf"        | string | `""`                      | Override configuration in the mime_types_group.conf file.                                                               |
| rspamd.config."mua_group.conf"               | string | `""`                      | Override configuration in the mua_group.conf file.                                                                      |
| rspamd.config."multimap.conf"                | string | `""`                      | Override configuration in the multimap.conf file.                                                                       |
| rspamd.config."mx_check.conf"                | string | `""`                      | Override configuration in the mx_check.conf file.                                                                       |
| rspamd.config."neural.conf"                  | string | `""`                      | Override configuration in the neural.conf file.                                                                         |
| rspamd.config."neural_group.conf"            | string | `""`                      | Override configuration in the neural_group.conf file.                                                                   |
| rspamd.config."once_received.conf"           | string | `""`                      | Override configuration in the once_received.conf file.                                                                  |
| rspamd.config."options.inc"                  | string | `""`                      | Override configuration in the options.inc file.                                                                         |
| rspamd.config."p0f.conf"                     | string | `""`                      | Override configuration in the p0f.conf file.                                                                            |
| rspamd.config."phishing.conf"                | string | `""`                      | Override configuration in the phishing.conf file.                                                                       |
| rspamd.config."phishing_group.conf"          | string | `""`                      | Override configuration in the phishing_group.conf file.                                                                 |
| rspamd.config."policies_group.conf"          | string | `""`                      | Override configuration in the policies_group.conf file.                                                                 |
| rspamd.config."ratelimit.conf"               | string | `""`                      | Override configuration in the ratelimit.conf file.                                                                      |
| rspamd.config."rbl.conf"                     | string | `""`                      | Override configuration in the rbl.conf file.                                                                            |
| rspamd.config."rbl_group.conf"               | string | `""`                      | Override configuration in the rbl_group.conf file.                                                                      |
| rspamd.config."redis.conf"                   | string | `""`                      | Override configuration in the redis.conf file.                                                                          |
| rspamd.config."regexp.conf"                  | string | `""`                      | Override configuration in the regexp.conf file.                                                                         |
| rspamd.config."replies.conf"                 | string | `""`                      | Override configuration in the replies.conf file.                                                                        |
| rspamd.config."reputation.conf"              | string | `""`                      | Override configuration in the reputation.conf file.                                                                     |
| rspamd.config."rmilter_headers.conf"         | string | `""`                      | Override configuration in the rmilter_headers.conf file.                                                                |
| rspamd.config."rspamd_update.conf"           | string | `""`                      | Override configuration in the rspamd_update.conf file.                                                                  |
| rspamd.config."settings.conf"                | string | `""`                      | Override configuration in the settings.conf file.                                                                       |
| rspamd.config."spamassassin.conf"            | string | `""`                      | Override configuration in the spamassassin.conf file.                                                                   |
| rspamd.config."spamtrap.conf"                | string | `""`                      | Override configuration in the spamtrap.conf file.                                                                       |
| rspamd.config."spf.conf"                     | string | `""`                      | Override configuration in the spf.conf file.                                                                            |
| rspamd.config."statistic.conf"               | string | `""`                      | Override configuration in the statistic.conf file.                                                                      |
| rspamd.config."statistics.conf"              | string | `""`                      | Override configuration in the statistics.conf file.                                                                     |
| rspamd.config."statistics_group.conf"        | string | `""`                      | Override configuration in the statistics_group.conf file.                                                               |
| rspamd.config."subject_group.conf"           | string | `""`                      | Override configuration in the subject_group.conf file.                                                                  |
| rspamd.config."surbl.conf"                   | string | `""`                      | Override configuration in the surbl.conf file.                                                                          |
| rspamd.config."surbl_group.conf"             | string | `""`                      | Override configuration in the surbl_group.conf file.                                                                    |
| rspamd.config."trie.conf"                    | string | `""`                      | Override configuration in the trie.conf file.                                                                           |
| rspamd.config."url_redirector.conf"          | string | `""`                      | Override configuration in the url_redirector.conf file.                                                                 |
| rspamd.config."whitelist.conf"               | string | `""`                      | Override configuration in the whitelist.conf file.                                                                      |
| rspamd.config."whitelist_group.conf"         | string | `""`                      | Override configuration in the whitelist_group.conf file.                                                                |
| rspamd.config."worker-normal.inc"            | string | `""`                      | Override configuration in the worker-normal.inc file.                                                                   |
| rspamd.enabled                               | bool   | `true`                    | Whether to enable rspamd to handle spam assignment.                                                                     |
| rspamd.image.pullPolicy                      | string | `"IfNotPresent"`          | The pull policy to use for the rspamd image.                                                                            |
| rspamd.image.repository                      | string | `"ghcr.io/mjpitz/rspamd"` | The repository hosting the rspamd image                                                                                 |
| rspamd.image.tag                             | string | `"22.4.0-alpine"`         | Configure the container version of rspamd to run.                                                                       |
| securityContext                              | object | `{}`                      | Specify the security context for the `registry` container.                                                              |
| service.annotations                          | object | `{}`                      | Annotations to add to the service, typically used for ingress control.                                                  |
| service.type                                 | string | `"LoadBalancer"`          | Specify the type of service to create.                                                                                  |
| serviceAccount.annotations                   | object | `{}`                      | Annotations to add to the service account.                                                                              |
| serviceAccount.create                        | bool   | `true`                    | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name                          | string | `""`                      | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                                  | list   | `[]`                      | Specify taints that the registry pods are willing to tolerate.                                                          |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# redis

![Version: 22.4.2](https://img.shields.io/badge/Version-22.4.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.2.6](https://img.shields.io/badge/AppVersion-6.2.6-informational?style=flat-square)

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
| kind                                       | string | `"Deployment"`                    | Configure how the redis cluster will be deployed. This can be Deployment, DaemonSet, or StatefulSet.                    |
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
| updateStrategy                             | object | `{}`                              | Configure the update strategy to use.                                                                                   |
| volumeClaimTemplates                       | list   | `[]`                              | When using a StatefulSet, persistent volume claim templates can be specified for writing data to disk.                  |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# redis-queue

![Version: 22.4.0](https://img.shields.io/badge/Version-22.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.2.6](https://img.shields.io/badge/AppVersion-6.2.6-informational?style=flat-square)

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
| image.pullPolicy                   | string | `"IfNotPresent"`                  | The pull policy to use for the registry image.                                                                          |
| image.repository                   | string | `"redis"`                         | The repository hosting the redis image.                                                                                 |
| image.tag                          | string | `""`                              | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                   | list   | `[]`                              | Specify the secret containing the registry credentials.                                                                 |
| metrics.serviceMonitor.enabled     | bool   | `false`                           | Add a Prometheus ServiceMonitor that scrapes the registry deployment.                                                   |
| metrics.serviceMonitor.interval    | string | `"10s"`                           | How frequently prometheus should pull metrics from your registry deployment.                                            |
| nameOverride                       | string | `""`                              | Override the name of the release.                                                                                       |
| nodeSelector                       | object | `{}`                              | Specify the node selector used to control which nodes registry pods are deployed to.                                    |
| persistence.accessMode             | string | `"ReadWriteOnce"`                 | Configure the access mode of the volume.                                                                                |
| persistence.enabled                | bool   | `true`                            | Enable persistence for this deployment.                                                                                 |
| persistence.existingClaim          | string | `""`                              | Specify the name of an existing PersistentVolumeClaim to use.                                                           |
| persistence.resources.storage      | string | `"10Gi"`                          | Specify the size of the volume.                                                                                         |
| persistence.storageClass           | string | `""`                              | Specify the storage class that should provision this claim.                                                             |
| podAnnotations                     | object | `{}`                              | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext                 | object | `{}`                              | Specify the security context for the entire pod.                                                                        |
| resources                          | object | `{}`                              | Specify the resources for the pod.                                                                                      |
| securityContext                    | object | `{}`                              | Specify the security context for the `registry` container.                                                              |
| service.annotations                | object | `{}`                              | Annotations to add to the service, typically used for ingress control.                                                  |
| serviceAccount.annotations         | object | `{}`                              | Annotations to add to the service account.                                                                              |
| serviceAccount.create              | bool   | `true`                            | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name                | string | `""`                              | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                        | list   | `[]`                              | Specify taints that the registry pods are willing to tolerate.                                                          |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# registry

![Version: 22.4.1](https://img.shields.io/badge/Version-22.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.8.0](https://img.shields.io/badge/AppVersion-2.8.0-informational?style=flat-square)

Easily deploy and configure a production-ready container registry backed by your favorite cloud storage provider.
Optionally add a highly-available, partition-tolerant Redis cache that's fronted by Envoy.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/distribution/distribution>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/registry>

## Requirements

| Repository         | Name  | Version |
| ------------------ | ----- | ------- |
| https://mjpitz.com | auth  | 22.4.0  |
| https://mjpitz.com | redis | 22.4.2  |
| https://mjpitz.com | storj | 22.4.1  |

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
| ui.image.tag                               | string | `"1.4.0"`                              | The tag of the image that contains the registry UI.                                                                                                               |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

# storj

![Version: 22.4.1](https://img.shields.io/badge/Version-22.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

Easily add a Storj S3 gateway to any Deployment, DaemonSet, or StatefulSet using a sidecar. This chart optionally
deploys the required configuration and provides template functions that render the necessary sidecar containers.

## Maintainers

| Name          | Email | Url                |
| ------------- | ----- | ------------------ |
| Mya Pitzeruse |       | https://mjpitz.com |

## Source Code

- <https://github.com/storj/gateway-st>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/storj>

## Values

| Key                                      | Type   | Default                | Description                                                                                                                                    |
| ---------------------------------------- | ------ | ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| config.accessGrant                       | string | `""`                   | The access grant providing access to the Storj network.                                                                                        |
| config.accessKeyId                       | string | `""`                   | An access key id that's shared between the gateway and S3 client.                                                                              |
| config.secretAccessKey                   | string | `""`                   | A secret key that's shared between the gateway and S3 client.                                                                                  |
| externalConfig.secretRef.accessGrantName | string | `"storj-access-grant"` | The secret key name identifying the Storj access grant.                                                                                        |
| externalConfig.secretRef.accessKeyName   | string | `"s3-access-key"`      | The secret key name identifying the S3 access key id.                                                                                          |
| externalConfig.secretRef.name            | string | `""`                   | Specify the name of the secret containing the raw configuration. The keys in the secret must match the other properties in this configuration. |
| externalConfig.secretRef.secretKeyName   | string | `"s3-secret-key"`      | The secret key name identifying the S3 secret key.                                                                                             |
| fullnameOverride                         | string | `""`                   | Override the full name of the release.                                                                                                         |
| image.pullPolicy                         | string | `"IfNotPresent"`       | The pull policy to use for the gateway image.                                                                                                  |
| image.repository                         | string | `"storjlabs/gateway"`  | The repository hosting the storjlabs/gateway image.                                                                                            |
| image.tag                                | string | `"latest"`             | Overrides the image tag whose default is the chart appVersion.                                                                                 |
| imagePullSecrets                         | list   | `[]`                   | Specify the secret containing the registry credentials.                                                                                        |
| nameOverride                             | string | `""`                   | Override the name of the release.                                                                                                              |
| resources                                | object | `{}`                   | Specify the resources for the pod.                                                                                                             |
| securityContext                          | object | `{}`                   | Specify the security context for the `storj` container.                                                                                        |

---

Autogenerated from chart metadata using [helm-docs v1.7.0](https://github.com/norwoodj/helm-docs/releases/v1.7.0)

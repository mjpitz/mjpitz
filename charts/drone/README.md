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

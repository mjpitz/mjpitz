# maddy

![Version: 22.4.11](https://img.shields.io/badge/Version-22.4.11-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.5.4](https://img.shields.io/badge/AppVersion-0.5.4-informational?style=flat-square)

Easily deploy and configure a maddy mail server. This chart handles a fair bit of setup, however, additional work
needs to be done to properly configure all the DNS records. For a complete guide on setting up DNS for maddy, see the
user guide: https://maddy.email/tutorials/setting-up/

## Maintainers

| Name          | Email | Url              |
| ------------- | ----- | ---------------- |
| Mya Pitzeruse |       | <https://mya.sh> |

## Source Code

- <https://github.com/foxcpp/maddy>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/maddy>

## Requirements

| Repository     | Name       | Version |
| -------------- | ---------- | ------- |
| https://mya.sh | litestream | 22.4.4  |

## Values

| Key                                          | Type   | Default                      | Description                                                                                                             |
| -------------------------------------------- | ------ | ---------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| affinity                                     | object | `{}`                         | Specify affinity rules for the pods.                                                                                    |
| autoscaling.enabled                          | bool   | `false`                      | Enable autoscaling for the deployment.                                                                                  |
| autoscaling.maxReplicas                      | int    | `100`                        | Specify the maximum number of replicas.                                                                                 |
| autoscaling.minReplicas                      | int    | `1`                          | Specify the minimum number of replicas.                                                                                 |
| autoscaling.targetCPUUtilizationPercentage   | int    | `80`                         | Specify the percent CPU utilization that causes the pods to autoscale.                                                  |
| config.database.dsn                          | string | `""`                         | Configure the DSN used to connect to a Postgres database.                                                               |
| config.domains.mx                            | string | `""`                         | Configure the mx domain used by the system. This _should_ align with the ingress address for the service.               |
| config.domains.primary                       | string | `""`                         | Configure the primary email domain that is managed by this server.                                                      |
| config.tls.certPath                          | string | `""`                         | Configure the full chain certificate path for TLS.                                                                      |
| config.tls.keyPath                           | string | `""`                         | Configure the private key path for TLS.                                                                                 |
| externalConfig.secretRef.name                | string | `""`                         | Specify the name of the secret containing the raw configuration.                                                        |
| extraVolumeMounts                            | list   | `[]`                         | Add additional volume mounts to the pod.                                                                                |
| extraVolumes                                 | list   | `[]`                         | Add additional volumes to the pod.                                                                                      |
| fullnameOverride                             | string | `""`                         | Override the full name of the release.                                                                                  |
| image.pullPolicy                             | string | `"IfNotPresent"`             | The pull policy to use for the image.                                                                                   |
| image.repository                             | string | `"foxcpp/maddy"`             | The repository hosting the email server image.                                                                          |
| image.tag                                    | string | `"0.5.4"`                    | Overrides the image tag whose default is the chart appVersion.                                                          |
| imagePullSecrets                             | list   | `[]`                         | Specify the secret containing the registry credentials.                                                                 |
| litestream.enabled                           | bool   | `false`                      | Whether to enable litestream for SQLite backup, recovery, and replication.                                              |
| litestream.extraVolumeMounts[0].mountPath    | string | `"/data"`                    | The path where the databases can be located.                                                                            |
| litestream.extraVolumeMounts[0].name         | string | `"data"`                     | The name of the data directory to mount. Defaults to the database volume created by `persistence.enabled`.              |
| litestream.metrics.serviceMonitor.enabled    | bool   | `false`                      | Enable metric collection for litestream.                                                                                |
| litestream.metrics.serviceMonitor.interval   | string | `"10s"`                      | Configure the interval at which metrics are collected for litestream.                                                   |
| metrics.serviceMonitor.enabled               | bool   | `false`                      | Enable metric collection for maddy.                                                                                     |
| metrics.serviceMonitor.interval              | string | `"10s"`                      | Configure the interval at which metrics are collected for maddy.                                                        |
| mta_sts.enabled                              | bool   | `false`                      | Whether to enable MTA-STS to proactively protect against attacks.                                                       |
| mta_sts.image.pullPolicy                     | string | `"IfNotPresent"`             | The pull policy to use for the nginx image.                                                                             |
| mta_sts.image.repository                     | string | `"nginx"`                    | The repository hosting the nginx server image.                                                                          |
| mta_sts.image.tag                            | string | `"1.25-alpine"`              | Configure the version of nginx to run.                                                                                  |
| mta_sts.ingress.annotations                  | object | `{}`                         | Specify annotations for the ingress.                                                                                    |
| mta_sts.ingress.enabled                      | bool   | `false`                      | Configure an ingress for the MTA-STS well-known configuration.                                                          |
| mta_sts.ingress.hosts[0].host                | string | `"chart-example.local"`      | Specify the domain host for the ingress.                                                                                |
| mta_sts.ingress.tls                          | list   | `[]`                         | Configure TLS for the ingress.                                                                                          |
| nameOverride                                 | string | `""`                         | Override the name of the release.                                                                                       |
| nodeSelector                                 | object | `{}`                         | Specify the node selector used to control which nodes registry pods are deployed to.                                    |
| persistence.accessMode                       | string | `"ReadWriteOnce"`            | Configure the access mode of the volume.                                                                                |
| persistence.enabled                          | bool   | `true`                       | Enable persistence for this deployment. This will configure a SQLite driver for storing information.                    |
| persistence.existingClaim                    | string | `""`                         | Specify the name of an existing PersistentVolumeClaim to use.                                                           |
| persistence.resources.storage                | string | `"10Gi"`                     | Specify the size of the volume.                                                                                         |
| persistence.storageClass                     | string | `""`                         | Specify the storage class that should provision this claim.                                                             |
| podAnnotations                               | object | `{}`                         | Annotations to add to the pod, typically used for assume roles.                                                         |
| podSecurityContext                           | object | `{}`                         | Specify the security context for the entire pod.                                                                        |
| replicaCount                                 | int    | `1`                          | The number of registry replicas to deploy.                                                                              |
| resources                                    | object | `{}`                         | Specify the resources for the pod.                                                                                      |
| rspamd.config."actions.conf"                 | string | `""`                         | Override configuration in the actions.conf file.                                                                        |
| rspamd.config."antivirus.conf"               | string | `""`                         | Override configuration in the antivirus.conf file.                                                                      |
| rspamd.config."antivirus_group.conf"         | string | `""`                         | Override configuration in the antivirus_group.conf file.                                                                |
| rspamd.config."arc.conf"                     | string | `""`                         | Override configuration in the arc.conf file.                                                                            |
| rspamd.config."asn.conf"                     | string | `""`                         | Override configuration in the asn.conf file.                                                                            |
| rspamd.config."chartable.conf"               | string | `""`                         | Override configuration in the chartable.conf file.                                                                      |
| rspamd.config."classifier-bayes.conf"        | string | `""`                         | Override configuration in the classifier-bayes.conf file.                                                               |
| rspamd.config."clickhouse.conf"              | string | `""`                         | Override configuration in the clickhouse.conf file.                                                                     |
| rspamd.config."composites.conf"              | string | `""`                         | Override configuration in the composites.conf file.                                                                     |
| rspamd.config."content_group.conf"           | string | `""`                         | Override configuration in the content_group.conf file.                                                                  |
| rspamd.config."dcc.conf"                     | string | `""`                         | Override configuration in the dcc.conf file.                                                                            |
| rspamd.config."dkim.conf"                    | string | `""`                         | Override configuration in the dkim.conf file.                                                                           |
| rspamd.config."dkim_signing.conf"            | string | `""`                         | Override configuration in the dkim_signing.conf file.                                                                   |
| rspamd.config."dmarc.conf"                   | string | `""`                         | Override configuration in the dmarc.conf file.                                                                          |
| rspamd.config."elastic.conf"                 | string | `""`                         | Override configuration in the elastic.conf file.                                                                        |
| rspamd.config."emails.conf"                  | string | `""`                         | Override configuration in the emails.conf file.                                                                         |
| rspamd.config."excessb64_group.conf"         | string | `""`                         | Override configuration in the excessb64_group.conf file.                                                                |
| rspamd.config."excessqp_group.conf"          | string | `""`                         | Override configuration in the excessqp_group.conf file.                                                                 |
| rspamd.config."external_services.conf"       | string | `""`                         | Override configuration in the external_services.conf file.                                                              |
| rspamd.config."external_services_group.conf" | string | `""`                         | Override configuration in the external_services_group.conf file.                                                        |
| rspamd.config."fann_redis.conf"              | string | `""`                         | Override configuration in the fann_redis.conf file.                                                                     |
| rspamd.config."file.conf"                    | string | `""`                         | Override configuration in the file.conf file.                                                                           |
| rspamd.config."force_actions.conf"           | string | `""`                         | Override configuration in the force_actions.conf file.                                                                  |
| rspamd.config."forged_recipients.conf"       | string | `""`                         | Override configuration in the forged_recipients.conf file.                                                              |
| rspamd.config."fuzzy_group.conf"             | string | `""`                         | Override configuration in the fuzzy_group.conf file.                                                                    |
| rspamd.config."greylist.conf"                | string | `""`                         | Override configuration in the greylist.conf file.                                                                       |
| rspamd.config."groups.conf"                  | string | `""`                         | Override configuration in the groups.conf file.                                                                         |
| rspamd.config."headers_group.conf"           | string | `""`                         | Override configuration in the headers_group.conf file.                                                                  |
| rspamd.config."hfilter.conf"                 | string | `""`                         | Override configuration in the hfilter.conf file.                                                                        |
| rspamd.config."hfilter_group.conf"           | string | `""`                         | Override configuration in the hfilter_group.conf file.                                                                  |
| rspamd.config."history_redis.conf"           | string | `""`                         | Override configuration in the history_redis.conf file.                                                                  |
| rspamd.config."http_headers.conf"            | string | `""`                         | Override configuration in the http_headers.conf file.                                                                   |
| rspamd.config."logging.inc"                  | string | `""`                         | Override configuration in the logging.inc file.                                                                         |
| rspamd.config."maillist.conf"                | string | `""`                         | Override configuration in the maillist.conf file.                                                                       |
| rspamd.config."metadata_exporter.conf"       | string | `""`                         | Override configuration in the metadata_exporter.conf file.                                                              |
| rspamd.config."metric_exporter.conf"         | string | `""`                         | Override configuration in the metric_exporter.conf file.                                                                |
| rspamd.config."metrics.conf"                 | string | `""`                         | Override configuration in the metrics.conf file.                                                                        |
| rspamd.config."mid.conf"                     | string | `""`                         | Override configuration in the mid.conf file.                                                                            |
| rspamd.config."milter_headers.conf"          | string | `""`                         | Override configuration in the milter_headers.conf file.                                                                 |
| rspamd.config."mime_types.conf"              | string | `""`                         | Override configuration in the mime_types.conf file.                                                                     |
| rspamd.config."mime_types_group.conf"        | string | `""`                         | Override configuration in the mime_types_group.conf file.                                                               |
| rspamd.config."mua_group.conf"               | string | `""`                         | Override configuration in the mua_group.conf file.                                                                      |
| rspamd.config."multimap.conf"                | string | `""`                         | Override configuration in the multimap.conf file.                                                                       |
| rspamd.config."mx_check.conf"                | string | `""`                         | Override configuration in the mx_check.conf file.                                                                       |
| rspamd.config."neural.conf"                  | string | `""`                         | Override configuration in the neural.conf file.                                                                         |
| rspamd.config."neural_group.conf"            | string | `""`                         | Override configuration in the neural_group.conf file.                                                                   |
| rspamd.config."once_received.conf"           | string | `""`                         | Override configuration in the once_received.conf file.                                                                  |
| rspamd.config."options.inc"                  | string | `""`                         | Override configuration in the options.inc file.                                                                         |
| rspamd.config."p0f.conf"                     | string | `""`                         | Override configuration in the p0f.conf file.                                                                            |
| rspamd.config."phishing.conf"                | string | `""`                         | Override configuration in the phishing.conf file.                                                                       |
| rspamd.config."phishing_group.conf"          | string | `""`                         | Override configuration in the phishing_group.conf file.                                                                 |
| rspamd.config."policies_group.conf"          | string | `""`                         | Override configuration in the policies_group.conf file.                                                                 |
| rspamd.config."ratelimit.conf"               | string | `""`                         | Override configuration in the ratelimit.conf file.                                                                      |
| rspamd.config."rbl.conf"                     | string | `""`                         | Override configuration in the rbl.conf file.                                                                            |
| rspamd.config."rbl_group.conf"               | string | `""`                         | Override configuration in the rbl_group.conf file.                                                                      |
| rspamd.config."redis.conf"                   | string | `""`                         | Override configuration in the redis.conf file.                                                                          |
| rspamd.config."regexp.conf"                  | string | `""`                         | Override configuration in the regexp.conf file.                                                                         |
| rspamd.config."replies.conf"                 | string | `""`                         | Override configuration in the replies.conf file.                                                                        |
| rspamd.config."reputation.conf"              | string | `""`                         | Override configuration in the reputation.conf file.                                                                     |
| rspamd.config."rmilter_headers.conf"         | string | `""`                         | Override configuration in the rmilter_headers.conf file.                                                                |
| rspamd.config."rspamd_update.conf"           | string | `""`                         | Override configuration in the rspamd_update.conf file.                                                                  |
| rspamd.config."settings.conf"                | string | `""`                         | Override configuration in the settings.conf file.                                                                       |
| rspamd.config."spamassassin.conf"            | string | `""`                         | Override configuration in the spamassassin.conf file.                                                                   |
| rspamd.config."spamtrap.conf"                | string | `""`                         | Override configuration in the spamtrap.conf file.                                                                       |
| rspamd.config."spf.conf"                     | string | `""`                         | Override configuration in the spf.conf file.                                                                            |
| rspamd.config."statistic.conf"               | string | `""`                         | Override configuration in the statistic.conf file.                                                                      |
| rspamd.config."statistics.conf"              | string | `""`                         | Override configuration in the statistics.conf file.                                                                     |
| rspamd.config."statistics_group.conf"        | string | `""`                         | Override configuration in the statistics_group.conf file.                                                               |
| rspamd.config."subject_group.conf"           | string | `""`                         | Override configuration in the subject_group.conf file.                                                                  |
| rspamd.config."surbl.conf"                   | string | `""`                         | Override configuration in the surbl.conf file.                                                                          |
| rspamd.config."surbl_group.conf"             | string | `""`                         | Override configuration in the surbl_group.conf file.                                                                    |
| rspamd.config."trie.conf"                    | string | `""`                         | Override configuration in the trie.conf file.                                                                           |
| rspamd.config."url_redirector.conf"          | string | `""`                         | Override configuration in the url_redirector.conf file.                                                                 |
| rspamd.config."whitelist.conf"               | string | `""`                         | Override configuration in the whitelist.conf file.                                                                      |
| rspamd.config."whitelist_group.conf"         | string | `""`                         | Override configuration in the whitelist_group.conf file.                                                                |
| rspamd.config."worker-normal.inc"            | string | `""`                         | Override configuration in the worker-normal.inc file.                                                                   |
| rspamd.enabled                               | bool   | `true`                       | Whether to enable rspamd to handle spam assignment.                                                                     |
| rspamd.image.pullPolicy                      | string | `"IfNotPresent"`             | The pull policy to use for the rspamd image.                                                                            |
| rspamd.image.repository                      | string | `"img.pitz.tech/mya/rspamd"` | The repository hosting the rspamd image                                                                                 |
| rspamd.image.tag                             | string | `"22.4.1-alpine"`            | Configure the container version of rspamd to run.                                                                       |
| securityContext                              | object | `{}`                         | Specify the security context for the `registry` container.                                                              |
| service.annotations                          | object | `{}`                         | Annotations to add to the service, typically used for ingress control.                                                  |
| service.type                                 | string | `"LoadBalancer"`             | Specify the type of service to create.                                                                                  |
| serviceAccount.annotations                   | object | `{}`                         | Annotations to add to the service account.                                                                              |
| serviceAccount.create                        | bool   | `true`                       | Specifies whether a service account should be created.                                                                  |
| serviceAccount.name                          | string | `""`                         | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| tolerations                                  | list   | `[]`                         | Specify taints that the registry pods are willing to tolerate.                                                          |

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

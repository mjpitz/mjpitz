# renovate

![Version: 23.10.0](https://img.shields.io/badge/Version-23.10.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 35.14.4](https://img.shields.io/badge/AppVersion-35.14.4-informational?style=flat-square)

Renovate enables teams to stay on top of the latest versions of their software dependencies.

## Maintainers

| Name          | Email | Url                  |
| ------------- | ----- | -------------------- |
| Mya Pitzeruse |       | <https://mjpitz.com> |

## Source Code

- <https://github.com/mjpitz/mjpitz/tree/main/charts/auth>

## Values

| Key                           | Type   | Default               | Description                                                                                                                  |
| ----------------------------- | ------ | --------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| affinity                      | object | `{}`                  | Specify affinity rules for the pods.                                                                                         |
| config                        | object | `{}`                  | Specify configuration specifically for the self-hosted renovate bot. https://docs.renovatebot.com/self-hosted-configuration/ |
| env                           | list   | `[]`                  | Environment variables provided to the application.                                                                           |
| envFrom                       | list   | `[]`                  | Load additional environment variables from secrets or config maps.                                                           |
| externalConfig.secretRef.name | string | `""`                  | Specify the name of the secret containing the raw configuration.                                                             |
| failedJobsHistoryLimit        | int    | `1`                   | Configured how many failed jobs will remain in the pod history.                                                              |
| fullnameOverride              | string | `""`                  | Override the full name of the release.                                                                                       |
| github.token                  | string | `""`                  | Specify the GitHub token used increase GitHub API rate limits when generating release notes.                                 |
| image.pullPolicy              | string | `"IfNotPresent"`      | The pull policy to use for the image.                                                                                        |
| image.repository              | string | `"renovate/renovate"` | The repository hosting the container image.                                                                                  |
| image.tag                     | string | `""`                  | Overrides the image tag whose default is the chart appVersion.                                                               |
| imagePullSecrets              | list   | `[]`                  | Specify the secret containing the registry credentials.                                                                      |
| nameOverride                  | string | `""`                  | Override the name of the release.                                                                                            |
| nodeSelector                  | object | `{}`                  | Specify the node selector used to control which nodes registry pods are deployed to.                                         |
| podAnnotations                | object | `{}`                  | Annotations to add to the pod, typically used for assume roles.                                                              |
| podSecurityContext            | object | `{}`                  | Specify the security context for the entire pod.                                                                             |
| resources                     | object | `{}`                  | Specify the resources for the pod.                                                                                           |
| schedule                      | string | `"@hourly"`           | Configure the schedule of the renovate CronJob.                                                                              |
| securityContext               | object | `{}`                  | Specify the security context for the `registry` container.                                                                   |
| serviceAccount.annotations    | object | `{}`                  | Annotations to add to the service account.                                                                                   |
| serviceAccount.create         | bool   | `true`                | Specifies whether a service account should be created.                                                                       |
| serviceAccount.name           | string | `""`                  | The name of the service account to use. If not set and create is true, a name is generated using the fullname template.      |
| successfulJobsHistoryLimit    | int    | `3`                   | Configure how many successful jobs will remain in the pod history.                                                           |
| suspend                       | bool   | `false`               | Suspend pauses the CronJob.                                                                                                  |
| timeZone                      | string | `""`                  | Specify the time zone in which the cron schedule should be executed.                                                         |
| tolerations                   | list   | `[]`                  | Specify taints that the registry pods are willing to tolerate.                                                               |

---

Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

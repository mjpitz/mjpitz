# storj

![Version: 22.4.1](https://img.shields.io/badge/Version-22.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

Easily add a Storj S3 gateway to any Deployment, DaemonSet, or StatefulSet using a sidecar. This chart optionally
deploys the required configuration and provides template functions that render the necessary sidecar containers.

## Usage

First, add the dependency to your `Chart.yaml` file. Like any dependency, you're going to need to run `helm dep up` to
fetch the dependency before installing.

```yaml
# ...
dependencies:
  # ...
  - name: storj
    version: 22.4.1
    repository: https://mjpitz.com
    condition: storj.enabled
```

Then, you'll need to add the appropriate block to your `Deployment`, `StatefulSet`, or `DaemonSet`.

```yaml
{{- $storjConfig := dict "Chart" (dict "Name" "storj") "Values" .Values.storj "Release" .Release -}}
# ...
spec:
  # ...
  template:
    # ...
    spec:
      # ...
      containers:
        # ...
        {{- if .Values.storj.enabled }}
        {{- include "storj.container" $storjConfig | nindent 8 }}
        {{- end }}
```

Finally, we'll need to add some additional configuration to the `values.yaml` file.

```yaml
# ...
storj:
  enabled: false
```

That should be it.

## Maintainers

| Name          | Email | Url                  |
| ------------- | ----- | -------------------- |
| Mya Pitzeruse |       | <https://mjpitz.com> |

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

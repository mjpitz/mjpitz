# litestream

![Version: 22.4.2](https://img.shields.io/badge/Version-22.4.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.3.9](https://img.shields.io/badge/AppVersion-0.3.9-informational?style=flat-square)

Easily add litestream to any sqlite backed application as a sidecar. This chart optionally deploys the required
configuration and provides template functions that render the necessary init and sidecar containers.

## Usage

First, add the dependency to your `Chart.yaml` file. Like any dependency, you're going to need to run `helm dep up` to
fetch the dependency before installing.

```yaml
# ...
dependencies:
  # ...
  - name: litestream
    version: 22.4.2
    repository: https://mjpitz.com
    condition: litestream.enabled
```

Then, you'll need to add the appropriate block to your `Deployment`, `StatefulSet`, or `DaemonSet`.

```yaml
{{- $litestreamConfig := dict "Chart" (dict "Name" "litestream") "Values" .Values.litestream "Release" .Release -}}
# ...
spec:
  # ...
  template:
    # ...
    spec:
      {{- if .Values.litestream.enabled }}
      # ...
      initContainers:
        {{- include "litestream.init-container" $litestreamConfig | nindent 8 }}
      {{- end }}
      # ...
      containers:
        # ...
        {{- if .Values.litestream.enabled }}
        {{- include "litestream.container" $litestreamConfig | nindent 8 }}
        {{- end }}
      volumes:
        # ...
        {{- if .Values.litestream.enabled }}
        {{- include "litestream.volume" $litestreamConfig | nindent 8 }}
        {{- end }}
```

Finally, we'll need to add some additional configuration to the `values.yaml` file.

```yaml
# ...
litestream:
  enabled: false

  # customize this as needed
  extraVolumeMounts:
    - name: data
      mountPath: /data/

  config:
    dbs:
      - path: /data/db.sqlite
        replicas: []
```

That should be it.

## Maintainers

| Name          | Email | Url                  |
| ------------- | ----- | -------------------- |
| Mya Pitzeruse |       | <https://mjpitz.com> |

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
| image.tag                     | string | `"0.3.9"`                 | Overrides the image tag whose default is the chart appVersion.                                                                                         |
| imagePullSecrets              | list   | `[]`                      | Specify the secret containing the registry credentials.                                                                                                |
| metrics.enabled               | bool   | `false`                   | Whether metrics reporting should be enabled.                                                                                                           |
| metrics.port                  | int    | `9090`                    | The port to run the metrics server on.                                                                                                                 |
| nameOverride                  | string | `""`                      | Override the name of the release.                                                                                                                      |
| resources                     | object | `{}`                      | Specify the resources for the pod.                                                                                                                     |
| securityContext               | object | `{}`                      | Specify the security context for the `litestream` container.                                                                                           |

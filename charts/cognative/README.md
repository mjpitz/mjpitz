# cognative

![Version: 0.2403.3](https://img.shields.io/badge/Version-0.2403.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

cognative is an opinionated, minimalistic approach to business intelligence 🧠 and operations 🚨. We strongly believe
companies should be able to own their own data, and many solutions out there leave organizations to the whims of
third-party providers. Our goal is to reduce the complexity of traditional business intelligence and operations
stacks, while seeking to maximize the efforts of everyday operations staff. This not only simplifies the process for
operators, but also enhances the experience for less infrastructure-aware developers.

(BETA) This chart provides an early access preview to the cogantive stack. It currently not suitable for production.
I'm hoping to iterate on this stack in the public, and am actively looking for help from others to push it forward.

**Homepage:** <https://mjpitz.github.io/cognative/>

## Maintainers

| Name                  | Email | Url                                   |
| --------------------- | ----- | ------------------------------------- |
| Mya Pitzeruse         |       | <https://mya.sh>                      |
| The cognative authors |       | <https://github.com/mjpitz/cognative> |

## Source Code

- <https://github.com/mjpitz/cognative>
- <https://github.com/mjpitz/mjpitz/tree/main/charts/cognative>

## Requirements

| Repository                                                 | Name                               | Version  |
| ---------------------------------------------------------- | ---------------------------------- | -------- |
| https://grafana.github.io/helm-charts                      | grafana                            | 7.3.7    |
| https://mya.sh                                             | clickhouse                         | 0.2403.1 |
| https://open-telemetry.github.io/opentelemetry-helm-charts | collector(opentelemetry-collector) | 0.84.0   |
| https://open-telemetry.github.io/opentelemetry-helm-charts | cluster(opentelemetry-collector)   | 0.84.0   |
| https://open-telemetry.github.io/opentelemetry-helm-charts | node(opentelemetry-collector)      | 0.84.0   |

## Values

| Key                                                                           | Type   | Default                                                                     | Description                                                                                                            |
| ----------------------------------------------------------------------------- | ------ | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| clickhouse.auth.password                                                      | string | `"clickhouse"`                                                              | Specify the password used to authenticate with the clickhouse cluster.                                                 |
| clickhouse.auth.username                                                      | string | `"clickhouse"`                                                              | Specify the username used to authenticate with the clickhouse cluster.                                                 |
| clickhouse.enabled                                                            | bool   | `true`                                                                      | Enable a single instance, clickhouse deployment.                                                                       |
| cluster.config.exporters.otlp/2.endpoint                                      | string | `"{{ .Release.Name }}-collector:4317"`                                      | Specify the location of the collector deployment.                                                                      |
| cluster.enabled                                                               | bool   | `true`                                                                      | Enable the cluster-agent process that monitors and collects metrics for the control plane of your cluster.             |
| cluster.replicaCount                                                          | int    | `1`                                                                         | The number of cluster-agent instances to run.                                                                          |
| collector.config.exporters.clickhouse.endpoint                                | string | `"tcp://{{ .Release.Name }}-clickhouse:9000?dial_timeout=10s&compress=lz4"` | Specify the location of the clickhouse deployment.                                                                     |
| collector.config.exporters.clickhouse.password                                | string | `"clickhouse"`                                                              | Specify the password used to authenticate with the clickhouse cluster.                                                 |
| collector.config.exporters.clickhouse.ttl                                     | string | `"72h"`                                                                     | Configure how long logs, metrics, and traces are preserved for.                                                        |
| collector.config.exporters.clickhouse.username                                | string | `"clickhouse"`                                                              | Specify the username used to authenticate with the clickhouse cluster.                                                 |
| collector.enabled                                                             | bool   | `true`                                                                      | Enable the collector process which is responsible for interfacing with the underlying Clickhouse deployment.           |
| collector.replicaCount                                                        | int    | `1`                                                                         | The number of collector instances to run.                                                                              |
| grafana.adminPassword                                                         | string | `"admin"`                                                                   | Specify the password used to authenticate the admin password.                                                          |
| grafana.adminUser                                                             | string | `"admin"`                                                                   | Specify the username of the admin account.                                                                             |
| grafana.datasources."clickhouse.yaml".datasources[0].jsonData.defaultDatabase | string | `"default"`                                                                 | Specify the default database to connect to when communicating with the clickhouse cluster.                             |
| grafana.datasources."clickhouse.yaml".datasources[0].jsonData.host            | string | `"{{ .Release.Name }}-clickhouse"`                                          | Specify the location of the clickhouse deployment.                                                                     |
| grafana.datasources."clickhouse.yaml".datasources[0].jsonData.port            | int    | `9000`                                                                      | Specify the port of the clickhouse deployment.                                                                         |
| grafana.datasources."clickhouse.yaml".datasources[0].jsonData.protocol        | string | `"native"`                                                                  | Specify the protocol used to communicate with the clickhouse.                                                          |
| grafana.datasources."clickhouse.yaml".datasources[0].jsonData.username        | string | `"clickhouse"`                                                              | Specify the username used to authenticate with the clickhouse cluster.                                                 |
| grafana.datasources."clickhouse.yaml".datasources[0].secureJsonData.password  | string | `"clickhouse"`                                                              | Specify the password used to authenticate with the clickhouse cluster.                                                 |
| grafana.enabled                                                               | bool   | `true`                                                                      | Enable the grafana deployment.                                                                                         |
| grafana.plugins                                                               | list   | `["grafana-clickhouse-datasource"]`                                         | Add additional plugins to install in your grafana deployment, but be sure to include the grafana-clickhouse-datasource |
| node.config.exporters.otlp/2.endpoint                                         | string | `"{{ .Release.Name }}-collector:4317"`                                      | Specify the location of the collector deployment.                                                                      |
| node.enabled                                                                  | bool   | `true`                                                                      | Enable the node-agent process that monitors and collects metrics for each host in your cluster.                        |

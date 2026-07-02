# metrics

![Version: 1.2607.1](https://img.shields.io/badge/Version-1.2607.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

(BETA) Iceberg-backed analytics stack: Altinity ice REST catalog, Altinity ClickHouse (Antalya build),
Grafana with a Valkey remote cache. Replaces the standalone clickhouse + cognative charts.

## Components

- **[Altinity ice](https://github.com/Altinity/ice)** — Iceberg REST catalog. SQLite-backed on a PVC; warehouse in S3.
- **[Altinity ClickHouse (Antalya)](https://docs.altinity.com/altinityantalya/)** — query engine with `DataLakeCatalog` engine for real-time Iceberg reads. Optional MergeTree tiered storage to S3.
- **[Grafana](https://grafana.com)** — dashboarding + data exploration. SQLite persistence, single instance.
- **[Valkey](https://valkey.io)** — Grafana's `[remote_cache]` backend. Single instance with AOF persistence.

## Prerequisites

- **S3 buckets** — up to three, all optional but recommended distinct:
  - `warehouse.s3` — Iceberg data files. Shared: ice writes, clickhouse reads.
  - `iceberg.storage.meta.s3` — Iceberg metadata bucket. Same values as `warehouse.s3` co-locates metadata with data; a different bucket wires up `write.metadata.path`.
  - `clickhouse.storage.cold.s3` — MergeTree tiered cold tier. Only rendered when `clickhouse.storage.cold.enabled: true`.
- **Required credentials** — fail at render time if empty: `clickhouse.admin.password`, `clickhouse.users.grafana.password`, plus S3 access keys for whichever buckets you enable.
- **Grafana auth** — the chart does not create a local admin user (`disable_initial_admin_creation = true` by default). Wire up an external auth backend (OAuth, generic OIDC, etc.) via `grafana.ini` sections and `grafana.extraEnv` before hitting the UI.

## Usage

Deploy via helmfile with credentials sourced from 1Password (or plain `helm install` with `--set` for local testing):

```gotmpl
# helmfile.yaml
releases:
  - name: metrics
    namespace: metrics
    chart: mya/metrics
    version: 1.2607.1
    needs:
      - ingress/traefik
      - longhorn-system/longhorn
    set:
      - name: warehouse.s3.accessKeyId
        value: {{ requiredEnv "METRICS_S3_ACCESS_KEY_ID" | quote }}
      - name: warehouse.s3.secretAccessKey
        value: {{ requiredEnv "METRICS_S3_SECRET_ACCESS_KEY" | quote }}
      - name: clickhouse.admin.password
        value: {{ requiredEnv "METRICS_CH_ADMIN_PASSWORD" | quote }}
      - name: clickhouse.users.grafana.password
        value: {{ requiredEnv "METRICS_CH_GRAFANA_PASSWORD" | quote }}
      # ...plus warehouse.s3.{endpoint,region,bucket} and matching iceberg meta / clickhouse cold blocks
```

## Customizing ClickHouse databases

`clickhouse.databases` is a structured map — `engine`, `engineArgs` (positional constructor args), and `settings` (key=value SETTINGS clause) are all tpl-rendered against the chart context, so you can reference `include` helpers and `.Values`:

```gotmpl
clickhouse:
  databases:
    iceberg:
      engine: DataLakeCatalog
      engineArgs:
        - 'http://{{ include "metrics.iceberg.fullname" . }}:5000'
      settings:
        catalog_type: rest
        auth_header: 'Authorization: Bearer {{ include "metrics.iceberg.bearerToken" . }}'
        warehouse: 's3://{{ .Values.warehouse.s3.bucket }}/'
```

For anything past database creation (CREATE TABLE, ALTER, materialized views), use `clickhouse.extraSql` — also tpl-rendered, runs after databases and before role/user setup.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Mya Pitzeruse | <charts@mya.sh> | <https://mya.sh> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clickhouse.admin.password | string | `""` | Admin password (plaintext in values, SHA256-hashed at render time). Required. |
| clickhouse.admin.username | string | `"admin"` | Admin username. Written to users.d/admin.xml with the `access_management` privilege. |
| clickhouse.databases | object | `{"default":{"engine":"Atomic"},"iceberg":{"engine":"DataLakeCatalog","engineArgs":["http://{{ include \"metrics.iceberg.fullname\" . }}:5000"],"settings":{"auth_header":"Authorization: Bearer {{ include \"metrics.iceberg.bearerToken\" . }}","catalog_type":"rest","warehouse":"s3://{{ .Values.warehouse.s3.bucket }}/"}}}` | Databases created by the post-install/post-upgrade Job. Map of database name to    `{engine, engineArgs, settings}`. Each entry becomes:      CREATE DATABASE IF NOT EXISTS <name>        ENGINE = <engine>(<engineArgs...>)        SETTINGS <k1>='<v1>', <k2>='<v2>', ...;    `engineArgs` and `settings` are optional. All string fields are tpl-rendered against    the chart's context, so you can reference `include` helpers and `.Values`. |
| clickhouse.extraSql | list | `[]` | Extra SQL statements run after `databases` but before roles/users. Each entry is    tpl-rendered. Use for CREATE TABLE, ALTER, materialized views, or any DDL not    expressible as a `databases` map entry. |
| clickhouse.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| clickhouse.image.repository | string | `"altinity/clickhouse-server"` | ClickHouse image repository. Must be Altinity's Antalya build for DataLakeCatalog support. |
| clickhouse.image.tag | string | `"25.8.22.20001.altinityantalya"` | ClickHouse image tag. Pin an explicit `*.altinityantalya` version. |
| clickhouse.persistence.accessMode | string | `"ReadWriteOnce"` | PVC access mode. |
| clickhouse.persistence.annotations | object | `{}` | Additional annotations on the clickhouse PVC. |
| clickhouse.persistence.enabled | bool | `true` | Enable the clickhouse data PVC. |
| clickhouse.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one from `volumeClaimTemplates`. |
| clickhouse.persistence.labels | object | `{}` | Additional labels on the clickhouse PVC. |
| clickhouse.persistence.resources.storage | string | `"20Gi"` | PVC size for clickhouse local data (system tables, cache, access storage). |
| clickhouse.persistence.storageClass | string | `""` | StorageClass for the clickhouse PVC. |
| clickhouse.podAnnotations | object | `{}` | Additional annotations on the clickhouse pod. |
| clickhouse.podLabels | object | `{}` | Additional labels on the clickhouse pod. |
| clickhouse.profiles | object | `{"default":{"load_balancing":"random","max_memory_usage":"10000000000","use_uncompressed_cache":"0"},"readonly":{"max_memory_usage":"10000000000","readonly":"1"}}` | ClickHouse settings profiles. Map of profile name to a map of setting name → value.    Rendered into users.d/profiles.xml so profiles exist before any user in init.sql    references them. Values must be strings so large integers keep their exact form    (10000000000, not 1e+10) — ClickHouse's XML parser doesn't accept scientific notation. |
| clickhouse.resources | object | `{}` | Container resource requests/limits for the clickhouse pod. |
| clickhouse.roles | object | `{"ingest":{"grants":["SELECT, INSERT, ALTER ON default.*","CREATE TABLE, DROP TABLE ON default.*"]},"reader":{"grants":["SELECT ON default.*","SELECT ON iceberg.*"]},"writer":{"grants":["SELECT, INSERT ON default.*"]}}` | Named permission bundles. Map of role name to `{grants: [SQL fragment, ...]}`. Rendered    as `CREATE ROLE IF NOT EXISTS` + `GRANT` statements in init.sql. Users reference roles    via `clickhouse.users.<name>.roles`. |
| clickhouse.serviceAccount.annotations | object | `{}` | Annotations to add to the clickhouse service account. Reused by the init Job. |
| clickhouse.serviceAccount.name | string | `""` | Override the clickhouse service account name. Defaults to `<release>-clickhouse`. |
| clickhouse.storage.cold.enabled | bool | `false` | Enable MergeTree tiered storage. When true, renders `storage_configuration` +    `s3_tiered` policy in config.d/s3.xml. |
| clickhouse.storage.cold.s3.accessKeyId | string | `""` | Cold-tier access key id. |
| clickhouse.storage.cold.s3.bucket | string | `""` | Cold-tier bucket name. |
| clickhouse.storage.cold.s3.endpoint | string | `""` | Cold-tier S3 endpoint URL. |
| clickhouse.storage.cold.s3.pathStyleAccess | bool | `true` | Use path-style addressing. |
| clickhouse.storage.cold.s3.region | string | `""` | Cold-tier S3 region. |
| clickhouse.storage.cold.s3.secretAccessKey | string | `""` | Cold-tier secret access key. |
| clickhouse.users | object | `{"grafana":{"hostRule":"ANY","password":"","profile":"readonly","roles":["reader"]}}` | Application users. Map of user name to `{password, profile, hostRule, roles}`. Passwords    are SHA256-hashed at chart render time. Users are SQL-managed via local_directory storage,    so passwords can be rotated (and users added/removed) without pod restarts. `password` is    required per user; `roles` references entries in `clickhouse.roles`. |
| commonAnnotations | object | `{}` | Annotations merged into metadata.annotations of every resource in this chart. |
| commonLabels | object | `{}` | Labels merged into metadata.labels of every resource in this chart. |
| fullnameOverride | string | `""` | Override the fully qualified release name. |
| grafana.cache.auth.password | string | `""` | Valkey password. Empty = no auth (cluster-internal only). |
| grafana.cache.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| grafana.cache.image.repository | string | `"valkey/valkey"` | Valkey image repository. |
| grafana.cache.image.tag | string | `"8.0-alpine"` | Valkey image tag. |
| grafana.cache.persistence.accessMode | string | `"ReadWriteOnce"` | PVC access mode. |
| grafana.cache.persistence.annotations | object | `{}` | Additional annotations on the valkey PVC. |
| grafana.cache.persistence.enabled | bool | `true` | Enable the valkey AOF PVC. |
| grafana.cache.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one from `volumeClaimTemplates`. |
| grafana.cache.persistence.labels | object | `{}` | Additional labels on the valkey PVC. |
| grafana.cache.persistence.resources.storage | string | `"1Gi"` | PVC size for the valkey AOF. Session cache is regenerable so this can stay small. |
| grafana.cache.persistence.storageClass | string | `""` | StorageClass for the valkey PVC. |
| grafana.cache.podAnnotations | object | `{}` | Additional annotations on the valkey pod. |
| grafana.cache.podLabels | object | `{}` | Additional labels on the valkey pod. |
| grafana.cache.resources | object | `{}` | Container resource requests/limits for the valkey pod. |
| grafana.cache.serviceAccount.annotations | object | `{}` | Annotations to add to the valkey service account. |
| grafana.cache.serviceAccount.name | string | `""` | Override the valkey service account name. Defaults to `<release>-cache`. |
| grafana.extraDatasources | list | `[]` | Additional datasources appended alongside the built-in ClickHouse datasource.    Each entry is a full Grafana datasource object. Rendered into    `/etc/grafana/provisioning/datasources/extras.yaml`. |
| grafana.extraEnv | list | `[]` | Additional env vars appended to the grafana container. Accepts entries with    either `value` or `valueFrom` (secretKeyRef/configMapKeyRef). |
| grafana.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| grafana.image.repository | string | `"grafana/grafana"` | Grafana image repository. |
| grafana.image.tag | string | `"11.5.0"` | Grafana image tag. |
| grafana.ingress.annotations | object | `{}` | Annotations on the Ingress (cert-manager, external-dns, traefik middlewares, etc.). |
| grafana.ingress.enabled | bool | `true` | Enable the grafana Ingress. Grafana is the only externally exposed component. |
| grafana.ingress.hosts | list | `[]` | Ingress hosts (e.g. `[{ host: metrics.mya.sh }]`). |
| grafana.ingress.tls | list | `[]` | Ingress TLS entries (e.g. `[{ secretName: metrics-tls, hosts: [metrics.mya.sh] }]`). |
| grafana.ini | object | `{}` | Additional `grafana.ini` sections merged over chart defaults. Each top-level    key is an INI section; nested keys become `key = value` lines. User-provided    keys override chart defaults for the same section (e.g. add `auth.generic_oauth`    to wire up OAuth, since the chart disables the built-in admin by default). |
| grafana.persistence.accessMode | string | `"ReadWriteOnce"` | PVC access mode. |
| grafana.persistence.annotations | object | `{}` | Additional annotations on the grafana PVC. |
| grafana.persistence.enabled | bool | `true` | Enable the grafana data PVC (holds `/var/lib/grafana` with the SQLite DB + plugins). |
| grafana.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one from `volumeClaimTemplates`. |
| grafana.persistence.labels | object | `{}` | Additional labels on the grafana PVC. |
| grafana.persistence.resources.storage | string | `"10Gi"` | PVC size for grafana data. |
| grafana.persistence.storageClass | string | `""` | StorageClass for the grafana PVC. |
| grafana.plugins | list | `["grafana-clickhouse-datasource"]` | Plugins installed via `GF_INSTALL_PLUGINS`. Keep the ClickHouse datasource    plugin unless you have a specific reason to remove it. |
| grafana.podAnnotations | object | `{}` | Additional annotations on the grafana pod. |
| grafana.podLabels | object | `{}` | Additional labels on the grafana pod. |
| grafana.provisioning.alerting | object | `{}` | Content of `/etc/grafana/provisioning/alerting/alerting.yaml`. |
| grafana.provisioning.dashboardProviders | object | `{}` | Content of `/etc/grafana/provisioning/dashboards/providers.yaml`    (a full Grafana dashboard providers config). Set alongside `dashboards`    to actually load JSON files from `/etc/grafana/provisioning/dashboards/files/`. |
| grafana.provisioning.dashboards | object | `{}` | Dashboards to bake in. Map of filename → dashboard JSON (string or object).    Files land under `/etc/grafana/provisioning/dashboards/files/<filename>`. |
| grafana.provisioning.notifiers | object | `{}` | Content of `/etc/grafana/provisioning/notifiers/notifiers.yaml` (legacy notifiers). |
| grafana.resources | object | `{}` | Container resource requests/limits for the grafana pod. |
| grafana.serviceAccount.annotations | object | `{}` | Annotations to add to the grafana service account. |
| grafana.serviceAccount.name | string | `""` | Override the grafana service account name. Defaults to `<release>-grafana`. |
| iceberg.auth.bearerToken | string | `""` | Bearer token clickhouse presents to the REST catalog. If empty, a    deterministic default is derived from the release name. |
| iceberg.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| iceberg.image.repository | string | `"altinity/ice-rest-catalog"` | Iceberg REST catalog image repository. |
| iceberg.image.tag | string | `"0.17.0"` | Iceberg REST catalog image tag. |
| iceberg.persistence.accessMode | string | `"ReadWriteOnce"` | PVC access mode. |
| iceberg.persistence.annotations | object | `{}` | Additional annotations on the iceberg PVC. |
| iceberg.persistence.enabled | bool | `true` | Enable the SQLite PVC for the iceberg REST catalog. |
| iceberg.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one from `volumeClaimTemplates`. |
| iceberg.persistence.labels | object | `{}` | Additional labels on the iceberg PVC. |
| iceberg.persistence.resources.storage | string | `"5Gi"` | PVC size for the iceberg SQLite database. |
| iceberg.persistence.storageClass | string | `""` | StorageClass for the iceberg PVC. |
| iceberg.podAnnotations | object | `{}` | Additional annotations on the iceberg pod. |
| iceberg.podLabels | object | `{}` | Additional labels on the iceberg pod. |
| iceberg.resources | object | `{}` | Container resource requests/limits for the iceberg pod. |
| iceberg.serviceAccount.annotations | object | `{}` | Annotations to add to the iceberg service account (e.g. IRSA role ARNs). |
| iceberg.serviceAccount.name | string | `""` | Override the iceberg service account name. Defaults to `<release>-iceberg`. |
| iceberg.storage.meta.s3.accessKeyId | string | `""` | Metadata bucket access key id. |
| iceberg.storage.meta.s3.bucket | string | `""` | Metadata bucket name. Same as `warehouse.s3.bucket` co-locates metadata with data. |
| iceberg.storage.meta.s3.endpoint | string | `""` | Metadata bucket S3 endpoint URL. |
| iceberg.storage.meta.s3.pathStyleAccess | bool | `true` | Use path-style addressing. |
| iceberg.storage.meta.s3.region | string | `""` | Metadata bucket S3 region. |
| iceberg.storage.meta.s3.secretAccessKey | string | `""` | Metadata bucket secret access key. |
| imagePullSecrets | list | `[]` | Registry pull secrets. |
| nameOverride | string | `""` | Override the chart name portion of the release name. |
| warehouse.s3.accessKeyId | string | `""` | Access key id used by both ice (to write) and clickhouse (to read via named_collection). |
| warehouse.s3.bucket | string | `""` | Bucket name for Iceberg data files. |
| warehouse.s3.endpoint | string | `""` | S3 endpoint URL (e.g. https://ny3.digitaloceanspaces.com). |
| warehouse.s3.pathStyleAccess | bool | `true` | Use path-style addressing. Required for most non-AWS S3-compatible providers. |
| warehouse.s3.region | string | `""` | S3 region. |
| warehouse.s3.secretAccessKey | string | `""` | Secret access key paired with accessKeyId. |

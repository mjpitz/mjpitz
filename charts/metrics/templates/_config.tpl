{{/* ------------------------------------------------------------------------
     Iceberg REST catalog config.yaml
     ------------------------------------------------------------------------ */}}
{{- define "metrics.iceberg.config" -}}
{{- $wh := .Values.warehouse.s3 -}}
{{- $meta := .Values.iceberg.storage.meta.s3 -}}
uri: jdbc:sqlite:file:/var/lib/ice/db.sqlite?journal_mode=WAL&synchronous=OFF&journal_size_limit=500

warehouse: s3://{{ $wh.bucket }}/

s3:
  endpoint: {{ $wh.endpoint | quote }}
  pathStyleAccess: {{ $wh.pathStyleAccess }}
  accessKeyID: {{ $wh.accessKeyId | quote }}
  secretAccessKey: {{ $wh.secretAccessKey | quote }}
  region: {{ $wh.region | quote }}

{{- if and $meta.bucket (ne $meta.bucket $wh.bucket) }}
catalogProperties:
  write.metadata.path: s3://{{ $meta.bucket }}/
{{- end }}

bearerTokens:
  - value: {{ include "metrics.iceberg.bearerToken" . | quote }}

anonymousAccess:
  enabled: false
{{- end -}}

{{/* ------------------------------------------------------------------------
     ClickHouse config.d/docker.xml — listeners.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.clickhouse.dockerConfig" -}}
<clickhouse>
  <listen_host>::</listen_host>
  <listen_host>0.0.0.0</listen_host>
  <listen_try>1</listen_try>

  <logger>
    <console>1</console>
  </logger>
</clickhouse>
{{- end -}}

{{/* ------------------------------------------------------------------------
     ClickHouse config.d/user_directories.xml — enable local_directory storage
     so users created via SQL persist across pod restarts.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.clickhouse.userDirectoriesConfig" -}}
<clickhouse>
  <user_directories replace="replace">
    <users_xml>
      <path>/etc/clickhouse-server/users.xml</path>
    </users_xml>
    <local_directory>
      <path>/var/lib/clickhouse/access/</path>
    </local_directory>
  </user_directories>
</clickhouse>
{{- end -}}

{{/* ------------------------------------------------------------------------
     ClickHouse config.d/s3.xml — Iceberg named collection (points at the
     iceberg data bucket) + optional MergeTree tiered storage policy (points at
     the independent clickhouse cold bucket).
     ------------------------------------------------------------------------ */}}
{{- define "metrics.clickhouse.s3Config" -}}
{{- $wh := .Values.warehouse.s3 -}}
{{- $cold := .Values.clickhouse.storage.cold -}}
<clickhouse>
  <named_collections>
    <iceberg_conf>
      <url>{{ $wh.endpoint }}/{{ $wh.bucket }}/</url>
      <access_key_id>{{ $wh.accessKeyId }}</access_key_id>
      <secret_access_key>{{ $wh.secretAccessKey }}</secret_access_key>
      <region>{{ $wh.region }}</region>
    </iceberg_conf>
  </named_collections>
  {{- if $cold.enabled }}
  <storage_configuration>
    <disks>
      <s3_disk>
        <type>s3</type>
        <endpoint>{{ $cold.s3.endpoint }}/{{ $cold.s3.bucket }}/</endpoint>
        <access_key_id>{{ $cold.s3.accessKeyId }}</access_key_id>
        <secret_access_key>{{ $cold.s3.secretAccessKey }}</secret_access_key>
        <region>{{ $cold.s3.region }}</region>
        <metadata_path>/var/lib/clickhouse/disks/s3_disk/</metadata_path>
      </s3_disk>
    </disks>
    <policies>
      <s3_tiered>
        <volumes>
          <hot>
            <disk>default</disk>
          </hot>
          <cold>
            <disk>s3_disk</disk>
          </cold>
        </volumes>
      </s3_tiered>
    </policies>
  </storage_configuration>
  {{- end }}
</clickhouse>
{{- end -}}

{{/* ------------------------------------------------------------------------
     ClickHouse users.d/admin.xml — the bootstrap admin identity.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.clickhouse.adminUser" -}}
{{- if not .Values.clickhouse.admin.password -}}
{{- fail "clickhouse.admin.password is required" -}}
{{- end -}}
<clickhouse>
  <users>
    <{{ .Values.clickhouse.admin.username }}>
      <password_sha256_hex>{{ .Values.clickhouse.admin.password | sha256sum }}</password_sha256_hex>
      <networks>
        <ip>::/0</ip>
      </networks>
      <profile>default</profile>
      <quota>default</quota>
      <access_management>1</access_management>
      <named_collection_control>1</named_collection_control>
      <show_named_collections>1</show_named_collections>
      <show_named_collections_secrets>1</show_named_collections_secrets>
    </{{ .Values.clickhouse.admin.username }}>
  </users>
</clickhouse>
{{- end -}}

{{/* ------------------------------------------------------------------------
     ClickHouse users.d/profiles.xml — settings profiles.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.clickhouse.profiles" -}}
<clickhouse>
  <profiles>
    {{- range $name, $settings := .Values.clickhouse.profiles }}
    <{{ $name }}>
      {{- range $k, $v := $settings }}
      <{{ $k }}>{{ $v }}</{{ $k }}>
      {{- end }}
    </{{ $name }}>
    {{- end }}
  </profiles>
</clickhouse>
{{- end -}}

{{/* ------------------------------------------------------------------------
     ClickHouse init.sql — databases + extra DDL + roles + users + grants, run
     by the post-install/post-upgrade Helm hook Job. String fields are
     tpl-rendered against the chart's context.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.clickhouse.initSql" -}}
-- Databases
{{- $root := . -}}
{{- range $name, $db := .Values.clickhouse.databases }}
{{- $stmt := printf "CREATE DATABASE IF NOT EXISTS %s ENGINE = %s" $name $db.engine }}
{{- with $db.engineArgs }}
{{- $args := list }}
{{- range . }}{{ $args = append $args (printf "'%s'" (tpl . $root)) }}{{ end }}
{{- $stmt = printf "%s(%s)" $stmt (join ", " $args) }}
{{- end }}
{{- with $db.settings }}
{{- $settings := list }}
{{- range $k, $v := . }}{{ $settings = append $settings (printf "%s = '%s'" $k (tpl $v $root)) }}{{ end }}
{{- $stmt = printf "%s SETTINGS %s" $stmt (join ", " $settings) }}
{{- end }}
{{ $stmt }};
{{- end }}

{{- with .Values.clickhouse.extraSql }}

-- Extra DDL (clickhouse.extraSql)
{{- range . }}
{{ tpl . $root }}
{{- end }}
{{- end }}

-- Roles (created before users so DEFAULT ROLE can resolve)
{{- range $name, $role := .Values.clickhouse.roles }}
CREATE ROLE IF NOT EXISTS {{ $name }};
{{- end }}

-- Role grants
{{- range $name, $role := .Values.clickhouse.roles }}
{{- range $role.grants }}
GRANT {{ . }} TO {{ $name }};
{{- end }}
{{- end }}

-- Users
{{- range $name, $user := .Values.clickhouse.users }}
{{- if not $user.password }}{{- fail (printf "clickhouse.users.%s.password is required" $name) }}{{- end }}
{{- $hash := $user.password | sha256sum }}
{{- $host := $user.hostRule | default "ANY" }}
{{- $profile := $user.profile | default "default" }}
{{- $roles := $user.roles | default (list) }}
{{- $defaultRole := ternary (join ", " $roles) "NONE" (gt (len $roles) 0) }}
CREATE USER IF NOT EXISTS {{ $name }}
  IDENTIFIED WITH sha256_hash BY '{{ $hash }}'
  HOST {{ $host }}
  SETTINGS PROFILE '{{ $profile }}'
  DEFAULT ROLE {{ $defaultRole }};
ALTER USER {{ $name }} IDENTIFIED WITH sha256_hash BY '{{ $hash }}';
ALTER USER {{ $name }} SETTINGS PROFILE '{{ $profile }}';
ALTER USER {{ $name }} DEFAULT ROLE {{ $defaultRole }};
{{- range $roles }}
GRANT {{ . }} TO {{ $name }};
{{- end }}
{{- end }}
{{- end -}}

{{/* ------------------------------------------------------------------------
     Grafana grafana.ini — chart defaults merged with `.Values.grafana.ini`.
     User-provided section keys override defaults for the same section.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.grafana.ini" -}}
{{- $cache := include "metrics.valkey.cache.fullname" . -}}
{{- $cachePass := .Values.grafana.cache.auth.password -}}
{{- $connstr := printf "addr=%s:6379,pool_size=100,db=0" $cache -}}
{{- if $cachePass -}}{{- $connstr = printf "%s,password=%s" $connstr $cachePass -}}{{- end -}}
{{- $server := dict "http_port" 3000 -}}
{{- if gt (len .Values.grafana.ingress.hosts) 0 -}}
{{- $host := (index .Values.grafana.ingress.hosts 0).host -}}
{{- $_ := set $server "domain" $host -}}
{{- $_ := set $server "root_url" (printf "https://%s/" $host) -}}
{{- end -}}
{{- $defaults := dict
    "paths" (dict "data" "/var/lib/grafana")
    "server" $server
    "database" (dict "type" "sqlite3" "path" "grafana.db")
    "remote_cache" (dict "type" "redis" "connstr" $connstr)
    "security" (dict "disable_initial_admin_creation" true)
    "users" (dict "allow_sign_up" false)
-}}
{{- $merged := mergeOverwrite $defaults (deepCopy .Values.grafana.ini) -}}
{{- range $section, $keys := $merged }}
[{{ $section }}]
{{- range $k, $v := $keys }}
{{ $k }} = {{ $v }}
{{- end }}

{{ end -}}
{{- end -}}

{{/* ------------------------------------------------------------------------
     Grafana datasource provisioning — ClickHouse only. Grafana connects as the
     `grafana` clickhouse user (readonly), NOT admin.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.grafana.datasource" -}}
{{- $grafanaUser := index .Values.clickhouse.users "grafana" -}}
{{- if not $grafanaUser }}{{- fail "clickhouse.users.grafana must be defined so grafana can query clickhouse" }}{{- end }}
apiVersion: 1
datasources:
  - name: ClickHouse
    type: grafana-clickhouse-datasource
    access: proxy
    isDefault: true
    editable: true
    jsonData:
      host: {{ include "metrics.clickhouse.fullname" . }}
      port: 9000
      protocol: native
      secure: false
      username: grafana
      defaultDatabase: default
    secureJsonData:
      password: {{ $grafanaUser.password | quote }}
{{- end -}}

{{/* ------------------------------------------------------------------------
     Grafana extra datasource provisioning — user-supplied datasources appended
     alongside the built-in ClickHouse one. Rendered into a second file so the
     built-in stays untouched.
     ------------------------------------------------------------------------ */}}
{{- define "metrics.grafana.extraDatasources" -}}
apiVersion: 1
datasources:
{{ toYaml .Values.grafana.extraDatasources }}
{{- end -}}

{{/* ------------------------------------------------------------------------
     Valkey (cache) valkey.conf
     ------------------------------------------------------------------------ */}}
{{- define "metrics.valkey.cache.config" -}}
port 6379
protected-mode no

tcp-backlog 511
tcp-keepalive 300
timeout 0
always-show-logo no

dir /data

appendonly yes
appendfilename "db.aof"
appendfsync everysec

{{- if .Values.grafana.cache.auth.password }}
requirepass {{ .Values.grafana.cache.auth.password | quote }}
{{- end }}
{{- end -}}

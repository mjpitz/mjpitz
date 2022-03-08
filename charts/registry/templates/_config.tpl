{{/*
Render the redis configuration file
*/}}
{{- define "registry.config" -}}
version: 0.1

log:
  level: debug

http:
  secret: {{ .Values.config.http.secret | quote }}
  addr: ":5000"
  debug:
    addr: ":5001"
    prometheus:
      enabled: true
      path: /metrics
  headers:
    X-Content-Type-Options: [nosniff]

storage:
  {{- .Values.config.storage | toYaml | nindent 2 }}
  {{- if .Values.storj.enabled }}
  s3:
    accesskey: {{ .Values.storj.config.accessKeyId }}
    secretkey: {{ .Values.storj.config.secretAccessKey }}
    regionendpoint: http://127.0.0.1:7777
    bucket: {{ .Values.storj.config.bucket }}
    region: {{ .Values.storj.config.region }}
#      v4auth: true
#      chunksize: 5242880
#      multipartcopychunksize: 33554432
#      multipartcopymaxconcurrency: 100
#      multipartcopythresholdsize: 33554432
#      rootdirectory: /s3/object/name/prefix
  {{- end }}
  {{- if .Values.redis.enabled }}
  cache:
    blobdescriptor: redis
  {{- end }}

{{- if .Values.redis.enabled }}
# point at envoy
redis:
  addr: "127.0.0.1:6379"
  password: ""
  db: {{ .Values.redis.config.db }}
  dialtimeout: {{ .Values.redis.config.dialtimeout }}
  readtimeout: {{ .Values.redis.config.readtimeout }}
  writetimeout: {{ .Values.redis.config.writetimeout }}
  pool:
    maxidle: {{ .Values.redis.config.pool.maxidle }}
    maxactive: {{ .Values.redis.config.pool.maxactive }}
    idletimeout: {{ .Values.redis.config.pool.idletimeout }}
{{- end }}

{{- if .Values.auth.enabled }}
auth:
  token:
    issuer: {{ .Values.auth.config.token.issuer | quote }}
    realm: {{ .Values.auth.config.token.realm | quote }}
    service: {{ .Values.auth.config.token.service | quote }}
    rootcertbundle: {{ .Values.auth.config.token.certificate | quote }}
{{- end }}

{{- if .Values.config.middleware }}
middleware:
  {{- .Values.config.middleware | toYaml | nindent 2 }}
{{- end }}

{{- if .Values.config.reporting }}
reporting:
  {{- .Values.config.reporting | toYaml | nindent 2 }}
{{- end }}

{{- if .Values.config.notifications }}
notifications:
  {{- .Values.config.notifications | toYaml | nindent 2 }}
{{- end }}

{{- if .Values.config.proxy }}
proxy:
  {{- .Values.config.proxy | toYaml | nindent 2 }}
{{- end }}

{{- if .Values.config.compatibility }}
compatibility:
  {{- .Values.config.compatibility | toYaml | nindent 2 }}
{{- end }}

{{- if .Values.config.validation }}
validation:
  {{- .Values.config.validation | toYaml | nindent 2 }}
{{- end }}

{{- if or .Values.config.storage .Values.redis.enabled }}
health:
  {{- if or .Values.config.storage }}
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
  {{- end }}
  {{- if .Values.redis.enabled }}
  tcp:
    - addr: "127.0.0.1:6379"
      timeout: 3s
      interval: 10s
      threshold: 3
  {{- end }}
{{- end }}

{{- end -}}

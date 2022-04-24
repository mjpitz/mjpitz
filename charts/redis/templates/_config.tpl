{{/* Render the redis configuration file. */}}
{{- define "redis.config" -}}
{{/* TODO : support TLS */}}
port 6379

tcp-backlog 511
tcp-keepalive 300
timeout 0
always-show-logo no

databases {{ .Values.config.databases }}

{{- if .Values.config.maxMemory.size }}
maxmemory {{ .Values.config.maxMemory.size }}
maxmemory-policy {{ .Values.config.maxMemory.evictionPolicy }}
{{- end }}

{{- if .Values.config.data.directory }}
dir {{ .Values.config.data.directory }}
{{- end }}

{{- if .Values.config.data.snapshot.enabled }}
{{- range $tuple := .Values.config.data.snapshot.schedules }}
save {{ index $tuple 0 }} {{ index $tuple 1 }}
{{- end }}
dbfilename snapshot.rdb
rdbcompression {{ .Values.config.data.snapshot.compression | ternary "yes" "no" }}
{{- end }}

{{- if .Values.config.data.appendOnlyFile.enabled }}
appendonly yes
appendfilename db.aof
appendfsync {{ .Values.config.data.appendOnlyFile.fsync }}
{{- end }}

{{- if .Values.config.username }}
masteruser {{ .Values.config.username }}
{{- end }}

{{- if .Values.config.password }}
masterauth {{ .Values.config.password }}
{{- end }}
{{- end -}}

{{/* Render the envoy cluster configuration file. */}}
{{- define "redis.cluster.config" -}}
static_resources:
  listeners:
    - name: redis
      address:
        socket_address:
          address: 127.0.0.1
          port_value: 6379
      filter_chains:
        - filters:
            - name: envoy.filters.network.redis_proxy
              typed_config:
                "@type": type.googleapis.com/envoy.extensions.filters.network.redis_proxy.v3.RedisProxy
                stat_prefix: redis
                settings:
                  op_timeout: 5s
                prefix_routes:
                  catch_all_route:
                    cluster: redis
                {{- if .Values.config.username }}
                downstream_auth_username:
                  inline_string: {{ .Values.config.username }}
                {{- end }}
                {{- if .Values.config.password }}
                downstream_auth_password:
                  inline_string: {{ .Values.config.password }}
                {{- end }}
  clusters:
    - name: redis
      type: STRICT_DNS
      lb_policy: MAGLEV
      load_assignment:
        cluster_name: redis
        endpoints:
          - lb_endpoints:
              - endpoint:
                  address:
                    socket_address:
                      address: {{ include "redis.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local
                      port_value: 6379
      health_checks:
        - timeout: 5s
          interval: 20s
          unhealthy_threshold: 3
          healthy_threshold: 1
          custom_health_check:
            name: envoy.health_checkers.redis
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.health_checkers.redis.v3.Redis
              key: _/envoy

admin:
  address:
    socket_address:
      address: 127.0.0.1
      port_value: 8001
{{- end -}}

{{/* Render the envoy sidecar container. */}}
{{- define "redis.cluster.container" -}}
- name: envoy
  image: "{{ .Values.cluster.image.repository }}:{{ .Values.cluster.image.tag }}"
  imagePullPolicy: {{ .Values.cluster.image.pullPolicy }}
  ports:
    - name: redis
      containerPort: 6379
      protocol: TCP
    - name: admin
      containerPort: 8001
      protocol: TCP
  volumeMounts:
    - mountPath: /etc/envoy
      name: {{ include "redis.fullname" . }}-cluster-config
      readOnly: true
{{- end -}}

{{/* Render the envoy configuration volume thats mount by the sidecar. */}}
{{- define "redis.cluster.volume" -}}
- name: {{ include "redis.fullname" . }}-cluster-config
  secret:
    secretName: {{ include "redis.fullname" . }}-cluster-config
{{- end -}}

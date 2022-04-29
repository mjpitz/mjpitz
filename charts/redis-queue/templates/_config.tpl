{{/* Render the redis configuration file. */}}
{{- define "redis-queue.config" -}}
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

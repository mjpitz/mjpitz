{{/* Render the litestream init container */}}
{{- define "litestream.init-container" -}}
{{- $defaultSecretName := include "litestream.fullname" . | printf "%s-config" -}}
{{- $secretName := .Values.externalConfig.secretRef.name | default $defaultSecretName -}}
- name: init-litestream
  securityContext:
    {{- toYaml .Values.securityContext | nindent 4 }}
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command:
    - sh
    - -c
    - |
      {{- range .Values.config.dbs }}
      litestream restore -if-db-not-exists -if-replica-exists {{ .path }};
      {{- end }}
  volumeMounts:
    - name: {{ include "litestream.fullname" . }}-config
      mountPath: /etc/litestream.yml
      subPath: litestream.yml
    {{- with .Values.extraVolumeMounts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end -}}

{{/* Render the litestream sidecar container */}}
{{- define "litestream.container" -}}
{{- $defaultSecretName := include "litestream.fullname" . | printf "%s-config" -}}
{{- $secretName := .Values.externalConfig.secretRef.name | default $defaultSecretName -}}
- name: litestream
  securityContext:
    {{- toYaml .Values.securityContext | nindent 4 }}
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  args:
    - replicate
  {{- if .Values.metrics.enabled }}
  ports:
    - name: litestream
      containerPort: {{ .Values.metrics.port }}
      protocol: TCP
  {{- end }}
  resources:
    {{- toYaml .Values.resources | nindent 4 }}
  volumeMounts:
    - name: {{ include "litestream.fullname" . }}-config
      mountPath: /etc/litestream.yml
      subPath: litestream.yml
    {{- with .Values.extraVolumeMounts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end -}}

{{/* Render the litestream configuration */}}
{{- define "litestream.config" -}}
{{- if .Values.metrics.enabled }}
addr: ":{{ .Values.metrics.port }}"
{{- end }}

{{- with .Values.config.accessKeyId }}
access-key-id: {{ . }}
{{- end }}

{{- with .Values.config.secretAccessKey }}
secret-access-key: {{ . }}
{{- end }}

{{- with .Values.config.dbs }}
dbs:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}

{{/* Render the litestream configuration volume thats mount by the sidecar. */}}
{{- define "litestream.volume" -}}
- name: {{ include "litestream.fullname" . }}-config
  secret:
    {{- if .Values.externalConfig.secretRef.name }}
    secretName: {{ .Values.externalConfig.secretRef.name }}
    {{- else }}
    secretName: {{ include "litestream.fullname" . }}-config
    {{- end }}
{{- end -}}

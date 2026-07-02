{{/*
Expand the name of the chart.
*/}}
{{- define "metrics.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
Truncated at 63 chars because some Kubernetes name fields are limited by DNS.
*/}}
{{- define "metrics.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart name + version, for the helm.sh/chart label.
*/}}
{{- define "metrics.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Per-component fullnames.
*/}}
{{- define "metrics.iceberg.fullname" -}}
{{- printf "%s-iceberg" (include "metrics.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "metrics.clickhouse.fullname" -}}
{{- printf "%s-clickhouse" (include "metrics.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "metrics.grafana.fullname" -}}
{{- printf "%s-grafana" (include "metrics.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "metrics.valkey.cache.fullname" -}}
{{- printf "%s-cache" (include "metrics.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels. Callers typically pass a dict of `component` (and optionally overrides
of `.` via `merge`) as the invocation context.

  {{- include "metrics.labels" (dict "component" "iceberg" "root" .) | nindent 4 }}
*/}}
{{- define "metrics.labels" -}}
{{- $root := .root -}}
helm.sh/chart: {{ include "metrics.chart" $root }}
{{ include "metrics.selectorLabels" . }}
{{- if $root.Chart.AppVersion }}
app.kubernetes.io/version: {{ $root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $root.Release.Service }}
{{- with $root.Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels. Includes app.kubernetes.io/component so each StatefulSet's
selector is distinct — critical when multiple workloads share a release.
*/}}
{{- define "metrics.selectorLabels" -}}
{{- $root := .root -}}
app.kubernetes.io/name: {{ include "metrics.name" $root }}
app.kubernetes.io/instance: {{ $root.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Per-component service account names. Each defaults to the component fullname
unless overridden via <component>.serviceAccount.name.
*/}}
{{- define "metrics.iceberg.serviceAccountName" -}}
{{- default (include "metrics.iceberg.fullname" .) .Values.iceberg.serviceAccount.name }}
{{- end }}

{{- define "metrics.clickhouse.serviceAccountName" -}}
{{- default (include "metrics.clickhouse.fullname" .) .Values.clickhouse.serviceAccount.name }}
{{- end }}

{{- define "metrics.grafana.serviceAccountName" -}}
{{- default (include "metrics.grafana.fullname" .) .Values.grafana.serviceAccount.name }}
{{- end }}

{{- define "metrics.valkey.cache.serviceAccountName" -}}
{{- default (include "metrics.valkey.cache.fullname" .) .Values.grafana.cache.serviceAccount.name }}
{{- end }}

{{/*
Common annotations helper. Emits nothing when commonAnnotations is empty.
Callers should wrap with `{{- with (include "metrics.commonAnnotations" .) }}\nannotations:\n{{ . | nindent 4 }}\n{{- end }}`.
*/}}
{{- define "metrics.commonAnnotations" -}}
{{- with .Values.commonAnnotations }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Iceberg bearer token — either the user-provided value or a deterministic default
derived from the release name. Consumed by both the iceberg config and the
clickhouse init.sql (DataLakeCatalog auth header).
*/}}
{{- define "metrics.iceberg.bearerToken" -}}
{{- default (printf "%s-token" (include "metrics.fullname" .)) .Values.iceberg.auth.bearerToken -}}
{{- end }}

{{/*
Render the redis configuration file
*/}}
{{- define "auth.config" -}}
# See [reference.yml][] for explanation for explanation of all options.
#
# [reference.yml]: https://github.com/cesanta/docker_auth/blob/main/examples/reference.yml
#

server:
  addr: ":5001"

token:
  {{- .Values.config.token | toYaml | nindent 2 }}

{{- if .Values.config.google_auth }}
google_auth:
  {{- .Values.config.google_auth | toYaml | nindent 2 }}
{{- else if .Values.config.github_auth }}
github_auth:
  {{- .Values.config.github_auth | toYaml | nindent 2 }}
{{- else if .Values.config.oidc_auth }}
oidc_auth:
  {{- .Values.config.oidc_auth | toYaml | nindent 2 }}
{{- else if .Values.config.gitlab_auth }}
gitlab_auth:
  {{- .Values.config.gitlab_auth | toYaml | nindent 2 }}
{{- else if .Values.config.ldap_auth }}
ldap_auth:
  {{- .Values.config.ldap_auth | toYaml | nindent 2 }}
{{- else if .Values.config.mongo_auth }}
mongo_auth:
  {{- .Values.config.mongo_auth | toYaml | nindent 2 }}
{{- else if .Values.config.xorm_auth }}
xorm_auth:
  {{- .Values.config.xorm_auth | toYaml | nindent 2 }}
{{- else if .Values.config.ext_auth }}
ext_auth:
  {{- .Values.config.ext_auth | toYaml | nindent 2 }}
{{- else }}
users:
  {{- .Values.config.users | toYaml | nindent 2 }}
{{- end }}

{{- if .Values.config.acl_mongo }}
acl_mongo:
  {{- .Values.config.acl_mongo | toYaml | nindent 2 }}
{{- else if .Values.config.acl_xorm }}
acl_xorm:
  {{- .Values.config.acl_xorm | toYaml | nindent 2 }}
{{- else if .Values.config.casbin_authz }}
casbin_authz:
  {{- .Values.config.casbin_authz | toYaml | nindent 2 }}
{{- else if .Values.config.ext_authz }}
ext_authz:
  {{- .Values.config.ext_authz | toYaml | nindent 2 }}
{{- else }}
acl:
  {{- .Values.config.acl | toYaml | nindent 2 }}
{{- end }}

{{- end -}}

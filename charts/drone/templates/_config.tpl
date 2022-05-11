{{- define "drone.config" -}}
DRONE_PROMETHEUS_ANONYMOUS_ACCESS=true
{{- if .Values.config.bitbucket.enabled }}
DRONE_BITBUCKET_CLIENT_ID={{ .Values.config.bitbucket.clientId }}
DRONE_BITBUCKET_CLIENT_SECRET={{ .Values.config.bitbucket.clientSecret }}
DRONE_BITBUCKET_DEBUG={{ .Values.config.bitbucket.debug }}
{{- else if .Values.config.git.enabled }}
DRONE_GIT_ALWAYS_AUTH={{ .Values.config.git.alwaysAuth }}
DRONE_GIT_PASSWORD={{ .Values.config.git.password }}
DRONE_GIT_USERNAME={{ .Values.config.git.username }}
{{- else if .Values.config.gitea.enabled }}
DRONE_GITEA_CLIENT_ID={{ .Values.config.gitea.clientId }}
DRONE_GITEA_CLIENT_SECRET={{ .Values.config.gitea.clientSecret }}
DRONE_GITEA_SERVER={{ .Values.config.gitea.server }}
DRONE_GITEA_SKIP_VERIFY={{ .Values.config.gitea.skipVerify }}
{{- else if .Values.config.gitee.enabled }}
DRONE_GITEE_REDIRECT_URL={{ .Values.config.gitee.redirectUrl }}
DRONE_GITEE_SCOPE={{ .Values.config.gitee.scope | concat (list "user_info" "projects" "pull_requests" "hook") | uniq | join "," }}
DRONE_GITEE_SKIP_VERIFY={{ .Values.config.gitee.skipVerify }}
{{- else if .Values.config.github.enabled }}
DRONE_GITHUB_CLIENT_ID={{ .Values.config.github.clientId }}
DRONE_GITHUB_CLIENT_SECRET={{ .Values.config.github.clientSecret }}
DRONE_GITHUB_SCOPE={{ .Values.config.github.scope | concat (list "repo" "repo:status" "user:email" "read:org") | uniq | join "," }}
DRONE_GITHUB_SERVER={{ .Values.config.github.server }}
DRONE_GITHUB_SKIP_VERIFY={{ .Values.config.github.skipVerify }}
{{- else if .Values.config.gitlab.enabled }}
DRONE_GITLAB_CLIENT_ID={{ .Values.config.gitlab.clientId }}
DRONE_GITLAB_CLIENT_SECRET={{ .Values.config.gitlab.clientSecret }}
DRONE_GITLAB_SERVER={{ .Values.config.gitlab.server }}
DRONE_GITLAB_SKIP_VERIFY={{ .Values.config.gitlab.skipVerify }}
{{- else if .Values.config.gogs.enabled }}
DRONE_GOGS_SERVER={{ .Values.config.gogs.server }}
DRONE_GOGS_SKIP_VERIFY={{ .Values.config.gogs.skipVerify }}
{{- else if .Values.config.stash.enabled }}
DRONE_STASH_CONSUMER_KEY={{ .Values.config.stash.consumerKey }}
DRONE_STASH_PRIVATE_KEY={{ .Values.config.stash.privateKeyFile }}
DRONE_STASH_SERVER={{ .Values.config.stash.server }}
DRONE_STASH_SKIP_VERIFY={{ .Values.config.stash.skipVerify }}
{{- end }}

DRONE_CLEANUP_DISABLED={{ .Values.config.cleanup.enabled | not }}
DRONE_CLEANUP_DEADLINE_PENDING={{ .Values.config.cleanup.deadline.pending }}
DRONE_CLEANUP_DEADLINE_RUNNING={{ .Values.config.cleanup.deadline.running }}
DRONE_CLEANUP_INTERVAL={{ .Values.config.cleanup.interval }}

DRONE_COOKIE_SECRET={{ .Values.config.cookie.secret }}
DRONE_COOKIE_TIMEOUT={{ .Values.config.cookie.timeout }}

DRONE_CRON_DISABLED={{ .Values.config.cron.enabled | not }}
DRONE_CRON_INTERVAL={{ .Values.config.cron.interval }}

DRONE_RPC_SECRET={{ .Values.config.rpc.secret | default .Values.global.rpc.secret }}
DRONE_SERVER_HOST={{ .Values.ingress.enabled | ternary (index .Values.ingress.hosts 0).host ""}}
DRONE_SERVER_PROTO={{ .Values.ingress.tls | empty | ternary "http" "https" }}

DRONE_STATUS_DISABLED=false
DRONE_STATUS_NAME=continuous-integration/drone

DRONE_DATABASE_DATASOURCE={{ .Values.config.database.datasource }}
DRONE_DATABASE_DRIVER={{ .Values.config.database.driver }}
DRONE_DATABASE_MAX_CONNECTIONS={{ .Values.config.database.maxConnections }}
{{- with .Values.config.database.secret }}
DRONE_DATABASE_SECRET={{ . }}
{{- end }}

{{- if (index .Values "redis-queue").enabled }}
{{- $redisQueueConfig := dict "Chart" (dict "Name" "redis-queue") "Values" (index .Values "redis-queue") "Release" .Release }}
DRONE_REDIS_CONNECTION=redis://{{ include "redis-queue.fullname" $redisQueueConfig }}:6379
{{- end }}

{{- if .Values.config.blobs.endpoint }}
DRONE_S3_BUCKET={{ .Values.config.blobs.bucket }}
DRONE_S3_ENDPOINT={{ .Values.config.blobs.endpoint }}
DRONE_S3_PATH_STYLE={{ .Values.config.blobs.pathStyle }}
DRONE_S3_PREFIX={{ .Values.config.blobs.prefix }}
AWS_ACCESS_KEY_ID={{ .Values.config.blobs.accessKeyId }}
AWS_SECRET_ACCESS_KEY={{ .Values.config.blobs.secretAccessKey }}
AWS_DEFAULT_REGION={{ .Values.config.blobs.region }}
AWS_REGION={{ .Values.config.blobs.region }}
{{- end }}

{{- if .Values.config.validate.endpoint }}
DRONE_VALIDATE_PLUGIN_ENDPOINT={{ .Values.config.validate.endpoint }}
DRONE_VALIDATE_PLUGIN_SECRET={{ .Values.config.validate.secret }}
DRONE_VALIDATE_PLUGIN_SKIP_VERIFY={{ .Values.config.validate.skipVerify }}
{{- end }}

{{- if .Values.config.webhook.endpoint }}
DRONE_WEBHOOK_ENDPOINT={{ .Values.config.webhook.endpoint | join "," }}
DRONE_WEBHOOK_EVENTS={{ .Values.config.webhook.events | join "," }}
DRONE_WEBHOOK_SECRET={{ .Values.config.webhook.secret }}
DRONE_WEBHOOK_SKIP_VERIFY={{ .Values.config.webhook.skipVerify }}
{{- end }}

{{- range $key, $value := .Values.config.overrides }}
{{ $key }}={{ $value }}
{{- end }}
{{- end -}}

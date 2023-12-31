{{/* Render the gitea configuration file. */}}
{{- define "gitea.config" -}}
{{- $redisQueue := index .Values "redis-queue" }}
{{- $redisQueueConfig := dict "Chart" (dict "Name" "redis-queue") "Values" $redisQueue "Release" .Release -}}
##====
## https://docs.gitea.io/en-us/config-cheat-sheet/
##====

APP_NAME: "Gitea: Git with a cup of tea"
RUN_MODE: prod
RUN_USER: git
{{- range $key, $value := .Values.config.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository]
ROOT = /data/git/repositories
{{- range $key, $value := .Values.config.repository.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository.editor]
{{- range $key, $value := .Values.config.repository.editor.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository.pull-request]
{{- range $key, $value := .Values.config.repository.pullRequest.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository.issue]
{{- range $key, $value := .Values.config.repository.issue.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository.upload]
TEMP_PATH = /data/scratch/uploads
{{- range $key, $value := .Values.config.repository.upload.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository.release]
{{- range $key, $value := .Values.config.repository.release.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository.signing]
{{- range $key, $value := .Values.config.repository.signing.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[repository.local]
LOCAL_COPY_PATH = /data/scratch/local-repo
{{- range $key, $value := .Values.config.repository.local.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[cors]
{{- range $key, $value := .Values.config.cors.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[ui]
{{- range $key, $value := .Values.config.ui.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[server]
{{- $protocol := .Values.ingress.tls | empty | not | and .Values.ingress.enabled | ternary "https" "http" }}
{{- $domain := .Values.ingress.enabled | ternary (index .Values.ingress.hosts 0).host "localhost" }}
{{- $port := .Values.ingress.enabled | ternary "" ":8080" }}
APP_DATA_PATH    = /data/gitea
PROTOCOL         = http
DOMAIN           = {{ $domain }}
HTTP_PORT        = 8080
SSH_LISTEN_PORT  = 2222
SSH_PORT         = 22
ROOT_URL         = {{ $protocol }}://{{ $domain }}{{ $port }}
LOCAL_ROOT_URL   = {{ $protocol }}://{{ $domain }}{{ $port }}
LFS_START_SERVER = true
{{- range $key, $value := .Values.config.server.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[database]
DB_TYPE  = {{ .Values.persistence.enabled | ternary "sqlite3" .Values.config.database.type }}
PATH     = /data/gitea/gitea.db
HOST     = {{ .Values.config.database.host }}
NAME     = {{ .Values.config.database.name }}
USER     = {{ .Values.config.database.username }}
PASSWD   = {{ .Values.config.database.password }}
LOG_SQL  = {{ .Values.config.database.log }}
SCHEMA   = {{ .Values.config.database.schema }}
SSL_MODE = {{ .Values.config.database.sslMode }}
CHARSET  = utf8

[indexer]
ISSUE_INDEXER_TYPE = {{ .Values.config.index.issues.type | default "bleve" }}
ISSUE_INDEXER_PATH = /data/gitea/indexes/issues.bleve
ISSUE_INDEXER_CONN_STR = {{ .Values.config.index.issues.connectionString }}

REPO_INDEXER_ENABLED = {{ .Values.config.index.code.enabled }}
REPO_INDEXER_TYPE = {{ .Values.config.index.code.type | default "bleve" }}
REPO_INDEXER_PATH = /data/gitea/indexes/code.bleve
REPO_INDEXER_CONN_STR = {{ .Values.config.index.code.connectionString }}

{{- $defaultQueueType := $redisQueue.enabled | ternary "redis" "persistable-channel" }}
{{- $defaultConnectionString := .Values.config.queues.connectionString }}
{{- if $defaultConnectionString | empty | and $redisQueue.enabled }}
{{- $defaultConnectionString = printf "redis://%s.%s.svc.cluster.local:6379" (include "redis-queue.fullname" $redisQueueConfig) .Release.Namespace }}
{{- end }}
{{- $queueType := .Values.config.queues.type | default $defaultQueueType }}
{{- $queues := .Values.config.queues }}

[queue.code_indexer]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.code_indexer.connectionString | default $defaultConnectionString }}/{{ $queues.code_indexer.db }}
DATA_DIR = /data/gitea/queues/code_indexer

[queue.issue_indexer]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.issue_indexer.connectionString | default $defaultConnectionString }}/{{ $queues.issue_indexer.db }}
DATA_DIR = /data/gitea/queues/issue_indexer

[queue.notification-service]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.notification_service.connectionString | default $defaultConnectionString }}/{{ $queues.notification_service.db }}
DATA_DIR = /data/gitea/queues/notification-service

[queue.task]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.task.connectionString | default $defaultConnectionString }}/{{ $queues.task.db }}
DATA_DIR = /data/gitea/queues/notification_service

[queue.mail]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.mail.connectionString | default $defaultConnectionString }}/{{ $queues.mail.db }}
DATA_DIR = /data/gitea/queues/mail

[queue.push_update]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.push_update.connectionString | default $defaultConnectionString }}/{{ $queues.push_update.db }}
DATA_DIR = /data/gitea/queues/push_update

[queue.repo_stats_update]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.repo_stats_update.connectionString | default $defaultConnectionString }}/{{ $queues.repo_stats_update.db }}
DATA_DIR = /data/gitea/queues/repo_stats_update

[queue.repo-archive]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.repo_archive.connectionString | default $defaultConnectionString }}/{{ $queues.repo_archive.db }}
DATA_DIR = /data/gitea/queues/repo-archive

[queue.mirror]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.mirror.connectionString | default $defaultConnectionString }}/{{ $queues.mirror.db }}
DATA_DIR = /data/gitea/queues/mirror

[queue.pr_patch_checker]
TYPE = {{ $queueType }}
CONN_STR = {{ $queues.pr_patch_checker.connectionString | default $defaultConnectionString }}/{{ $queues.pr_patch_checker.db }}
DATA_DIR = /data/gitea/queues/pr_patch_checker

[security]
INSTALL_LOCK                  = {{ .Values.config.security.installLock }}
SECRET_KEY                    = {{ .Values.config.security.secretKey | default (uuidv4 | sha256sum) }}
INTERNAL_TOKEN                = {{ .Values.config.security.internalToken | default (uuidv4 | sha256sum) }}
PASSWORD_HASH_ALGO            = pbkdf2
MIN_PASSWORD_LENGTH           = 8
PASSWORD_COMPLEXITY           = spec

[service]
{{- range $key, $value := .Values.config.service.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[service.explore]
{{- range $key, $value := .Values.config.service.explore.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[mailer]
ENABLED = {{ .Values.config.email.host | empty | not | ternary "true" "false" }}
SMTP_ADDR = {{ .Values.config.email.host }}:{{ .Values.config.email.port }}
FROM = {{ .Values.config.email.from }}
USER = {{ .Values.config.email.username }}
PASSWD = {{ .Values.config.email.password }}

[cache]
ENABLED = true
ADAPTER = {{ .Values.redis.enabled | ternary "redis" "memory" }}
INTERVAL = 60
ITEM_TTL = 16h
HOST = redis://127.0.0.1:6379/0

[session]
PROVIDER        = db
PROVIDER_CONFIG =

[picture]
{{- range $key, $value := .Values.config.picture.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[attachment]
{{- range $key, $value := .Values.config.attachment.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[log]
ROOT_PATH = /data/scratch/logs
{{- range $key, $value := .Values.config.log.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[metrics]
ENABLED = {{ .Values.metrics.enabled }}
{{- range $key, $value := .Values.config.metrics.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[oauth2]
ENABLED = true
ACCESS_TOKEN_EXPIRATION_TIME = 3600 # seconds
REFRESH_TOKEN_EXPIRATION_TIME = 730 # hours
JWT_SIGNING_PRIVATE_KEY_FILE = /data/gitea/jwt.pem

[migrations]
MAX_ATTEMPTS = 3
RETRY_BACKOFF = 3
ALLOWED_DOMAINS =
BLOCKED_DOMAINS =
ALLOW_LOCALNETWORKS = false
SKIP_TLS_VERIFY = false

[federation]
ENABLED = true

[packages]
ENABLED = {{ .Values.config.packages.enabled }}
CHUNKED_UPLOAD_PATH = /data/scratch/package-upload

[mirror]
ENABLED = true
DISABLE_NEW_PULL = false
DISABLE_NEW_PUSH = false
DEFAULT_INTERVAL = 8h
MIN_INTERVAL = 10m

[lfs]
PATH = /data/git/lfs
{{- range $key, $value := .Values.config.lfs.overrides }}
{{ $key }} = {{ $value }}
{{- end }}

[storage]
STORAGE_TYPE = {{ .Values.config.blobs.endpoint | empty | ternary "local" "minio" }}
PATH = /data/blobs
MINIO_ENDPOINT = {{ .Values.config.blobs.endpoint }}
MINIO_ACCESS_KEY_ID = {{ .Values.config.blobs.accessKeyId }}
MINIO_SECRET_ACCESS_KEY = {{ .Values.config.blobs.secretAccessKey }}
MINIO_BUCKET = {{ .Values.config.blobs.bucket }}
MINIO_LOCATION = {{ .Values.config.blobs.region }}
MINIO_USE_SSL = {{ .Values.config.blobs.useSSL }}

[webhook]
DELIVER_TIMEOUT = {{ .Values.config.webhook.deliveryTimeout }}
{{- if .Values.config.webhook.allowed }}
ALLOWED_HOST_LIST = {{ .Values.config.webhook.allowed | join "," }}
{{- end }}

[other]
SHOW_FOOTER_BRANDING = false
SHOW_FOOTER_VERSION = true
SHOW_FOOTER_TEMPLATE_LOAD_TIME = true
{{- end }}

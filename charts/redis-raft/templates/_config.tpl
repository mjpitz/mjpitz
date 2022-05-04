{{/* Render the redis configuration file. */}}
{{- define "redis-raft.config" -}}
{{/* TODO : support TLS */}}
port 6379

tcp-backlog 511
tcp-keepalive 300
timeout 0
always-show-logo no

databases 1
save ""
dbfilename raft.rdb
maxmemory-policy noeviction
appendonly no
cluster-enabled no

dir /redis/data

protected-mode no
{{- end -}}

raft_args=""

function append_raft_arg() {
  if [[ -n "${2}" ]]; then
    raft_args="$raft_args ${1} ${2}"
  fi
}

append_raft_arg "id" "${REDIS_RAFT_MODULE_ID}"
append_raft_arg "addr" "${REDIS_RAFT_MODULE_ADDR}"
append_raft_arg "raft-log-filename" "${REDIS_RAFT_MODULE_RAFT_LOG_FILENAME}"
append_raft_arg "raft-interval" "${REDIS_RAFT_MODULE_RAFT_INTERVAL}"
append_raft_arg "request-timeout" "${REDIS_RAFT_MODULE_REQUEST_TIMEOUT}"
append_raft_arg "election-timeout" "${REDIS_RAFT_MODULE_ELECTION_TIMEOUT}"
append_raft_arg "connection-timeout" "${REDIS_RAFT_MODULE_CONNECTION_TIMEOUT}"
append_raft_arg "join-timeout" "${REDIS_RAFT_MODULE_JOIN_TIMEOUT}"
append_raft_arg "reconnect-internal" "${REDIS_RAFT_MODULE_RECONNECT_INTERVAL}"
append_raft_arg "proxy-response-timeout" "${REDIS_RAFT_MODULE_PROXY_RESPONSE_TIMEOUT}"
append_raft_arg "raft-response-timeout" "${REDIS_RAFT_MODULE_RAFT_RESPONSE_TIMEOUT}"
append_raft_arg "raft-log-max-file-size" "${REDIS_RAFT_MODULE_RAFT_LOG_MAX_FILE_SIZE}"
append_raft_arg "raft-log-max-cache-size" "${REDIS_RAFT_MODULE_RAFT_LOG_MAX_CACHE_SIZE}"
append_raft_arg "raft-log-fsync" "${REDIS_RAFT_MODULE_RAFT_LOG_FSYNC}"
append_raft_arg "quorum-reads" "${REDIS_RAFT_MODULE_QUORUM_READS}"
append_raft_arg "sharding" "${REDIS_RAFT_MODULE_SHARDING}"
append_raft_arg "slot-config" "${REDIS_RAFT_MODULE_SLOT_CONFIG}"
append_raft_arg "shardgroup-update-interval" "${REDIS_RAFT_MODULE_SHARDGROUP_UPDATE_INTERVAL}"
append_raft_arg "ignored-commands" "${REDIS_RAFT_MODULE_IGNORED_COMMANDS}"

/redis/bin/redis-server "$@" --loadmodule /redis/modules/redisraft.so follower-proxy yes $raft_args

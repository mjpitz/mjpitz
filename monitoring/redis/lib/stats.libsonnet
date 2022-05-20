local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  io_threads(selector):: prometheus.target(
    'sum(redis_config_io_threads{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  connections_received(selector):: prometheus.target(
    'sum(rate(redis_connections_received_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  eviction_rate(selector):: prometheus.target(
    'sum(rate(redis_evicted_keys_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  expirey_rate(selector):: prometheus.target(
    'sum(rate(redis_expired_keys_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  estimated_expired_percentage(selector):: prometheus.target(
    'sum(redis_expired_stale_percentage{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  defrag_active(selector):: prometheus.target(
    'sum(redis_active_defrag_running{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  defrag_hits(selector):: prometheus.target(
    'sum(redis_defrag_hits{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  defrag_key_hits(selector):: prometheus.target(
    'sum(redis_defrag_key_hits{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  defrag_key_misses(selector):: prometheus.target(
    'sum(redis_defrag_key_misses{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  defrag_misses(selector):: prometheus.target(
    'sum(redis_defrag_misses{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  expired_time_reached(selector):: prometheus.target(
    'sum(redis_expired_time_cap_reached_total{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  cpu_system_children(selector):: prometheus.target(
    'sum(rate(redis_cpu_sys_children_seconds_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  cpu_system_usage(selector):: prometheus.target(
    'sum(rate(redis_cpu_sys_seconds_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  cpu_user_usage(selector):: prometheus.target(
    'sum(rate(redis_cpu_user_seconds_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  keyspace_hit_rate(selector):: prometheus.target(
    'sum(rate(redis_keyspace_hits_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  keyspace_miss_rate(selector):: prometheus.target(
    'sum(rate(redis_keyspace_misses_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  latest_fork(selector):: prometheus.target(
    'sum(redis_latest_fork_seconds{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  net_input_bytes(selector):: prometheus.target(
    'sum(rate(redis_net_input_bytes_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  net_output_bytes(selector):: prometheus.target(
    'sum(rate(redis_net_output_bytes_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rejected_connection_rate(selector):: prometheus.target(
    'sum(rate(redis_rejected_connections_total{%s}[5m])) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  pubsub_channels(selector):: prometheus.target(
    'sum(redis_pubsub_channels{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  pubsub_patterns(selector):: prometheus.target(
    'sum(redis_pubsub_patterns{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  migrate_cached_sockets(selector):: prometheus.target(
    'sum(redis_migrate_cached_sockets_total{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}


local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  connected_replicas(selector):: prometheus.target(
    'sum(redis_connected_slaves{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replication_offset(selector):: prometheus.target(
    'max(redis_master_repl_offset{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  second_replication_offset(selector):: prometheus.target(
    'max(redis_second_repl_offset{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replication_backlog_active(selector):: prometheus.target(
    'sum(redis_repl_backlog_is_active{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replication_backlog(selector):: prometheus.target(
    'sum(redis_replication_backlog_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replication_backlog_offset(selector):: prometheus.target(
    'max(redis_repl_backlog_first_byte_offset{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replication_backlog_history(selector):: prometheus.target(
    'sum(redis_repl_backlog_history_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

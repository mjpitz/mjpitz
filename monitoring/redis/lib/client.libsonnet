local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  connected(selector):: prometheus.target(
    'sum(redis_connected_clients{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  cluster_enabled(selector):: prometheus.target(
    'sum(redis_cluster_enabled{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  max_input_buffer(selector):: prometheus.target(
    'max(redis_client_recent_max_input_buffer_bytes{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  max_output_buffer(selector):: prometheus.target(
    'max(redis_client_recent_max_output_buffer_bytes{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  blocked(selector):: prometheus.target(
    'sum(redis_blocked_clients{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  tracking(selector):: prometheus.target(
    'sum(redis_tracking_clients{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  max(selector):: prometheus.target(
    'sum(redis_config_maxclients{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  last_id(selector):: prometheus.target(
    'last(redis_slowlog_last_id{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  length(selector):: prometheus.target(
    'sum(redis_slowlog_length{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  last_duration(selector):: prometheus.target(
    'last(redis_last_slow_execution_duration_seconds{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

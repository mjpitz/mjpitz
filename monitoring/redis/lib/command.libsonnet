local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  duration(selector):: prometheus.target(
    'sum(rate(redis_commands_duration_seconds_total{%s}[5m])) by (cmd, namespace, pod) / sum(rate(redis_commands_total{%s}[5m])) by (cmd, namespace, pod) * 1000' % [
      selector,
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  failure_rate(selector):: prometheus.target(
    'sum(rate(redis_commands_failed_calls_total{%s}[5m])) by (cmd, namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rejection_rate(selector):: prometheus.target(
    'sum(rate(redis_commands_rejected_calls_total{%s}[5m])) by (cmd, namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  execution_rate(selector):: prometheus.target(
    'sum(rate(redis_commands_total{%s}[5m])) by (cmd, namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

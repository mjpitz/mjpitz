local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  count(selector):: prometheus.target(
    'count(redis_up{%s})' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  up(selector):: prometheus.target(
    'sum(redis_up{%s})' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  uptime(selector):: prometheus.target(
    'sum(redis_uptime_in_seconds{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

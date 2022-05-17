local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  average_ttl(selector):: prometheus.target(
    'sum(redis_db_avg_ttl_seconds{%s}) by (namespace, pod, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  keys(selector):: prometheus.target(
    'sum(redis_db_keys{%s}) by (namespace, pod, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  keys_expiring(selector):: prometheus.target(
    'sum(redis_db_keys_expiring{%s}) by (namespace, pod, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  partial_resync_accepted(selector):: prometheus.target(
    'sum(redis_replica_partial_resync_accepted{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  partial_resync_denied(selector):: prometheus.target(
    'sum(redis_replica_partial_resync_denied{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  full_resyncs(selector):: prometheus.target(
    'sum(redis_replica_resyncs_full{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  expired_keys(selector):: prometheus.target(
    'sum(redis_slave_expires_tracked_keys{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

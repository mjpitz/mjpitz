local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  checkpoint_rate(selector):: prometheus.target(
    'sum(rate(litestream_checkpoint_count{%s}[5m])) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  checkpoint_duration(selector):: prometheus.target(
    'sum(rate(litestream_checkpoint_seconds{%s}[5m])) by (pod, containers, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  db_size(selector):: prometheus.target(
    'sum(litestream_db_size{%s}) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replica_operation_size(selector):: prometheus.target(
    'sum(rate(litestream_replica_operation_bytes{%s}[5m])) by (pod, container, operation, replica_type)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replica_operation_rate(selector):: prometheus.target(
    'sum(rate(litestream_replica_operation_total{%s}[5m])) by (pod, container, operation, replica_type)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replica_validation_rate(selector):: prometheus.target(
    'sum(rate(litestream_replica_validation_total{%s}[5m])) by (pod, container, db, name, status)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replica_wal_size(selector):: prometheus.target(
    'sum(rate(litestream_replica_wal_bytes{%s}[5m])) by (pod, container, db, name)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replica_wal_index(selector):: prometheus.target(
    'sum(litestream_replica_wal_index{%s}) by (pod, container, db, name)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replica_wal_offset(selector):: prometheus.target(
    'sum(litestream_replica_wal_offset{%s}) by (pod, container, db, name)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  shadow_wal_index(selector):: prometheus.target(
    'sum(litestream_shadow_wal_index{%s}) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  shadow_wal_size(selector):: prometheus.target(
    'sum(litestream_shadow_wal_size{%s}) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  sync_rate(selector):: prometheus.target(
    'sum(rate(litestream_sync_count{%s}[5m])) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  sync_error_rate(selector):: prometheus.target(
    'sum(rate(litestream_sync_error_count{%s}[5m])) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  sync_duration(selector):: prometheus.target(
    'sum(rate(litestream_sync_seconds{%s}[5m])) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  total_wal_size(selector):: prometheus.target(
    'sum(rate(litestream_total_wal_bytes{%s}[5m])) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  wal_size(selector):: prometheus.target(
    'sum(litestream_wal_size{%s}) by (pod, container, db)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

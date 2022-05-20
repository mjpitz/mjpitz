local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  loading_dump_file(selector):: prometheus.target(
    'sum(redis_loading_dump_file{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rdb_save_in_progress(selector):: prometheus.target(
    'sum(redis_rdb_bgsave_in_progress{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rdb_changes_since_last_save(selector):: prometheus.target(
    'sum(redis_rdb_changes_since_last_save{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rdb_save_duration(selector):: prometheus.target(
    'sum(redis_rdb_current_bgsave_duration_sec{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rdb_last_save_duration(selector):: prometheus.target(
    'sum(redis_rdb_last_bgsave_duration_sec{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rdb_last_save_status(selector):: prometheus.target(
    'sum(redis_rdb_last_bgsave_status{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  aof_rewrite_duration(selector):: prometheus.target(
    'sum(redis_aof_current_rewrite_duration_sec{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  aof_last_rewrite_status(selector):: prometheus.target(
    'sum(redis_aof_last_bgrewrite_status{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  aof_last_cow_size(selector):: prometheus.target(
    'sum(redis_aof_last_cow_size_bytes{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  aof_last_rewrite_duration(selector):: prometheus.target(
    'sum(redis_aof_last_rewrite_duration_sec{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  aof_last_write_status(selector):: prometheus.target(
    'sum(redis_aof_last_write_status{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  aof_rewrite_in_progress(selector):: prometheus.target(
    'sum(redis_aof_rewrite_in_progress{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  aof_rewrite_scheduled(selector):: prometheus.target(
    'sum(redis_aof_rewrite_scheduled{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  module_fork_in_progress(selector):: prometheus.target(
    'sum(redis_module_fork_in_progress{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  module_fork_last_cow_size(selector):: prometheus.target(
    'sum(redis_module_fork_last_cow_size{%s}) by (pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

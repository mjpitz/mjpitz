local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  max_memory(selector):: prometheus.target(
    'sum(redis_config_maxmemory{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  used(selector):: prometheus.target(
    'sum(redis_memory_used_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  dataset(selector):: prometheus.target(
    'sum(redis_memory_used_dataset_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  lua(selector):: prometheus.target(
    'sum(redis_memory_used_lua_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  overhead(selector):: prometheus.target(
    'sum(redis_memory_used_overhead_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  peak(selector):: prometheus.target(
    'sum(redis_memory_used_peak_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  rss(selector):: prometheus.target(
    'sum(redis_memory_used_rss_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  scripts(selector):: prometheus.target(
    'sum(redis_memory_used_scripts_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  startup(selector):: prometheus.target(
    'sum(redis_memory_used_startup_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  clients(selector):: prometheus.target(
    'sum(redis_mem_clients_normal{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  replicas(selector):: prometheus.target(
    'sum(redis_mem_clients_slaves{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  fragmentation(selector):: prometheus.target(
    'sum(redis_mem_fragmentation_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  fragmentation_ratio(selector):: prometheus.target(
    'sum(redis_mem_fragmentation_ratio{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  eviction(selector):: prometheus.target(
    'sum(redis_mem_not_counted_for_eviction_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  allocator_active(selector):: prometheus.target(
    'sum(redis_allocator_active_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  allocator_allocated(selector):: prometheus.target(
    'sum(redis_allocator_allocated_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  allocator_fragmentation(selector):: prometheus.target(
    'sum(redis_allocator_frag_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  allocator_fragmentation_ratio(selector):: prometheus.target(
    'sum(redis_allocator_frag_ratio{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  allocator_resident(selector):: prometheus.target(
    'sum(redis_allocator_resident_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  allocator_rss(selector):: prometheus.target(
    'sum(redis_allocator_rss_bytes{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  allocator_rss_ratio(selector):: prometheus.target(
    'sum(redis_allocator_rss_ratio{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  lazyfree_pending(selector):: prometheus.target(
    'sum(redis_lazyfree_pending_objects{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

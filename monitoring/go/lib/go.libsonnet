local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  gc_duration(selector):: prometheus.target(
    'sum(go_gc_duration_seconds{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  /**
   */
  goroutines(selector):: prometheus.target(
    'sum(go_goroutines{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  info(selector):: prometheus.target(
    'count(go_info{%s}) by (version, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_alloc(selector):: prometheus.target(
    'sum(go_memstats_alloc_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_frees(selector):: prometheus.target(
    'sum(rate(go_memstats_frees_total{%s}[5m])) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_heap_alloc(selector):: prometheus.target(
    'sum(go_memstats_heap_alloc_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_heap_idle(selector):: prometheus.target(
    'sum(go_memstats_heap_idle_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_heap_inuse(selector):: prometheus.target(
    'sum(go_memstats_heap_inuse_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_heap_objects(selector):: prometheus.target(
    'sum(go_memstats_heap_objects{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_heap_released(selector):: prometheus.target(
    'sum(go_memstats_heap_released_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_heap_sys(selector):: prometheus.target(
    'sum(go_memstats_heap_sys_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_heap_last_gc_time(selector):: prometheus.target(
   'go_memstats_last_gc_time_seconds{%s}' % [
     selector,
   ],
  ),

  memstats_lookups(selector):: prometheus.target(
    'sum(rate(go_memstats_lookups_total{%s}[5m])) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_mallocs(selector):: prometheus.target(
    'sum(rate(go_memstats_mallocs_total{%s}[5m])) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_mcache_inuse(selector):: prometheus.target(
    'sum(go_memstats_mcache_inuse_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_mcache_sys(selector):: prometheus.target(
    'sum(go_memstats_mcache_sys_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_mspan_inuse(selector):: prometheus.target(
    'sum(go_memstats_mspan_inuse_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_mspan_sys(selector):: prometheus.target(
    'sum(go_memstats_mspan_sys_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_next_gc(selector):: prometheus.target(
    'sum(go_memstats_next_gc_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_other_sys(selector):: prometheus.target(
    'sum(go_memstats_other_sys_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_stack_inuse(selector):: prometheus.target(
    'sum(go_memstats_stack_inuse_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  memstats_stack_sys(selector):: prometheus.target(
    'sum(go_memstats_stack_sys_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  threads(selector):: prometheus.target(
    'sum(go_threads{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

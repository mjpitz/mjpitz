local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;

{
  gc_duration(
    selector,
  ):: graphPanel.new(
    'GC duration (seconds)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_gc_duration_seconds{%s}) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  /**
   */
  goroutines(
    selector,
  ):: graphPanel.new(
    'Goroutines',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_goroutines{%s}) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  info(
    selector,
  ):: singlestat.new(
    'Info',
    datasource='$datasource',
    span=4,
  ).addTarget(prometheus.target(
    'count(go_info{%s}) by (version, namespace, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_alloc(
    selector,
  ):: graphPanel.new(
    'Memory allocated (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_alloc_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_frees(
    selector,
  ):: graphPanel.new(
    'Memory frees',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(rate(go_memstats_frees_total{%s}[5m])) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_heap_alloc(
    selector,
  ):: graphPanel.new(
    'Heap allocated (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_heap_alloc_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_heap_idle(
    selector,
  ):: graphPanel.new(
    'Heap idle (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_heap_idle_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_heap_inuse(
    selector,
  ):: graphPanel.new(
    'Heap in-use (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_heap_inuse_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_heap_objects(
    selector,
  ):: graphPanel.new(
    'Rate of object allocation',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_heap_objects{%s}) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_heap_released(
    selector,
  ):: graphPanel.new(
    'Heap released to system (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_heap_released_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_heap_sys(
    selector,
  ):: graphPanel.new(
    'Heap obtained from system (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_heap_sys_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_heap_last_gc_time(
    selector,
  ):: singlestat.new(
    'Last gc date',
    datasource='$datasource',
    span=4,
    format='date',
  ).addTarget(prometheus.target(
   'go_memstats_last_gc_time_seconds{%s}*1000' % [
     selector,
   ],
  )),

  memstats_lookups(
    selector,
  ):: graphPanel.new(
    'Rate of pointer lookups',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(rate(go_memstats_lookups_total{%s}[5m])) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_mallocs(
    selector,
  ):: graphPanel.new(
    'Rate fo malloc operations',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(rate(go_memstats_mallocs_total{%s}[5m])) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_mcache_inuse(
    selector,
  ):: graphPanel.new(
    'Memory in-use by mcache structures (KiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_mcache_inuse_bytes{%s}/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_mcache_sys(
    selector,
  ):: graphPanel.new(
    'Memory allocated for mcache structures (KiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_mcache_sys_bytes{%s}/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_mspan_inuse(
    selector,
  ):: graphPanel.new(
    'Memory in-use by mspan structures (KiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_mspan_inuse_bytes{%s}/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_mspan_sys(
    selector,
  ):: graphPanel.new(
    'Memory allocated for mspan structures (KiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_mspan_sys_bytes{%s}/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_next_gc(
    selector,
  ):: graphPanel.new(
    'Memory reclaimed during next gc (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_next_gc_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_other_sys(
    selector,
  ):: graphPanel.new(
    'Memory allocated by other systems (KiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_other_sys_bytes{%s}/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_stack_inuse(
    selector,
  ):: graphPanel.new(
    'Memory in-use by the stack (KiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_stack_inuse_bytes{%s}/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  memstats_stack_sys(
    selector,
  ):: graphPanel.new(
    'Memory allocated for the stack allocator (KiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_memstats_stack_sys_bytes{%s}/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  threads(
    selector,
  ):: graphPanel.new(
    'OS threads',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(go_threads{%s}) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),
}

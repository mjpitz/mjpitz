local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;

{
  cpu(selector):: prometheus.target(
    'sum(rate(process_cpu_seconds_total{%s}[5m]) * 1000) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  max_fds(selector):: prometheus.target(
    'sum(process_max_fds{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  open_fds(selector):: prometheus.target(
    'sum(process_open_fds{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  resident_memory(selector):: prometheus.target(
    'sum(process_resident_memory_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  virtual_memory(selector):: prometheus.target(
    'sum(process_virtual_memory_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  virtual_memory_max(selector):: prometheus.target(
    'sum(process_virtual_memory_max_bytes{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

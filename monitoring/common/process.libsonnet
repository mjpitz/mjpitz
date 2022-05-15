local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;

{
  cpu(
    selector,
  ):: graphPanel.new(
    'CPU usage (millicores)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(rate(process_cpu_seconds_total{%s}[5m]) * 1000) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  max_fds(
    selector,
  ):: singlestat.new(
    'Max file descriptors',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(process_max_fds{%s}) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  open_fds(
    selector,
  ):: graphPanel.new(
    'Open file descriptors',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(process_open_fds{%s}) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  resident_memory(
    selector,
  ):: graphPanel.new(
    'Resident memory (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(process_resident_memory_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),

  start_time():: graphPanel.new(),

  virtual_memory(
    selector,
  ):: graphPanel.new(
    'Virtual memory (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(process_virtual_memory_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),


  virtual_memory_max(
    selector,
  ):: graphPanel.new(
    'Virtual memory max (MiB)',
    datasource='$datasource',
    span=4,
    format='short',
  ).addTarget(prometheus.target(
    'sum(process_virtual_memory_max_bytes{%s}/1024/1024) by (namespace, pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  )),
}

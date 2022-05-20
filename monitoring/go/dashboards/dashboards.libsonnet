local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;

local go = import '../lib/go.libsonnet';
local process = import '../lib/process.libsonnet';

{
  grafanaDashboards+:: {
    'grafana_dashboard_golang.yaml':
      local selector = 'namespace="$namespace",job="$job"' + (
        if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
      );

      dashboard.new(
        '%sgolang' % $._config.dashboard.prefix,
        time_from='now-1h',
        tags=($._config.dashboard.tags),
        refresh=($._config.dashboard.refresh),
      )
      .addTemplate({
        current: {
          text: 'default',
          value: 'default',
        },
        hide: 0,
        label: null,
        name: 'datasource',
        options: [],
        query: 'prometheus',
        refresh: 1,
        regex: '',
        type: 'datasource',
      })
      .addTemplate(template.new(
        'namespace',
        '$datasource',
        'label_values(namespace)',
      ))
      .addTemplate(template.new(
        'job',
        '$datasource',
        'label_values(job)',
      ))
      .addRow(
        row.new(
          title='Overview',
          showTitle=true,
          collapse=false,
        )
        .addPanel(
          singlestat.new(
            'Information',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(go.info(selector))
        )
        .addPanel(
          graphPanel.new(
            'Goroutines',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(go.goroutines(selector))
        )
        .addPanel(
          graphPanel.new(
            'Threads',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(go.threads(selector))
        )
      )
      .addRow(
        row.new(
          title='Process',
          showTitle=true,
          collapse=false,
        )
        .addPanel(
          graphPanel.new(
            'CPU usage',
            datasource='$datasource',
            span=4,
            format='millicores',
          ).addTarget(process.cpu(selector))
        )
        .addPanel(
          graphPanel.new(
            'Open file descriptors',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(process.open_fds(selector))
        )
        .addPanel(
          graphPanel.new(
            'Resident memory',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(process.resident_memory(selector))
        )
        .addPanel(
          graphPanel.new(
            'Virtual memory',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(process.virtual_memory(selector))
        )
        .addPanel(
          graphPanel.new(
            'Virtual memory max',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(process.virtual_memory_max(selector))
        )
      )
      .addRow(
        row.new(
          title='Memory',
          showTitle=true,
          collapse=true,
        )
        .addPanel(
          graphPanel.new(
            'Memory allocated',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_alloc(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory frees',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(go.memstats_frees(selector))
        )
        .addPanel(
          graphPanel.new(
            'Rate of pointer lookups',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(go.memstats_lookups(selector))
        )
        .addPanel(
          graphPanel.new(
            'Rate of malloc operations',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(go.memstats_mallocs(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory in-use by mcache structures',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_mcache_inuse(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory allocated for mcache structures',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_mcache_sys(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory in-use by mspan structures',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_mspan_inuse(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory allocated for mspan structures',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_mspan_sys(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory allocated by other systems',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_other_sys(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory in-use by stack',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_stack_inuse(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory allocated for the stack allocator',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_stack_sys(selector))
        )
      )
      .addRow(
        row.new(
          title='Heap',
          showTitle=true,
          collapse=true,
        )
        .addPanel(
          graphPanel.new(
            'Heap allocated',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_heap_alloc(selector))
        )
        .addPanel(
          graphPanel.new(
            'Heap idle',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_heap_idle(selector))
        )
        .addPanel(
          graphPanel.new(
            'Heap in-use',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_heap_inuse(selector))
        )
        .addPanel(
          graphPanel.new(
            'Rate of object allocations',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(go.memstats_heap_objects(selector))
        )
        .addPanel(
          graphPanel.new(
            'Heap released to system',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_heap_released(selector))
        )
        .addPanel(
          graphPanel.new(
            'Heap obtained from system',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_heap_sys(selector))
        )
      )
      .addRow(
        row.new(
          title='Garbage Collection',
          showTitle=true,
          collapse=true,
        )
        .addPanel(
          graphPanel.new(
            'GC duration',
            datasource='$datasource',
            span=4,
            format='seconds',
          ).addTarget(go.gc_duration(selector))
        )
        .addPanel(
          graphPanel.new(
            'Memory reclaimed during next gc',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(go.memstats_next_gc(selector))
        )
      ),
  },
}

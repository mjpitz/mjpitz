local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local row = grafana.row;

local go = import '../../common/go.libsonnet';

{
  grafanaDashboards+:: {
    'grafana_dashboard.yaml':
      local selector = '$selector' + (
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
      .addTemplate(template.text(
        'selector',
        label='selector',
      ))
      .addRow(
        row.new()
        .addPanel(go.info(selector=selector))
        .addPanel(go.goroutines(selector=selector))
        .addPanel(go.threads(selector=selector))
      )
      .addRow(
        row.new()
        .addPanel(go.memstats_alloc(selector=selector))
        .addPanel(go.memstats_frees(selector=selector))
        .addPanel(go.memstats_lookups(selector=selector))
        .addPanel(go.memstats_mallocs(selector=selector))
        .addPanel(go.memstats_mcache_inuse(selector=selector))
        .addPanel(go.memstats_mcache_sys(selector=selector))
        .addPanel(go.memstats_mspan_inuse(selector=selector))
        .addPanel(go.memstats_mspan_sys(selector=selector))
        .addPanel(go.memstats_other_sys(selector=selector))
        .addPanel(go.memstats_stack_inuse(selector=selector))
        .addPanel(go.memstats_stack_sys(selector=selector))
      )
      .addRow(
        row.new()
        .addPanel(go.memstats_heap_alloc(selector=selector))
        .addPanel(go.memstats_heap_idle(selector=selector))
        .addPanel(go.memstats_heap_inuse(selector=selector))
        .addPanel(go.memstats_heap_objects(selector=selector))
        .addPanel(go.memstats_heap_released(selector=selector))
        .addPanel(go.memstats_heap_sys(selector=selector))
      )
      .addRow(
        row.new()
        .addPanel(go.gc_duration(selector=selector))
        .addPanel(go.memstats_next_gc(selector=selector))
        //.addPanel(go.memstats_heap_last_gc_time(selector=selector))
      ),
  },
}

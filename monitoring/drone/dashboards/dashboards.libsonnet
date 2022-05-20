local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

local drone = import '../lib/drone.libsonnet';

{
  grafanaDashboards+:: {
    'grafana_dashboard_drone.yaml':
      local selector = 'namespace="$namespace",job="$job"' + (
        if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
      );

      dashboard.new(
        '%sdrone' % $._config.dashboard.prefix,
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
        row.new()
        .addPanel(
          graphPanel.new(
            'Build count',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(drone.build_count(selector))
        )
        .addPanel(
          graphPanel.new(
            'Pending builds',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(drone.pending_builds(selector))
        )
        .addPanel(
          graphPanel.new(
            'Pending jobs',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(drone.pending_jobs(selector))
        )
        .addPanel(
          graphPanel.new(
            'Repository count',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(drone.repo_count(selector))
        )
        .addPanel(
          graphPanel.new(
            'Running builds',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(drone.running_builds(selector))
        )
        .addPanel(
          graphPanel.new(
            'Running jobs',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(drone.running_jobs(selector))
        )
        .addPanel(
          graphPanel.new(
            'User count',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(drone.user_count(selector))
        )
      ),
  },
}

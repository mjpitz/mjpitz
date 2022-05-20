local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

local litestream = import '../lib/litestream.libsonnet';

{
  grafanaDashboards+:: {
    'grafana_dashboard_litestream.yaml':
      local selector = 'namespace="$namespace",job="$job"' + (
        if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
      );

      dashboard.new(
        '%slitestream' % $._config.dashboard.prefix,
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
            'Checkpoint rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.checkpoint_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Checkpoint duration',
            datasource='$datasource',
            span=4,
            format='seconds',
          ).addTarget(litestream.checkpoint_duration(selector))
        )
        .addPanel(
          graphPanel.new(
            'Database size',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(litestream.db_size(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replica operation size',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(litestream.replica_operation_size(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replica operation rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.replica_operation_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replica validation rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.replica_validation_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replica wal size',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(litestream.replica_wal_size(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replica wal index',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.replica_wal_index(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replica wal offset',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.replica_wal_offset(selector))
        )
        .addPanel(
          graphPanel.new(
            'Shadow wal index',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.shadow_wal_index(selector))
        )
        .addPanel(
          graphPanel.new(
            'Shadow wal size',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(litestream.shadow_wal_size(selector))
        )
        .addPanel(
          graphPanel.new(
            'Sync rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.sync_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Sync error rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(litestream.sync_error_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Sync duration',
            datasource='$datasource',
            span=4,
            format='seconds',
          ).addTarget(litestream.sync_duration(selector))
        )
        .addPanel(
          graphPanel.new(
            'Total wal size',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(litestream.total_wal_size(selector))
        )
        .addPanel(
          graphPanel.new(
            'WAL size',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(litestream.wal_size(selector))
        )
      ),
  },
}

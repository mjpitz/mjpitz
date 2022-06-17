local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

local server = import '../lib/server.libsonnet';

{
  dashboard(root)::
    local selector = 'namespace="$namespace",job="$job"' + (
      if root._config.dashboard.selector != '' then (',' + root._config.dashboard.selector) else ''
    );

    dashboard.new(
      '%sgrpc-server' % root._config.dashboard.prefix,
      time_from='now-1h',
      tags=(root._config.dashboard.tags),
      refresh=(root._config.dashboard.refresh),
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
          'Server Call Error Rate',
          datasource='$datasource',
          span=6,
          format='call/s',
        ).addTarget(server.errorRate(selector=selector))
      )
    )
    .addRow(
      row.new(
        title='Call Rates',
        showTitle=true,
        collapse=false,
      )
      .addPanel(
        graphPanel.new(
          'Server Call Start Rate',
          datasource='$datasource',
          span=6,
          format='call/s',
        ).addTarget(server.startRate(selector=selector))
      )
      .addPanel(
        graphPanel.new(
          'Server Call Completion Rate',
          datasource='$datasource',
          span=6,
          format='call/s',
        ).addTarget(server.completionRate(selector=selector))
      )
    )
    .addRow(
      row.new(
        title='Message Rates',
        showTitle=true,
        collapse=false,
      )
      .addPanel(
        graphPanel.new(
          'Server Message Send Rate',
          datasource='$datasource',
          span=6,
          format='msg/s',
        ).addTarget(server.messageSendRate(selector=selector))
      )
      .addPanel(
        graphPanel.new(
          'Server Message Receive Rate',
          datasource='$datasource',
          span=6,
          format='msg/s',
        ).addTarget(server.messageReceivedRate(selector=selector))
      )
    )
    .addRow(
      row.new(
        title='Request Durations',
        showTitle=true,
        collapse=false,
      )
      .addPanel(
        graphPanel.new(
          'Server Request Duration @ 90th',
          datasource='$datasource',
          span=4,
          format='s',
        ).addTarget(server.requestDuration(selector=selector,percentile=0.90))
      )
      .addPanel(
        graphPanel.new(
          'Server Request Duration @ 95th',
          datasource='$datasource',
          span=4,
          format='s',
        ).addTarget(server.requestDuration(selector=selector,percentile=0.95))
      )
      .addPanel(
        graphPanel.new(
          'Server Request Duration @ 99th',
          datasource='$datasource',
          span=4,
          format='s',
        ).addTarget(server.requestDuration(selector=selector,percentile=0.99))
      )
    )
}

local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

local client = import '../lib/client.libsonnet';

{
  dashboard(root)::
    local selector = 'namespace="$namespace",job="$job"' + (
      if root._config.dashboard.selector != '' then (',' + root._config.dashboard.selector) else ''
    );

    dashboard.new(
      '%sgrpc-client' % root._config.dashboard.prefix,
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
          'Client Call Error Rate',
          datasource='$datasource',
          span=6,
          format='call/s',
          min=0,
        ).addTarget(client.errorRate(selector=selector))
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
          'Client Call Start Rate',
          datasource='$datasource',
          span=6,
          format='call/s',
          min=0,
        ).addTarget(client.startRate(selector=selector))
      )
      .addPanel(
        graphPanel.new(
          'Client Call Completion Rate',
          datasource='$datasource',
          span=6,
          format='call/s',
          min=0,
        ).addTarget(client.completionRate(selector=selector))
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
          'Client Message Send Rate',
          datasource='$datasource',
          span=6,
          format='msg/s',
          min=0,
        ).addTarget(client.messageSendRate(selector=selector))
      )
      .addPanel(
        graphPanel.new(
          'Client Message Receive Rate',
          datasource='$datasource',
          span=6,
          format='msg/s',
          min=0,
        ).addTarget(client.messageReceivedRate(selector=selector))
      )
    )
}

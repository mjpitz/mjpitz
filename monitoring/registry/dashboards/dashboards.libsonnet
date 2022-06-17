local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

local registry = import '../lib/registry.libsonnet';

{
  grafanaDashboards+:: {
    registry:
      local selector = 'namespace="$namespace",job="$job"' + (
        if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
      );

      dashboard.new(
        '%scontainer registry' % $._config.dashboard.prefix,
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
          title = "Overview",
          showTitle=true,
          collapse=false,
        )
        .addPanel(
          graphPanel.new(
            'Requests in flight',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(registry.requests_in_flight(selector))
        )
      )
      .addRow(
        row.new(
          title = "Request Details",
          showTitle=true,
          collapse=false,
        )
        .addPanel(
          graphPanel.new(
            'Request Duration @ 90th',
            datasource='$datasource',
            span=4,
            format='seconds',
            min=0,
          ).addTarget(registry.request_duration(selector, percentile=0.90))
        )
        .addPanel(
          graphPanel.new(
            'Request Duration @ 95th',
            datasource='$datasource',
            span=4,
            format='seconds',
            min=0,
          ).addTarget(registry.request_duration(selector, percentile=0.95))
        )
        .addPanel(
          graphPanel.new(
            'Request Duration @ 99th',
            datasource='$datasource',
            span=4,
            format='seconds',
            min=0,
          ).addTarget(registry.request_duration(selector, percentile=0.99))
        )
        .addPanel(
          graphPanel.new(
            'Request Sizes @ 90th',
            datasource='$datasource',
            span=4,
            format='bytes',
            min=0,
          ).addTarget(registry.request_size(selector, percentile=0.90))
        )
        .addPanel(
          graphPanel.new(
            'Request Sizes @ 95th',
            datasource='$datasource',
            span=4,
            format='bytes',
            min=0,
          ).addTarget(registry.request_size(selector, percentile=0.95))
        )
        .addPanel(
          graphPanel.new(
            'Request Sizes @ 99th',
            datasource='$datasource',
            span=4,
            format='bytes',
            min=0,
          ).addTarget(registry.request_size(selector, percentile=0.99))
        )
      )
      .addRow(
        row.new(
          title = "Response Details",
          showTitle=true,
          collapse=false,
        )
        .addPanel(
          graphPanel.new(
            'Response Sizes @ 90th',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(registry.response_size(selector, percentile=0.90))
        )
        .addPanel(
          graphPanel.new(
            'Response Sizes @ 95th',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(registry.response_size(selector, percentile=0.95))
        )
        .addPanel(
          graphPanel.new(
            'Response Sizes @ 99th',
            datasource='$datasource',
            span=4,
            format='bytes',
          ).addTarget(registry.response_size(selector, percentile=0.99))
        )
        .addPanel(
          graphPanel.new(
            'Response Rates',
            datasource='$datasource',
            span=4,
            format='call/s',
          ).addTarget(registry.response_rate(selector))
        )
      )
      .addRow(
        row.new(
          title = "Storage Details",
          showTitle=true,
          collapse=false,
        )
        .addPanel(
          graphPanel.new(
            'Storage Action Duration @ 90th',
            datasource='$datasource',
            span=4,
            format='seconds',
            min=0,
          ).addTarget(registry.storage_action_duration(selector, percentile=0.90))
        )
        .addPanel(
          graphPanel.new(
            'Storage Action Duration @ 95th',
            datasource='$datasource',
            span=4,
            format='seconds',
            min=0,
          ).addTarget(registry.storage_action_duration(selector, percentile=0.95))
        )
        .addPanel(
          graphPanel.new(
            'Storage Action Duration @ 99th',
            datasource='$datasource',
            span=4,
            format='seconds',
            min=0,
          ).addTarget(registry.storage_action_duration(selector, percentile=0.99))
        )
        .addPanel(
          graphPanel.new(
            'Storage Cache Rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(registry.storage_cache_rate(selector))
        )
      )
  },
}

local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

local nginx = import '../lib/nginx.libsonnet';

{
  grafanaDashboards+:: {
    "ingress-nginx":
        local ingressSelector = 'ingress="$ingress"' + (
          if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
        );

        local hostSelector = 'host="$host"' + (
          if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
        );

        dashboard.new(
          '%singress-nginx' % $._config.dashboard.prefix,
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
          'host',
          '$datasource',
          'label_values(host)',
        ))
        .addTemplate(template.new(
          'ingress',
          '$datasource',
          'label_values(ingress)',
        ))
        .addRow(
          row.new(
            title='Overview',
            showTitle=true,
            collapse=false,
          )
          .addPanels([
            graphPanel.new(
              'TLS Seconds Remaining',
              datasource='$datasource',
              span=6,
              format='seconds',
              min=0,
            ).addTarget(nginx.tls_seconds_remaining(hostSelector)),
            graphPanel.new(
              'Upstream Latencies',
              datasource='$datasource',
              span=6,
              format='seconds',
              min=0,
            ).addTarget(nginx.upstream_latency(ingressSelector)),
            graphPanel.new(
              'Request Rate',
              datasource='$datasource',
              span=6,
              format='calls/s',
              min=0,
            ).addTarget(nginx.request_rate(hostSelector)),
            graphPanel.new(
              'Response Rate',
              datasource='$datasource',
              span=6,
              format='calls/s',
              min=0,
            ).addTarget(nginx.response_rate(hostSelector)),
          ])
        )
        .addRow(
          row.new(
            title='Request Details',
            showTitle=true,
            collapse=false,
          )
          .addPanels([
            graphPanel.new(
              'Duration @ 90th',
              datasource='$datasource',
              span=4,
              format='seconds',
              min=0,
            ).addTarget(nginx.request_duration(hostSelector, percentile=0.90)),
            graphPanel.new(
              'Duration @ 95th',
              datasource='$datasource',
              span=4,
              format='seconds',
              min=0,
            ).addTarget(nginx.request_duration(hostSelector, percentile=0.95)),
            graphPanel.new(
              'Duration @ 99th',
              datasource='$datasource',
              span=4,
              format='seconds',
              min=0,
            ).addTarget(nginx.request_duration(hostSelector, percentile=0.99)),
            graphPanel.new(
              'Size @ 90th',
              datasource='$datasource',
              span=4,
              format='bytes',
              min=0,
            ).addTarget(nginx.request_size(hostSelector, percentile=0.90)),
            graphPanel.new(
              'Size @ 95th',
              datasource='$datasource',
              span=4,
              format='bytes',
              min=0,
            ).addTarget(nginx.request_size(hostSelector, percentile=0.95)),
            graphPanel.new(
              'Size @ 99th',
              datasource='$datasource',
              span=4,
              format='bytes',
              min=0,
            ).addTarget(nginx.request_size(hostSelector, percentile=0.99)),
          ])
        )
        .addRow(
          row.new(
            title='Response Details',
            showTitle=true,
            collapse=false,
          )
          .addPanels([
            graphPanel.new(
              'Duration @ 90th',
              datasource='$datasource',
              span=4,
              format='seconds',
              min=0,
            ).addTarget(nginx.response_duration(hostSelector, percentile=0.90)),
            graphPanel.new(
              'Duration @ 95th',
              datasource='$datasource',
              span=4,
              format='seconds',
              min=0,
            ).addTarget(nginx.response_duration(hostSelector, percentile=0.95)),
            graphPanel.new(
              'Duration @ 99th',
              datasource='$datasource',
              span=4,
              format='seconds',
              min=0,
            ).addTarget(nginx.response_duration(hostSelector, percentile=0.99)),
            graphPanel.new(
              'Size @ 90th',
              datasource='$datasource',
              span=4,
              format='bytes',
              min=0,
            ).addTarget(nginx.response_size(hostSelector, percentile=0.90)),
            graphPanel.new(
              'Size @ 95th',
              datasource='$datasource',
              span=4,
              format='bytes',
              min=0,
            ).addTarget(nginx.response_size(hostSelector, percentile=0.95)),
            graphPanel.new(
              'Size @ 99th',
              datasource='$datasource',
              span=4,
              format='bytes',
              min=0,
            ).addTarget(nginx.response_size(hostSelector, percentile=0.99)),
          ])
        )
  },
}

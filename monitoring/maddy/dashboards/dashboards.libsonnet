local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

{
  grafanaDashboards+:: {
    maddy:
      local selector = 'namespace="$namespace",job="$job"' + (
        if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
      );

      dashboard.new(
        '%smaddy' % $._config.dashboard.prefix,
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
            'SMTP aborted transactions',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(prometheus.target(
            'sum(rate(maddy_smtp_aborted_transactions{%s}[5m])) by (pod, container)' % [selector],
            legendFormat='{{ instance }}',
          ))
        )
        .addPanel(
          graphPanel.new(
            'SMTP failed transactions',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(prometheus.target(
            'sum(rate(maddy_smtp_failed_commands{%s}[5m])) by (pod, container)' % [selector],
            legendFormat='{{ instance }}',
          ))
        )
        .addPanel(
          graphPanel.new(
            'SMTP started transactions',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(prometheus.target(
            'sum(rate(maddy_smtp_started_transactions{%s}[5m])) by (pod, container)' % [selector],
            legendFormat='{{ instance }}',
          ))
        )
        .addPanel(
          graphPanel.new(
            'Connection MX level',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(prometheus.target(
            'sum(rate(maddy_remote_conns_mx_level{%s}[5m])) by (pod, container)' % [selector],
            legendFormat='{{ instance }}',
          ))
        )
        .addPanel(
          graphPanel.new(
            'Connection TLS level',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(prometheus.target(
            'sum(rate(maddy_remote_conns_tls_level{%s}[5m])) by (pod, container)' % [selector],
            legendFormat='{{ instance }}',
          ))
        )
      ),
  },
}

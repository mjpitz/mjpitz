local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  errorRate(selector):: prometheus.target(
    (
      '( sum(rate(grpc_server_handled_total{grpc_code="Unavailable",%s}[5m])) by (grpc_service, grpc_method, instance) +' +
      '  sum(rate(grpc_server_handled_total{grpc_code="Unknown",%s}[5m])) by (grpc_service, grpc_method, instance) ) / ' +
      'sum(rate(grpc_server_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)'
    ) % [
      selector, selector, selector,
    ],
  ),

  startRate(selector):: prometheus.target(
    'sum(rate(grpc_server_started_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  completionRate(selector):: prometheus.target(
    'sum(rate(grpc_server_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  messageReceivedRate(selector):: prometheus.target(
    'sum(rate(grpc_server_msg_received_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  messageSendRate(selector):: prometheus.target(
    'sum(rate(grpc_server_msg_sent_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  requestDuration(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(grpc_server_handling_seconds_bucket{%s}[5m])) by (le,grpc_service,grpc_method))' % [
      percentile,
      selector,
    ],
    legendFormat='{{ grpc_service }} {{ grpc_method }}',
  ),
}

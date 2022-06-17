local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  error_rate(selector):: prometheus.target(
    (
      '( sum(rate(grpc_server_handled_total{grpc_code="Unavailable",%s}[5m])) by (grpc_service, grpc_method, instance) +' +
      '  sum(rate(grpc_server_handled_total{grpc_code="Unknown",%s}[5m])) by (grpc_service, grpc_method, instance) ) / ' +
      'sum(rate(grpc_server_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)'
    ) % [
      selector, selector, selector,
    ],
  ),

  start_rate(selector):: prometheus.target(
    'sum(rate(grpc_server_started_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  completion_rate(selector):: prometheus.target(
    'sum(rate(grpc_server_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  message_received_rate(selector):: prometheus.target(
    'sum(rate(grpc_server_msg_received_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  message_send_rate(selector):: prometheus.target(
    'sum(rate(grpc_server_msg_sent_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  request_duration(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(grpc_server_handling_seconds_bucket{%s}[5m])) by (le,grpc_service,grpc_method))' % [
      percentile,
      selector,
    ],
    legendFormat='{{ grpc_service }} {{ grpc_method }}',
  ),
}

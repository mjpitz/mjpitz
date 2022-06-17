local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  error_rate(selector):: prometheus.target(
    (
      '( sum(rate(grpc_client_handled_total{grpc_code="Unavailable",%s}[5m])) by (grpc_service, grpc_method, instance) +' +
      '  sum(rate(grpc_client_handled_total{grpc_code="Unknown",%s}[5m])) by (grpc_service, grpc_method, instance) ) / ' +
      'sum(rate(grpc_client_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)'
    ) % [
      selector, selector, selector,
    ],
  ),

  start_rate(selector):: prometheus.target(
    'sum(rate(grpc_client_started_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  completion_rate(selector):: prometheus.target(
    'sum(rate(grpc_client_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  message_received_rate(selector):: prometheus.target(
    'sum(rate(grpc_client_msg_received_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  message_send_rate(selector):: prometheus.target(
    'sum(rate(grpc_client_msg_sent_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),
}
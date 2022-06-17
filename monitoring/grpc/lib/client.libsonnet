local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  errorRate(selector):: prometheus.target(
    (
      '( sum(rate(grpc_client_handled_total{grpc_code="Unavailable",%s}[5m])) by (grpc_service, grpc_method, instance) +' +
      '  sum(rate(grpc_client_handled_total{grpc_code="Unknown",%s}[5m])) by (grpc_service, grpc_method, instance) ) / ' +
      'sum(rate(grpc_client_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)'
    ) % [
      selector, selector, selector,
    ],
  ),

  startRate(selector):: prometheus.target(
    'sum(rate(grpc_client_started_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  completionRate(selector):: prometheus.target(
    'sum(rate(grpc_client_handled_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  messageReceivedRate(selector):: prometheus.target(
    'sum(rate(grpc_client_msg_received_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),

  messageSendRate(selector):: prometheus.target(
    'sum(rate(grpc_client_msg_sent_total{%s}[5m])) by (grpc_service, grpc_method, instance)' % [
      selector,
    ],
  ),
}
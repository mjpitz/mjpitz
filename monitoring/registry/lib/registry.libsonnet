local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  requests_in_flight(selector):: prometheus.target(
    'sum(registry_http_in_flight_requests{%s}) by (handler)' % [
      selector,
    ],
  ),

  request_duration(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(registry_http_request_duration_seconds_bucket{%s}[5m])) by (le, handler, method))' % [
      percentile, selector,
    ],
  ),

  request_size(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(registry_http_request_size_bytes_bucket{%s}[5m])) by (le, handler))' % [
      percentile, selector,
    ],
  ),

  response_size(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(registry_http_response_size_bytes_bucket{%s}[5m])) by (le, handler))' % [
      percentile, selector,
    ],
  ),

  response_rate(selector):: prometheus.target(
    'sum(rate(registry_http_requests_total{%s}[5m])) by (handler, method, code)' % [
      selector,
    ],
  ),

  storage_action_duration(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(registry_storage_action_seconds_bucket{%s}[5m])) by (le, action, driver))' % [
      percentile, selector,
    ],
  ),

  storage_cache_rate(selector):: prometheus.target(
    'sum(rate(registry_storage_cache_total{%s}[5m])) by (type)' % [
      selector,
    ],
  ),
}

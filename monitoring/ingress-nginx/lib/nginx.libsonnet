local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  # -- The time spent waiting for a response from the upstream server
  upstream_latency(selector):: prometheus.target(
    'sum(nginx_ingress_controller_ingress_upstream_latency_seconds{%s}) by (quantile)' % [
      selector,
    ],
  ),

  # -- The time spent receiving the request body from the client
  request_duration(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(nginx_ingress_controller_request_duration_seconds_bucket{%s}[5m])) by (le,host,method,path,status))' % [
      percentile, selector,
    ],
  ),

  # -- The size of the request body
  request_size(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(nginx_ingress_controller_request_size_bucket{%s}[5m])) by (le,host,method,path,status))' % [
      percentile, selector,
    ],
  ),

  # -- The rate at which responses are returned
  request_rate(selector):: prometheus.target(
    'sum(rate(nginx_ingress_controller_request_size_count{%s}[5m])) by (host,method,path,status)' % [
      selector,
    ],
  ),

  # -- The time spent on receiving the response from the upstream server
  response_duration(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(nginx_ingress_controller_response_duration_seconds_bucket{%s}[5m])) by (le,host,method,path,status))' % [
      percentile, selector,
    ],
  ),

  # -- The size of the response body
  response_size(selector, percentile=0.95):: prometheus.target(
    'histogram_quantile(%f, sum(rate(nginx_ingress_controller_response_size_bucket{%s}[5m])) by (le,host,method,path,status))' % [
      percentile, selector,
    ],
  ),

  # -- The rate at which responses are returned
  response_rate(selector):: prometheus.target(
    'sum(rate(nginx_ingress_controller_response_size_count{%s}[5m])) by (host,method,path,status)' % [
      selector,
    ],
  ),

  # -- Seconds until the SSL Certificate expires.
  tls_seconds_remaining(selector):: prometheus.target(
    'sum(nginx_ingress_controller_ssl_expire_time_seconds{%s} - time()) by (host)' % [
      selector,
    ],
  ),
}

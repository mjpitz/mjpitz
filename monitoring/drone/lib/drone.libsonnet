local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  build_count(selector):: prometheus.target(
    'sum(drone_build_count{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  pending_builds(selector):: prometheus.target(
    'sum(drone_pending_builds{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  pending_jobs(selector):: prometheus.target(
    'sum(drone_pending_jobs{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  repo_count(selector):: prometheus.target(
    'sum(drone_repo_count{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  running_builds(selector):: prometheus.target(
    'sum(drone_running_builds{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  running_jobs(selector):: prometheus.target(
    'sum(drone_running_jobs{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  user_count(selector):: prometheus.target(
    'sum(drone_user_count{%s}) by (pod, container)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{
  accesses(selector):: prometheus.target(
    'sum(gitea_accesses{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  actions(selector):: prometheus.target(
    'sum(gitea_actions{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  attachments(selector):: prometheus.target(
    'sum(gitea_attachments{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  comments(selector):: prometheus.target(
    'sum(gitea_comments{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  follows(selector):: prometheus.target(
    'sum(gitea_follows{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  hooktasks(selector):: prometheus.target(
    'sum(gitea_hooktasks{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  issues(selector):: prometheus.target(
    'sum(gitea_issues{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  issues_closed(selector):: prometheus.target(
    'sum(gitea_issues_closed{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  issues_open(selector):: prometheus.target(
    'sum(gitea_issues_open{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  labels(selector):: prometheus.target(
    'sum(gitea_labels{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  loginsources(selector):: prometheus.target(
    'sum(gitea_loginsources{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  milestones(selector):: prometheus.target(
    'sum(gitea_milestones{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  mirrors(selector):: prometheus.target(
    'sum(gitea_mirrors{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  oauths(selector):: prometheus.target(
    'sum(gitea_oauths{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  organizations(selector):: prometheus.target(
    'sum(gitea_organizations{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  projects(selector):: prometheus.target(
    'sum(gitea_projects{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  projects_boards(selector):: prometheus.target(
    'sum(gitea_projects_boards{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  publickeys(selector):: prometheus.target(
    'sum(gitea_publickeys{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  releases(selector):: prometheus.target(
    'sum(gitea_releases{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  repositories(selector):: prometheus.target(
    'sum(gitea_repositories{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  stars(selector):: prometheus.target(
    'sum(gitea_stars{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  teams(selector):: prometheus.target(
    'sum(gitea_teams{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  updatetasks(selector):: prometheus.target(
    'sum(gitea_updatetasks{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  users(selector):: prometheus.target(
    'sum(gitea_users{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  watches(selector):: prometheus.target(
    'sum(gitea_watches{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),

  webhooks(selector):: prometheus.target(
    'sum(gitea_webhooks{%s}) by (namespace, pod)' % [
      selector,
    ],
    legendFormat='{{ instance }}',
  ),
}

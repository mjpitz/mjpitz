local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local template = grafana.template;

local gitea = import '../lib/gitea.libsonnet';

{
  grafanaDashboards+:: {
    'grafana_dashboard_gitea.yaml':
      local selector = 'namespace="$namespace",job="$job"' + (
        if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
      );

      dashboard.new(
        '%sgitea' % $._config.dashboard.prefix,
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
            'Accesses',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.accesses(selector))
        )
        .addPanel(
          graphPanel.new(
            'Actions',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.actions(selector))
        )
        .addPanel(
          graphPanel.new(
            'Attachments',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.attachments(selector))
        )
        .addPanel(
          graphPanel.new(
            'Comments',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.comments(selector))
        )
        .addPanel(
          graphPanel.new(
            'Follows',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.follows(selector))
        )
        .addPanel(
          graphPanel.new(
            'Hook tasks',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.hooktasks(selector))
        )
        .addPanel(
          graphPanel.new(
            'Issues',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.issues(selector))
        )
        .addPanel(
          graphPanel.new(
            'Issues closed',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.issues_closed(selector))
        )
        .addPanel(
          graphPanel.new(
            'Issues open',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.issues_open(selector))
        )
        .addPanel(
          graphPanel.new(
            'Labels',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.labels(selector))
        )
        .addPanel(
          graphPanel.new(
            'Login sources',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.loginsources(selector))
        )
        .addPanel(
          graphPanel.new(
            'Milestones',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.milestones(selector))
        )
        .addPanel(
          graphPanel.new(
            'Mirrors',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.mirrors(selector))
        )
        .addPanel(
          graphPanel.new(
            'OAuths',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.oauths(selector))
        )
        .addPanel(
          graphPanel.new(
            'Organizations',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.organizations(selector))
        )
        .addPanel(
          graphPanel.new(
            'Projects',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.projects(selector))
        )
        .addPanel(
          graphPanel.new(
            'Project boards',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.projects_boards(selector))
        )
        .addPanel(
          graphPanel.new(
            'Public keys',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.publickeys(selector))
        )
        .addPanel(
          graphPanel.new(
            'Releases',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.releases(selector))
        )
        .addPanel(
          graphPanel.new(
            'Repositories',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.repositories(selector))
        )
        .addPanel(
          graphPanel.new(
            'Stars',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.stars(selector))
        )
        .addPanel(
          graphPanel.new(
            'Teams',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.teams(selector))
        )
        .addPanel(
          graphPanel.new(
            'Update tasks',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.updatetasks(selector))
        )
        .addPanel(
          graphPanel.new(
            'Users',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.users(selector))
        )
        .addPanel(
          graphPanel.new(
            'Watches',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.watches(selector))
        )
        .addPanel(
          graphPanel.new(
            'Webhooks',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(gitea.webhooks(selector))
        )
      )
  },
}

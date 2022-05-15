local generateAlerts(pkg) = std.manifestYamlDoc(pkg.prometheusAlerts);

local generateDashboards(pkg) =
  local dashboards = pkg.grafanaDashboards;
  {
    [name]: dashboards[name]
    for name in std.objectFields(dashboards)
  };

local generateRules(pkg) = std.manifestYamlDoc(pkg.prometheusRules);


{
  /**
   */
  run(pkg)::
    local output = std.extVar('output');

    if output == 'alerts' then generateAlerts(pkg)
    else if output == 'dashboards' then generateDashboards(pkg)
    else if output == 'rules' then generateRules(pkg)
    else error 'unsupported output: %s' % output,
}

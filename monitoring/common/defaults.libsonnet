/**
 * Pulled from: https://github.com/kubernetes-monitoring/kubernetes-mixin
 *
 * Not sure how to properly attribute since they didn't fill in the license template.
 */
{
  local grafanaDashboards = super.grafanaDashboards,

  // Automatically add a uid to each dashboard based on a base64 encoded md5
  // of the filename and set the timezone to UTC.
  grafanaDashboards:: {
    [filename]: grafanaDashboards[filename] {
      uid: std.md5(filename),
      timezone: 'UTC',

      // Modify tooltip to only show a single value
      rows: [
        row {
          panels: [
            panel {
              tooltip+: {
                shared: false,
              },
            }
            for panel in super.panels
          ],
        }
        for row in super.rows
      ],

    }
    for filename in std.objectFields(grafanaDashboards)
  },
}

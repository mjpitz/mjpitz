local client = import './client.libsonnet';
local server = import './server.libsonnet';

{
  grafanaDashboards+:: {
    "grpc-client": client.dashboard($),
    "grpc-server": server.dashboard($),
  },
}

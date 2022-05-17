local client = import './client.libsonnet';
local command = import './command.libsonnet';
local db = import './db.libsonnet';
local instance = import './instance.libsonnet';
local memory = import './memory.libsonnet';
local persistence = import './persistence.libsonnet';
local stats = import './stats.libsonnet';
local primary = import './primary.libsonnet';
local replica = import './replica.libsonnet';
local slowlog = import './slowlog.libsonnet';

{
  client: client,
  command: command,
  db: db,
  instance: instance,
  memory: memory,
  persistence: persistence,
  stats: stats,
  primary: primary,
  replica: replica,
  slowlog: slowlog,
}

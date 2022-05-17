local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;
local template = grafana.template;

local redis = import '../lib/redis.libsonnet';

{
  grafanaDashboards+:: {
    'grafana_dashboard_redis.yaml':
      local selector = 'namespace="$namespace",job="$job"' + (
        if $._config.dashboard.selector != '' then (',' + $._config.dashboard.selector) else ''
      );

      dashboard.new(
        '%sredis' % $._config.dashboard.prefix,
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
        row.new(
          title = 'Overview',
          showTitle = true,
          collapse = false,
        )
        .addPanel(
          singlestat.new(
            'Instances',
            datasource='$datasource',
            span=3,
            format='short',
          ).addTarget(redis.instance.count(selector))
        )
        .addPanel(
          singlestat.new(
            'Available',
            datasource='$datasource',
            span=3,
            format='short',
          ).addTarget(redis.instance.up(selector))
        )
        .addPanel(
          singlestat.new(
            'Uptime',
            datasource='$datasource',
            span=6,
            format='short',
          ).addTarget(redis.instance.uptime(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Commands',
          showTitle = true,
          collapse = false,
        )
        .addPanel(
          graphPanel.new(
            'Duration (milliseconds)',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.command.duration(selector))
        )
        .addPanel(
          graphPanel.new(
            'Execution rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.command.execution_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Failure rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.command.failure_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Rejection rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.command.rejection_rate(selector))
        )
      )
      .addRow(
        row.new(
          title = 'DB',
          showTitle = true,
          collapse = false,
        )
        .addPanel(
          graphPanel.new(
            'Average time to live',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.db.average_ttl(selector))
        )
        .addPanel(
          graphPanel.new(
            'Key counts',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.db.keys(selector))
        )
        .addPanel(
          graphPanel.new(
            'Expiring key counts',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.db.keys_expiring(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Clients',
          showTitle = true,
          collapse = true,
        )
        .addPanel(
          graphPanel.new(
            'Connected',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.client.connected(selector))
        )
        .addPanel(
          graphPanel.new(
            'Blocked',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.client.blocked(selector))
        )
        .addPanel(
          graphPanel.new(
            'Tracking',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.client.tracking(selector))
        )
        .addPanel(
          graphPanel.new(
            'Max',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.client.max(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Memory',
          showTitle = true,
          collapse = true,
        )
        .addPanel(
          graphPanel.new(
            'Max configured',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.max_memory(selector))
        )
        .addPanel(
          graphPanel.new(
            'Used',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.used(selector))
        )
        .addPanel(
          graphPanel.new(
            'Dataset',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.dataset(selector))
        )
        .addPanel(
          graphPanel.new(
            'Lua',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.lua(selector))
        )
        .addPanel(
          graphPanel.new(
            'Overhead',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.overhead(selector))
        )
        .addPanel(
          graphPanel.new(
            'Peak',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.peak(selector))
        )
        .addPanel(
          graphPanel.new(
            'RSS',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.rss(selector))
        )
        .addPanel(
          graphPanel.new(
            'Scripts',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.scripts(selector))
        )
        .addPanel(
          graphPanel.new(
            'Start-up',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.startup(selector))
        )
        .addPanel(
          graphPanel.new(
            'Clients',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.clients(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replicas',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.replicas(selector))
        )
        .addPanel(
          graphPanel.new(
            'Fragmentation',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.fragmentation(selector))
        )
        .addPanel(
          singlestat.new(
            'Fragmentation ratio',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.fragmentation_ratio(selector))
        )
        .addPanel(
          graphPanel.new(
            'Eviction',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.eviction(selector))
        )
        .addPanel(
          graphPanel.new(
            'Allocator active',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.allocator_active(selector))
        )
        .addPanel(
          graphPanel.new(
            'Allocator allocated',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.allocator_allocated(selector))
        )
        .addPanel(
          graphPanel.new(
            'Allocator fragmentation',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.allocator_fragmentation(selector))
        )
        .addPanel(
          singlestat.new(
            'Allocator fragmentation ratio',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.allocator_fragmentation_ratio(selector))
        )
        .addPanel(
          graphPanel.new(
            'Allocator resident',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.allocator_resident(selector))
        )
        .addPanel(
          graphPanel.new(
            'Allocator rss',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.allocator_rss(selector))
        )
        .addPanel(
          singlestat.new(
            'Allocator rss ratio',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.allocator_rss_ratio(selector))
        )
        .addPanel(
          graphPanel.new(
            'Pending lazy/free',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.memory.lazyfree_pending(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Persistence',
          showTitle = true,
          collapse = true,
        )
        .addPanel(
          graphPanel.new(
            'Loading dump file',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.loading_dump_file(selector))
        )
        .addPanel(
          graphPanel.new(
            'RDB save in progress',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.rdb_save_in_progress(selector))
        )
        .addPanel(
          graphPanel.new(
            'RDB changes since last save',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.rdb_changes_since_last_save(selector))
        )
        .addPanel(
          graphPanel.new(
            'RDB save duration',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.rdb_save_duration(selector))
        )
        .addPanel(
          singlestat.new(
            'RDB last save duration',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.rdb_last_save_duration(selector))
        )
        .addPanel(
          singlestat.new(
            'RDB last save status',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.rdb_last_save_status(selector))
        )
        .addPanel(
          graphPanel.new(
            'AOF rewrite duration',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.aof_rewrite_duration(selector))
        )
        .addPanel(
          singlestat.new(
            'AOF last rewrite status',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.aof_last_rewrite_status(selector))
        )
        .addPanel(
          singlestat.new(
            'AOF last cow size',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.aof_last_cow_size(selector))
        )
        .addPanel(
          singlestat.new(
            'AOF last rewrite duration',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.aof_last_rewrite_duration(selector))
        )
        .addPanel(
          singlestat.new(
            'AOF last write status',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.aof_last_write_status(selector))
        )
        .addPanel(
          graphPanel.new(
            'AOF rewrite in-progress',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.aof_rewrite_in_progress(selector))
        )
        .addPanel(
          singlestat.new(
            'AOF rewrite scheduled',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.aof_rewrite_scheduled(selector))
        )
        .addPanel(
          graphPanel.new(
            'AOF module in progress',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.module_fork_in_progress(selector))
        )
        .addPanel(
          graphPanel.new(
            'AOF module last cow size',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.persistence.module_fork_last_cow_size(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Primary',
          showTitle = true,
          collapse = true,
        )
        .addPanel(
          graphPanel.new(
            'Connected replicas',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.primary.connected_replicas(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replication offset',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.primary.replication_offset(selector))
        )
        .addPanel(
          graphPanel.new(
            'Second replication offset',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.primary.second_replication_offset(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replication active',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.primary.replication_backlog_active(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replication backlog size',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.primary.replication_backlog(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replication backlog offset',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.primary.replication_backlog_offset(selector))
        )
        .addPanel(
          graphPanel.new(
            'Replication backlog history',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.primary.replication_backlog_history(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Replica',
          showTitle = true,
          collapse = true,
        )
        .addPanel(
          graphPanel.new(
            'Partial resyncs accepted',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.replica.partial_resync_accepted(selector))
        )
        .addPanel(
          graphPanel.new(
            'Partial resyncs denied',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.replica.partial_resync_denied(selector))
        )
        .addPanel(
          graphPanel.new(
            'Full resyncs',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.replica.full_resyncs(selector))
        )
        .addPanel(
          graphPanel.new(
            'Expired keys',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.replica.expired_keys(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Slowlog',
          showTitle = true,
          collapse = true,
        )
        .addPanel(
          graphPanel.new(
            'Length',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.slowlog.length(selector))
        )
        .addPanel(
          singlestat.new(
            'Last id',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.slowlog.last_id(selector))
        )
        .addPanel(
          singlestat.new(
            'Last duration',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.slowlog.last_duration(selector))
        )
      )
      .addRow(
        row.new(
          title = 'Stats',
          showTitle = true,
          collapse = true,
        )
        .addPanel(
          graphPanel.new(
            'IO threads',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.io_threads(selector))
        )
        .addPanel(
          graphPanel.new(
            'Connections received',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.connections_received(selector))
        )
        .addPanel(
          graphPanel.new(
            'Eviction rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.eviction_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Expirey rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.expirey_rate(selector))
        )
        .addPanel(
          singlestat.new(
            'Estimated expired percentage',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.estimated_expired_percentage(selector))
        )
        .addPanel(
          graphPanel.new(
            'Defragmentation active',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.defrag_active(selector))
        )
        .addPanel(
          graphPanel.new(
            'Defragmentation hits',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.defrag_hits(selector))
        )
        .addPanel(
          graphPanel.new(
            'Defragmentation key hits',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.defrag_key_hits(selector))
        )
        .addPanel(
          graphPanel.new(
            'Defragmentation key misses',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.defrag_key_misses(selector))
        )
        .addPanel(
          graphPanel.new(
            'Defragmentation misses',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.defrag_misses(selector))
        )
        .addPanel(
          graphPanel.new(
            'Expired time reached',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.expired_time_reached(selector))
        )
        .addPanel(
          graphPanel.new(
            'CPU children usage',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.cpu_system_children(selector))
        )
        .addPanel(
          graphPanel.new(
            'CPU system usage',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.cpu_system_usage(selector))
        )
        .addPanel(
          graphPanel.new(
            'CPU user usage',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.cpu_user_usage(selector))
        )
        .addPanel(
          graphPanel.new(
            'Keyspace hit rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.keyspace_hit_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Keyspace miss rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.keyspace_miss_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Network bytes in',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.net_input_bytes(selector))
        )
        .addPanel(
          graphPanel.new(
            'Network bytes out',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.net_output_bytes(selector))
        )
        .addPanel(
          graphPanel.new(
            'Connection rejection rate',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.rejected_connection_rate(selector))
        )
        .addPanel(
          graphPanel.new(
            'Pub/sub channels',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.pubsub_channels(selector))
        )
        .addPanel(
          graphPanel.new(
            'Pub/sub patterns',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.pubsub_patterns(selector))
        )
        .addPanel(
          graphPanel.new(
            'Migrate sockets',
            datasource='$datasource',
            span=4,
            format='short',
          ).addTarget(redis.stats.migrate_cached_sockets(selector))
        )
      )
  },
}

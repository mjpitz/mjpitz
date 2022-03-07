# Redis

This chart deploys Redis using a Kubernetes deployment. It's used primarily as a best-effort cache with no persistence.
If using a disk-backed Redis deployment, the `ephemeral-storage` resource request should be specified. See the
[documentation][kubernetes-ephemeral-storage-doc] for more details.

Furthermore, this cluster provides no consistency guarantees, nor does it attempt to reconcile any differences. Instead,
it's used as a building block for [envoy-based][] or [leaderless][] clusters.

[kubernetes-ephemeral-storage-doc]: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#setting-requests-and-limits-for-local-ephemeral-storage
[envoy-based]: https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/other_protocols/redis
[leaderless]: https://github.com/mjpitz/myago/tree/main/leaderless

## Usage

First, you'll need to add the dependency.

```yaml
# Chart.yaml
dependencies:
  - name: redis
    repository: TBD
    version: 6.2.6
    condition: redis.enabled
```

After adding the dependency, you'll need to instruct helm to sync it's dependencies.

```shell
helm dep up #path||.
```

Once your dependencies are synchronized, you should be able to add the sidecar and volume to your `Deployment`, 
`DaemonSet`, or `StatefulSet`.

```yaml
{{- $clusterConfig := dict "Chart" (dict "Name" "redis") "Values" .Values.redis "Release" .Release }}
apiVersion: apps/v1
# ...
spec:
  # ...
    # ...
      # ...
      containers:
        # ...
        {{- include "redis.cluster.sidecar" $clusterConfig | nindent 8 }}
      volumes:
        # ...
        {{- include "redis.cluster.volume" $clusterConfig | nindent 8 }}
# ...
```

Then, your client application can talk with redis as if it were running on localhost. For an example of how this chart
can be used, see the adjacent `registry` chart.

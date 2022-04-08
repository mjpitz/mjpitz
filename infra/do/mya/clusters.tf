locals {
  networks = {for network in digitalocean_vpc.networks : network.name => network.id}
}

data "digitalocean_kubernetes_versions" "cluster_versions" {
  count = length(var.clusters)

  version_prefix = "${var.clusters[count.index].kubernetes_version}."
}

resource "digitalocean_kubernetes_cluster" "clusters" {
  count = length(var.clusters)

  name     = var.clusters[count.index].name
  region   = var.clusters[count.index].region
  version  = data.digitalocean_kubernetes_versions.cluster_versions[count.index].latest_version
  vpc_uuid = local.networks[var.clusters[count.index].network]

  node_pool {
    name       = var.clusters[count.index].name
    size       = var.clusters[count.index].node_size
    auto_scale = false
    node_count = var.clusters[count.index].node_count

    tags   = var.clusters[count.index].node_tags
    labels = var.clusters[count.index].node_labels
  }

  tags = var.clusters[count.index].tags
}

locals {
  clusters = {for cluster in digitalocean_kubernetes_cluster.clusters : cluster.name => cluster.id}
}

resource "digitalocean_kubernetes_node_pool" "cluster_pools" {
  count = length(var.node_pools)

  cluster_id = local.clusters[var.node_pools[count.index].cluster]
  name       = var.node_pools[count.index].name
  size       = var.node_pools[count.index].node_size
  auto_scale = false
  node_count = var.node_pools[count.index].node_count
  tags       = var.node_pools[count.index].node_tags
  labels     = var.node_pools[count.index].node_labels
}

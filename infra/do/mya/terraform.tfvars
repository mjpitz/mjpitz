project = "mya"

networks = [
  {
    name : "mya-nyc",
    region : "nyc3",
    ip_range : "10.10.0.0/16",
  },
]

clusters = [
  {
    name : "mya-nyc",
    region : "nyc3",
    network : "mya-nyc",
    kubernetes_version : "1.30",
    node_size : "s-4vcpu-8gb",
    node_count : 3,
    node_tags: [],
    node_labels: {},
    tags: [],
  },
]

node_pools = []

spaces = [
  {
    name: "mya-assets",
    region : "nyc3",
    acl : "public-read",
  },
  {
    name: "mya-images",
    region: "nyc3",
    acl: "private",
  },
  {
    name: "mya-maddy",
    region: "nyc3",
    acl: "private",
  },
  {
    name: "mya-gitea",
    region: "nyc3",
    acl: "private",
  },
  {
    name: "mya-clickhouse",
    region: "nyc3",
    acl: "private",
  },
  {
    name: "mya-backups",
    region: "nyc3",
    acl: "private",
  }
]

cdn = [
  {
    space: "mya-assets",
  },
]

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
    kubernetes_version : "1.21",
    node_size : "s-4vcpu-8gb",
    node_count : 3,
    node_tags: [],
    node_labels: {},
    tags: [],
  },
]

spaces = [
  {
    name: "mya-artifacts",
    region : "nyc3",
    acl : "private",
  },
  {
    name: "mya-backups",
    region : "nyc3",
    acl : "private",
  },
  {
    name: "mya-containers",
    region: "nyc3",
    acl: "private",
  },
]

cdn = [
  {
    space: "mya-artifacts",
  },
]
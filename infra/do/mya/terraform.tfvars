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
    node_count : 2,
    node_tags: [],
    node_labels: {},
    tags: [],
  },
]

node_pools = [
  {
    cluster : "mya-nyc",
    name : "mya-nyc-email",
    node_size : "s-4vcpu-8gb",
    node_count : 1,
    node_tags: [],
    node_labels: {
      "node.pitz.tech/role" = "email",
    },
    tags: [],
  },
]

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
]

cdn = [
  {
    space: "mya-assets",
  },
]

variable "project" {
  type = string
}

variable "networks" {
  type = list(object({
    name : string,
    region : string,
    ip_range : string,
  }))
}

variable "clusters" {
  type = list(object({
    name : string,
    region : string,
    network : string,
    kubernetes_version : string,
    node_size : string,
    node_count : number,
    node_tags : list(string),
    node_labels : map(string),
    tags : list(string),
  }))
}

variable "node_pools" {
  type = list(object({
    cluster : string,
    name : string,
    node_size : string,
    node_count : number,
    node_tags : list(string),
    node_labels : map(string),
  }))
}

variable "spaces" {
  type = list(object({
    name : string,
    region : string,
    acl : string,
  }))
}

variable "cdn" {
  type = list(object({
    space : string,
  }))
}

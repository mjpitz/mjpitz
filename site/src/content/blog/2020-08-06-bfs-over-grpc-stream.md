---
title: "Implementing Breadth-first Search Over gRPC"
pubDate: "August 6 2020"
description: |
  deps.cloud is an open source project that I started.
  It's a tool that helps companies understand how their projects relate to one another.
  While graph databases do exist, finding administrative and engineering support is often hard.
  On the other hand, finding support for relational databases is easy.
  In this post, I share lessons learned while implementing a graph system on top of common relational databases.

slug: 2020/08/06/bfs-over-grpc-stream
tags:
  - software development
---

[deps.cloud] is an open source project that I started. It's a tool that helps companies understand how their projects
relate to one another. It does this by parsing files like `package.json` and storing the contents in a [graph].

While [graph databases] do exist, finding administrative and engineering support is often hard. To add complexity to
this, graph databases come in a variety of flavors. Since I wanted the workload to be portable, adopting a graph
database was a non-starter.

On the other hand, finding support for relational databases is easy. The problem is that implementing graphs on
relational databases tend to be slow. While there has been previous efforts, I felt [gRPC] was able to alleviate many of
the problems they faced. In this post, I share lessons I learned while implementing such a graph database.

<!--more-->

## The Database Schema

Before talking about the service layer, we first need to cover how we store data. A common approach is to separate the
data out into two separate tables. One table stores the `nodes`, or entities, of the graph. The other stores the
`edges`, or associations. The problem with this approach is that it often complicates the query logic. In order to get a
full picture, you need to join across 3 tables (`nodes`, `edges`, and `nodes` again).

Instead, I decided to store all data (`nodes` and `edges`) in a single table. This was inspired by [Dropbox's
EdgeStore]. The schema for [MySQL] is as follows:

```mysql
CREATE TABLE IF NOT EXISTS graphdata(
  graph_item_type VARCHAR(55),
  k1 VARCHAR(64),
  k2 VARCHAR(64),
  k3 VARCHAR(64),
  encoding TINYINT,
  graph_item_data TEXT,
  last_modified DATETIME,
  date_deleted DATETIME DEFAULT NULL,
  PRIMARY KEY (graph_item_type, k1, k2, k3),
  KEY secondary (graph_item_type, k2, k1, k3),
  KEY (date_deleted)
);
```

1. When `k1 == k2`, the row is a node.
1. When `k1 != k2`, the row is an edge.
1. The `k3` field allows nodes to have multiple edges between them.
1. Keys have a maximum length to keep the index small.
1. The `secondary` key improves performance of queries in the inverse direction.

## Service Definitions

Early on, I wanted a very straight forward interface. In some of my previous work, the data felt more like key/value
data. I often used bulk updates or bulk deletes to manage my information. Scanning the data was a semi-common task.
Finally, I needed to do prefix scans on both indexes. That is:

- `k1, k2` when querying for the egress (upstream) edges.
- `k2, k1` when querying for the ingress (downstream) edges.

As a result, I wound up with a pretty minimal key/value interface. While small, it provides the necessary building
blocks for other calls.

```proto
message PutRequest {}
message PutResponse {}
message DeleteRequest {}
message DeleteResponse {}
message ListRequest {}
message ListResponse {}
message FindRequest {}
message FindResponse {}

service GraphStore {
  rpc Put(PutRequest) returns (PutResponse);
  rpc Delete(DeleteRequest) returns (DeleteResponse);
  rpc List(ListRequest) returns (ListResponse);
  // neighbors
  rpc FindUpstream(FindRequest) returns (FindResponse);
  rpc FindDownstream(FindRequest) returns (FindResponse);
}
```

In addition to the key/value interface, I needed away to query the graph efficiently. I started by implementing
topological sorting as a client-only feature. The problem was this required constant communication between the client
and server. This pushed me more towards a stream-based API. gRPC provides three different types of streaming calls:

1. Client (eg. file upload)
1. Server (eg. file download)
1. Bidirectional (eg. chat app)

For this use case, either a server or bidirectional streaming API would work. The main goal is to reduce the amount of
back and forth between the clients. In many traversal algorithms you usually start with a set of nodes, and a strategy
to apply.

For example, consider [breadth-first search]. Engineers often use it to navigate [tree] and graph based data structures.
It works by taking a starting node, traversing its children, and repeating the process for each child. What we see here
is that we start with a single request that quickly turns into a lot of data. Hence, the server streaming capability.

In my implementation, I chose a bidirectional stream. The reason is these search algorithms often terminate early once
it finds the node. I wanted clients to be able to send along a stop request to prevent any further queries.

```proto
message SearchRequest {}
message SearchResponse {}

service SearchService {
  rpc BreadthFirstSearch(stream SearchRequest) returns (stream SearchResponse);
  rpc DepthFirstSearch(stream SearchRequest) returns (stream SearchResponse);
}
```

## Implementing Breadth-first Search

In my opinion, breadth-first search is the easier of the two functions. [Depth-first search] requires further
conversation around ordering and how that impacts the results.

In this section, I'm going to use an in-memory map to represent the graph. You can imagine this being swapped out with
the `GraphStore` interface. Before we introduce streaming concepts to the code, lets start with an iterative BFS.

```go
package main

func bfs() {
	graph := map[string][]string{
		"a": {"b", "c"},
		"b": {"c", "d"},
		"c": {"e"},
		// ....
	}

	current := []string{"a"}
	results := make([]string, 0)

	for length := len(current); length > 0; length = len(current) {
		next := make([]string, 0)

		for _, node := range current {
			next = append(next, graph[node]...)
		}

		results = append(results, current...)
		current = next
	}
}
```

An iterative solution is key here. It allows you to buffer and discard layers, thus keeping memory requirements low.
While there are a few inefficiencies in the code, it illustrates the overall structure. Next, we can introduce the
streaming concepts. In introducing these, we no longer need to track the `results` of a function. Instead, we can write
the current tier out to the client as we go.

```go
package main

type ServerStreamingCall interface {
	Send(response string) error
}

func bfs(call ServerStreamingCall) {
	graph := map[string][]string{
		"a": {"b", "c"},
		"b": {"c", "d"},
		"c": {"e"},
		// ....
	}

	current := []string{"a"}

	for length := len(current); length > 0; length = len(current) {
		next := make([]string, 0)

		for _, node := range current {
			next = append(next, graph[node]...)

            // flush result to client
            _ = call.Send(node)
		}

		current = next
	}
}
```

Unlike many previous implementations, this allows the server to progressively navigate the graph. It keeps server foot
prints low, and requires clients to size accordingly for their query. It improves the latency of calls by reducing round
trips between clients and servers. The was just first pass at implementing such a service. Throughout the process, I've
come up other ways to continue improve the performance. All in all, I'm excited to see how these types of operations
scale as the amount of data stored grows.

[deps.cloud]: https://deps.cloud
[graph]: https://en.wikipedia.org/wiki/Graph_(abstract_data_type)
[graph databases]: https://en.wikipedia.org/wiki/Graph_database
[gRPC]: https://grpc.io
[Dropbox's EdgeStore]: https://www.youtube.com/watch?v=VZ-zJEWi-Vo
[MySQL]: https://www.mysql.com/
[breadth-first search]: https://en.wikipedia.org/wiki/Breadth-first_search
[tree]: https://en.wikipedia.org/wiki/Tree_(data_structure)
[Depth-first search]: https://en.wikipedia.org/wiki/Depth-first_search

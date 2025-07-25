---
title: "gitfs - A FUSE File System"
pubDate: "January 30 2019"
description: |
  During my first employment at Indeed, I cloned every repository down to my machine.
  This approach worked for a while when the number of repositories was small.
  As the organization has grown, the solution quickly became unmanageable.

slug: 2019/01/30/gitfs-a-fuse-file-system
tags:
  - software development
---

During my first employment at Indeed, I cloned every repository down to my machine. This approach worked for a while
when the number of repositories was small. As the organization has grown, the solution quickly became unmanageable.
While many people do not work across every repository, many are familiar with the pain of setting up a new machine. I
wrote [gitfs](https://github.com/mjpitz/gitfs) for a few reasons. First, to reduce the time spent setting up a new
development environment. Second, to remove the need to figure out where all my projects need to be cloned. In this post,
I discuss some challenges faced and lessons learned in writing my first file system.

<!--more-->

## gitfs in Action

`gitfs` is a [FUSE](https://github.com/libfuse/libfuse) file system that helps reduce the management of git
repositories. It works by connecting to well defined api's (GitHub, Bitbucket, and Gitlab) and fetching repository urls
associated with the user. These urls are parsed into a virutal directory structure that can be navigated via the
terminal on linux or osx.

```
[mjpitz@mjpitz ~/Development/code 1/1]
$ ls
github.com

[mjpitz@mjpitz ~/Development/code 1/1]
$ cd github.com/

[mjpitz@mjpitz ~/Development/code/github.com 1/1]
$ ls
indeedeng  indeedeng-alpha  mjpitz

[mjpitz@mjpitz ~/Development/code/github.com 1/1]
$ cd mjpitz/

[mjpitz@mjpitz ~/Development/code/github.com/mjpitz 1/1]
$ ls
OpenGrok           gitfs            jgrapht     proto2-3
consul-api         grpc-java        laas        rpi
docker-clickhouse  grpc.github.io   mya.sh  seo-portal
docker-utils       grpcsh           mp          serverless-plugin-simulate
dotfiles           hbase-docker     okhttp      simple-daemon-node
envoy              idea-framework   proctor     spring-config-repo
generator-idea     java-gitlab-api  proctorjs

[mjpitz@mjpitz ~/Development/code/github.com/mjpitz 1/1]
$ cd mya.sh/

[mjpitz@mjpitz ~/Development/code/github.com/mjpitz/mya.sh master 1/1]
$ ls
Gemfile       _drafts    _posts              go              statics
Gemfile.lock  _includes  _site               index.html
_config.yml   _layouts   docker-compose.yml  pages
_data         _plugins   error.html          s3_website.yml

[mjpitz@mjpitz ~/Development/code/github.com/mjpitz/mya.sh master 1/1]
$
```

## Challenge 1 - Finding a complete example

The first big challenge that I encountered was finding a complete working example. I chose the
[bazil/fuse](https://github.com/bazil/fuse) library since it provided a clean low level implementation. Using a few
basic tutorials, I was able to implement a read-only version of the file system. Unfortunately, the tutorials often only
implemented a couple of interfaces from the library. And finding a complete example proved to be very difficult.
Eventually, I stumbled across
[cockroachdb/examples-go](https://github.com/cockroachdb/examples-go/blob/master/filesystem/node.go) which provides a
good example to work off of.

Using this reference, I implemented 2 structures. One that represented a file and one that represented a directory. As
the project progressed, having the logic in two separate files became difficult to manage. Eventually, these
implementations collapsed into a single INode structure. This made it easy to keep a lot of business logic in one place.
For portability, I added an interface for quick reference detailing which methods need to be implemented.

```golang
package filesystem

import "bazil.org/fuse/fs"

type INode interface {
	// common node functions
	fs.Node
	fs.NodeSetattrer

	// directory functions
	fs.NodeStringLookuper
	fs.HandleReadDirAller
	fs.NodeMkdirer
	fs.NodeCreater
	fs.NodeRemover
	fs.NodeRenamer
	fs.NodeSymlinker

	// handle functions
	fs.NodeOpener
	fs.HandleWriter
	fs.HandleReader
	fs.NodeFsyncer
	fs.HandleFlusher
	fs.HandleReleaser

	// symlink functions
	fs.NodeReadlinker
}
```

## Challenge 2 - Debugging

Debugging a file system can be intense. Since many operations happen in such a short period of time, a full set of logs
can quickly fill your disk. First, I started by only logging errors. That solution was insufficient. In many cases,
context from the request and wrapping structure would've helped debug issues. After iterating on the log a few times, I
wound up adding an info log at the start of the method. It included details about the request, details about the
structure, as well as what method was being invoked. From this, I was able to see the full sequence of operations on the
file system. But it was a lot.

In many cases, the error logs were enough to understand what went wrong. To reduce the volume in the typical case, I
implemented a `DEBUG` mode. By default, the info log is suppressed. When `DEBUG` is set to `true`, the info log and the
additional details are logged to stdout. Since debugging now requires restarting the file system, I needed to understand
reproduction steps before restarting. By understanding the reproduction steps well, I am able to reproduce the issue
quickly, keeping the debug log short and easy to read.

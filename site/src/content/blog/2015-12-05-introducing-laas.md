---
title: "Introducing LAAS"
pubDate: "December 5 2015"
description: |
  LAAS is an abbreviation for LevelDB as a service.
  LevelDB is an implementation of a log structured merge tree (LSMTree) provided by Google.
  This data structure aimed at providing a high write throughput.
  When attempting to use LevelDB, I found it difficult to track down supported libraries in different languages.

slug: 2015/12/05/introducing-laas
tags:
  - software development
---

[LAAS][] is an abbreviation for [LevelDB][] as a service. [LevelDB][] is an implementation of a [log structured merge
tree][] (LSMTree) provided by Google. This data structure aimed at providing a high write throughput. When attempting to
use [LevelDB][], I found it difficult to track down supported libraries in different languages. Additionally, the fact
that it's labeled as a database and doesn't provide a service was troublesome. I wrote [LAAS][] to make the adoption of
[LevelDB][] easy for any language. It does this by introducing a RESTful API to the underlying functionality. HTTP
request libraries are a dime a dozen, which drove the choice for a RESTful implementation.

<!--more-->

## Getting Started

The easiest way to get started with [LAAS][] is to install it globally with [NPM][].

{% highlight bash %} npm install -g laas {% endhighlight %}

After executing this command, you should have access to the `laas` command. This command provides a range of
functionality, the core of which is to manage the service layer. By executing `laas start`, you can start the service
running in the background on port 6931. You can verify that the service is running by executing the `laas status`
command.

For more information, check out:

- [API Documentation][]
- [CLI Documentation][]
- [Project README][]

## Features in 1.0.7

- Databases
  - create
  - list available
- Documents
  - insert (Single/Batch)
  - read (Single/Batch)
  - delete (Single/Batch)
- Statistics
  - per database

[LAAS]: https://github.com/jpitz/laas
[LevelDB]: http://leveldb.org/
[log structured merge tree]: https://en.wikipedia.org/wiki/Log-structured_merge-tree
[NPM]: https://docs.npmjs.com/getting-started/installing-node
[API Documentation]: https://github.com/jpitz/laas/blob/master/docs/api-docs.md
[CLI Documentation]: https://github.com/jpitz/laas/blob/master/docs/cli-docs.md
[Project README]: https://github.com/jpitz/laas/blob/master/README.md

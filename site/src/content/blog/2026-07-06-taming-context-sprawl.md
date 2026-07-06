---
title: "Taming Agent Context Sprawl"
pubDate: "July 6 2026"
description: |
  "Context sprawl" is what happens when agents lean on grep to navigate a codebase — the active
  window balloons, every request costs more, and compaction hits sooner. In this post I compare
  four open-source tools taking different swings at the problem — CodeGraph, GraphMind, basemind,
  and my own CodeSearch — covering how each indexes, what they expose over MCP, and where each
  one fits (or breaks) in real workflows.

slug: 2026/07/06/taming-context-sprawl
tags:
  - ai
  - agents
  - developer-tools
  - mcp
  - code-search
  - open-source
  - tooling
  - codegraph
  - codesearch
  - graphmind
  - basemind
---

Context sprawl is the term I've been using to describe what happens when agents leverage grep to navigate a code base.
This approach is naive and results in significant more information getting pulled into your active context window than
necessary. This results in you sending more tokens over the wire as well as increasing your spend with a given provider.
In this post, we dive into several tools aimed at taming context sprawl, how they are similar, and how they differ.

_Background_

I first started using AI in my development workflow late in 2024. It worked, but it wasn't effective and often resulted
in more work for me than it helped. My workflow drastically changed in early 2025 when a friend pointed me at Cline and
Claude (before Claude Code became a thing). While local model development still left a lot to be desired, integrating
work from Claude became significantly easier. The fact that Cline can be pointed at custom model providers was a big
draw for me. While Claude provides a fairly robust coding model today, I like to avoid vendor lock in with many of the
technologies I use.

As I increasingly adapted AI into my development, there were a few sharp edges that started to stand out to me. First,
large markdown files like `CLAUDE.md` and `AGENTS.md` quickly bloat your context window, making operations significantly
more expensive and forcing compaction early on. Breaking these down into small files that are easily navigable help, but
are unintuitive, especially to agents. Second, feeding common patterns into agents is reliable, but becomes tedious to
do and breaks down as your engineering team grows. Finally, I've seen agents ignore tools available to them and apply
skills in incorrect contexts.

Below, I capture a small number of tools aimed at taming context sprawl. Each solution takes their own unique approach
to reducing the number of tokens exposed to agents and selection will largely depend on your use case. Large monorepos
containing several languages may need to leverage a combination of tooling to improve.

_CodeGraph_

https://github.com/colbymchenry/codegraph ~ 44 Contributors ~ 57k Stars

I was pointed at this tool by a coworker at Gigawatt. It works really well when targeting a single repository and is
really easy to get started with. The system is written in TypeScript and backed by a SQLite database, making it easy for
users to become contributors with very little effort. Under the hood, the system behaves like GitHub search, but only
for source code. So finding usages, declarations, and symbol names is trivial, but don't expect your markdown files to
show up. SQLite supports `fts5` for search and optionally ranks using a `bm25` algorithm. Finally, this system exposes 4
tools to agents using an MCP server.

However, being built on the `npm` and more specifically `node-gyp` toolchain poses a supply chain risk. In addition to
build issues, the solution doesn't index markdown files by default which causes agents to miss important documentation.
Finally, search relies solely on file names and content and does not support vector search natively.

_GraphMind_

https://github.com/aouicher/graphmind ~ 2 Contributors ~ 185 Stars

A former coworker starred this tool on GitHub and it landed in my feed. This project stood out because instead of doing
per-repo indexing, they maintain a global index across all your repositories. They offer a desktop UI for developers to
explore their indexed information more practically. Similar to codegraph, this tool can interrogate your source code,
find usages, declarations, and symbols with significant ease. Unlike codegraph, this system is written in Rust, making
its build system far more predictable compared to `node-gyp`.

In contrast to the 4 tools exposed by codegraph, graphmind exposes 25+ tools via MCP. This list of tools contains a mix
of code indexing, querying, and decision recording. In practice, I've found coupling this many operations together into
a single MCP server to be counter intuitive (see [unix philosophy][]). Rather than recording decisions using an MCP
server, I've long preferred capturing decisions as documents in repo. Taking this approach can often save yourself a lot
of knowledge sharing later on. Furthermore, capturing these artifacts as in-repo documents is something that many agents
are already familiar with doing and allows your existing index and query logic to track it back down later on.

[unix philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy

_basemind_

https://github.com/Goldziher/basemind ~ 10 Contributors ~ 63 Stars

This solution came across my feed while browsing r/OpenSourceAI on Reddit toward the tail end of my vacation. At first
glance, this tool appears very similar to GraphMind with a few notable differences. Its most notable difference is its
rich support for non-code artifacts (PDF, Excel, etc). The second biggest difference is its persistence layer. Instead
of being built on SQLite, basemind is built on [LanceDB][], a columnar lakehouse format for multimodal AI. Like SQLite,
LanceDB embeds in your project and writes files to disk in a specific format.

Similar to GraphMind, basemind muddles code search, web search, document search, memory, and more into a single MCP
server. A swiss-army knife for AI if you will. I've generally found this approach to work well on solo projects, but
quickly break down in enterprise settings. My biggest concern about basemind is the likelihood of it becoming a
paid-only solution later on. While this is purely speculation, the tool brings in a significant amount of code from the
authors start up (xberg).

[LanceDB]: https://progrockrec.medium.com/what-the-heck-is-lancedb-12ae38ab248d

_CodeSearch_

https://github.com/mjpitz/codesearch ~ just me... ~ I don't really care how many stars...

I wrote CodeSearch before coming across both GraphMind and basemind. My motivations were centered around a specific use
case: better directing agents using in-repo documentation. I've seen how large context files break down as more
information is added. I've seen the discoverability problem in realtime and mitigated it using direct linking. But at
the end of the day, I wanted a solution that would act a lot like a search engine as I've seen how effective agents work
with tools like Google.

So, I built CodeSearch using common search engine optimization practices. To accomplish this, markdown files (and other
supporting file-types) can include front-matter with keys that boost a file's rank in search results. This is done using
[Bleve][] (blev-ee), an embeddable search index that is easily incorporated into any Golang binary. It supports many
query operations (term, phrase, match, prefix, fuzzy) and comes with several built-in tokenizers. Think of it like your
modern day [Lucene][] for Go. Similar to CodeGraph, this index is written to a `.codesearch` directory in the root of
your repository and offers 5 tools via MCP.

[Bleve]: https://blevesearch.com/
[Lucene]: https://lucene.apache.org/

_Conclusion_

This is a small selection of tooling that has come across my desk aimed at tackling context sprawl. I'm certain there
are more out there and I would love to see what folks are using. If you have thoughts or recommendations, drop me a line
on LinkedIn. In practice, I leverage CodeSearch for most of my navigation but defer to CodeGraph to navigate source code
and perform more extensive refactorings. I'm excited to see how graphmind and basemind may alter my workflow in the
coming months.

Until then,

~ Ciao

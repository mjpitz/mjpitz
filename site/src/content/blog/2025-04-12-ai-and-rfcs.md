---
title: "Teaching AI About RFCs"
pubDate: "April 14 2025"
description: |
   Exploring how MCP servers can enhance AI's understanding of technical protocols through RFC integration.

slug: 2025/04/14/ai-and-rfcs
---

In March 2025, I found myself immersed in the world of the [Model Context Protocol (MCP)][mcp-intro] as I started a new
journey at CakeAI. Like many engineers starting at a new company, I wanted to quickly build intuition around the tools
and technologies that would become part of my daily workflow.

[mcp-intro]: https://modelcontextprotocol.io/introduction

**What is MCP? Why does it matter?**

For those unfamiliar, the [Model Context Protocol (MCP)](https://www.anthropic.com/news/model-context-protocol) is a 
framework that enables AI models to access external data sources, tools, and specialized knowledge bases. It essentially 
allows models like Claude to break free from their static training data and tap into dynamic, up-to-date information.

This capability is transformative. Think of it as giving AI models the ability to "look things up" much like we might
use a search engine or reference documentation when faced with a specialized question. Instead of relying solely on
what was learned during training, an MCP-enabled model can retrieve specific information on demand, dramatically
improving its accuracy on technical topics.

_⚠️ Important_

There are some _VERY_ valid criticisms of the MCP protocol. I don't necessarily want to get into them in this post, but
they are certainly worth covering and being aware of.

**Finding a starting point**

In early 2024, I started the [Cognative](https://github.com/mjpitz/cognative) project in an effort to streamline the
management of business intelligence, operations, and securty related data. As we neared the end of the year, I started
to consider how AI could solve some real problems when it came to discovering, categorizing, and querying data at an
organization. I'd use AI every now and then to improve my queries, especially when working with a database I was less
familiar with, but at the time it couldn't help with the initial discovery. That responsibility remained with the
individual attempting to query the system.

Back in February, my friend Vaskin was showing me [Cline][cline] and MCP. It was during that session that I realized
that MCP could aid in the Cognative process. While I didn't have capacity to sit down on it at the time, I have found
myself with a bit more recently. As I went through the process of designing an MCP server for the cognative ecosystem,
I quickly found myself drowning in the volume of information, options, and capabilities available. I needed to start
somewhere simpler.

[cline]: https://cline.bot/

What would be a valuable, well-defined use case for demonstrating MCP's capabilities?

**The mcp-rfc server experiment**

During a casual team hangout on April 11th, I had a spark of inspiration. What if we built an MCP server specifically 
designed to help AI agents understand and work with RFCs (Request for Comments)? This seemed like the perfect starting point - 
well-defined documents with clear structures that AI tools could leverage.

For the uninitiated, RFCs are formal documents that describe the specifications for various internet technologies and 
protocols. They're essentially the blueprints that define how the internet and many of its applications work. Having an AI 
model that can reference these documents would be incredibly useful for developers and systems engineers.

The concept was simple but powerful:
1. Build an MCP server that could search for RFCs by topic or keyword
2. Allow it to fetch complete RFC documents and extract their content
3. Use this to provide AI models with accurate, up-to-date information about technical protocols

In a matter of just 5-10 minutes, I had prototype a functional MCP server that could search for and fetch RFCs.

**From idea to implementation**

To test the RFC MCP server, I started with a simple query: "Which RFCs deal with the HTTP/2 protocol?" 

The results were impressive. The server quickly returned a list of relevant RFCs, and the AI model (Claude) organized and 
summarized them intelligently - explaining that certain RFCs dealt with the core HTTP/2 protocol, others with HPACK 
compression, and even identifying related specifications like HTTP/3 over QUIC.

But I wanted to push it further. As someone who prefers to verify rather than blindly trust AI-generated code (what some 
might call "vibe coding"), I needed a more substantial test case.

**The gopher protocol challenge**

I decided to challenge the system with something I'd just learned about that same day: the 
[Gopher protocol](https://en.wikipedia.org/wiki/Gopher_(protocol)). As a relatively simple but complete internet protocol, 
it seemed like the perfect test case.

I prompted Cline (Claude) with a straightforward request: 

> Implement a JavaScript client library for the Gopher protocol based on the RFC.

Here's what happened next:

1. The MCP server searched for RFCs related to the Gopher protocol
2. It retrieved the relevant RFC, parsed its contents, and made them available to the model
3. Cline analyzed the protocol specifications and began developing an implementation

After a lot of processing (you can see Claude thinking through the problem in the video), it started generating a JavaScript 
implementation of the Gopher client. While the tool produced some redundant files that needed cleanup, the core implementation 
was solid and demonstrated a clear understanding of the protocol specifications - especially impressive considering Gopher is 
a somewhat obscure protocol these days.

You can watch the entire process in this video:

<div style="display: flex; justify-content: center;">
<iframe width="560" height="315" src="https://www.youtube.com/embed/ldosoWn5GM0" title="YouTube video player" 
frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe>
</div>
<br/>

**Lessons learned**

This experiment with the RFC MCP server yielded several valuable insights:

1. _MCP dramatically improves technical accuracy_: By giving AI models direct access to authoritative technical documents, 
   we can significantly reduce hallucinations and improve implementation quality. The Gopher client was functionally correct
   based on the RFC specifications.

2. _The barrier to entry is lower than expected_: Creating a basic but functional MCP server took minutes, not days or 
   weeks. This accessibility means more developers can leverage MCP for specialized use cases - you don't need to be an
   AI expert to create useful tools.

3. _Context matters_: The ability to pull in relevant technical specifications on demand transforms what AI can accomplish 
   with protocols and standards. The model doesn't need to have memorized every detail of every RFC during training.

4. _Verification remains crucial_: While the results were impressive, human review is still essential. The implementation 
   required some cleanup, highlighting that AI assistance augments rather than replaces engineering judgment.

**Future directions**

This initial experiment with the RFC MCP server opens up several exciting possibilities:

- _Expanding to other technical document collections_: Beyond RFCs, this approach could be extended to other technical 
  documentation like academic papers, standards documents, or language specifications.

- _Integration with development workflows_: Imagine IDE plugins that can automatically reference relevant RFCs when working 
  on networking code or protocol implementations, allowing developers to stay in their flow state while having context-aware
  assistance.

- _Multi-modal context enhancement_: Combining textual RFC information with diagrams, code samples, and interactive testing 
  tools could further enhance AI's understanding and implementation capabilities.

- _Improved RFC parsing_: While our initial implementation works well, there's room for better section extraction, reference
  resolution, and handling of formatting peculiarities in older RFCs.

The code for the RFC MCP server is available on [GitHub](https://github.com/mjpitz/mcp-rfc) if you'd like to try it
yourself or contribute to its development. The repository includes detailed instructions to get you started quickly.

**Conclusion**

The journey from concept to implementation of the RFC MCP server demonstrates the power of giving AI models access to 
specialized knowledge bases. By bridging the gap between AI and technical documentation, we can create more capable, 
reliable, and contextually aware AI assistants for developers.

As MCP continues to evolve, I'm excited to see how it will transform our interactions with AI and enable new applications we 
haven't yet imagined. My experiment with the RFC server is just one small example of what's possible when we extend AI's 
context beyond its training data.

---
title: "Review is the bottleneck"
pubDate: "November 24 2026"
description: |
  AI made code cheap to write, and pull requests went up. So did the time it takes to get one approved.
  At Gigawatt, we stopped trying to review faster and started changing what reaches a reviewer:
  a CI-enforced size limit and a local review loop over MCP.
slug: 2026/11/24/review-is-the-bottleneck
tags:
  - ai
  - software-engineering
  - code-review
---

For the last two years, we've mostly measured AI coding tools by how much they produce. By that measure, they work.
Teams open more pull requests than ever. But a pull request isn't the finish line. The stage between a PR and the
merge hasn't gotten any faster. Someone still has to read the change and decide whether it should
ship.

A working paper from Harvard puts numbers on that gap. Fiona Chen and James Stratton used Jellyfish data from 655 firms
and found that adopting AI agents raised pull requests opened by 35.7%. Over the same period, the time from requesting
review to getting approval rose by 56.1%, and comments per PR went up 38.6%. Only about 63% of the extra PRs merged,
compared to 86% before ([Chen & Stratton, Nov 2026][chen-stratton]).

We ran into this at Gigawatt before we had the numbers for it. This post covers what we changed.

<br/>

_Everyone else is seeing it too_

The Harvard paper isn't an outlier. It's the most rigorous version of a pattern that keeps showing up:

| Source                                      | What they found                                                                         |
| ------------------------------------------- | --------------------------------------------------------------------------------------- |
| [Chen & Stratton][chen-stratton] (655 firms) | PRs opened +35.7%, time to approval +56.1%, ~63% of extra PRs merged vs 86% baseline    |
| [Faros AI][faros] (10,000+ developers)       | PRs merged +98%, review time +91%, PR size +154%, no company-level DORA improvement     |
| [LinearB][linearb] (~8.1M PRs)               | AI-authored PRs merge at 32.7% vs ~84% for manual ones, and wait far longer for pickup |
| [DORA][dora-roi]                             | Names the cost directly: a "verification tax" that eats into AI gains                  |

The newer version of the Harvard paper projects that output could rise 57.8% by 2031 if review capacity stays flat,
and 341% if review keeps pace. That's closer to "AI helps as much as your review process lets it" than "AI doesn't
help."

<br/>

_Why review breaks_

Three things changed at once.

When writing code costs almost nothing, the diffs get bigger. Faros saw average PR size go up 154%. At Gigawatt, we
were regularly seeing PRs in the 10,000 to 15,000 line range, especially from engineers who were new to the company.

When you type every line, you carry the context in your head, but when an agent writes it, the author may understand
the change about as well as the reviewer does, or worse. [LinearB][linearb] found that
AI-authored PRs merge at 32.7% compared to about 84% for manual ones, and they wait far longer for anyone to pick
them up.

Reviewers are also slower because they don't trust what they're reading. In the [2025 Stack Overflow survey][stackoverflow],
46% of developers said they distrust the accuracy of AI tools, and 66% said their biggest frustration is answers that
are "almost right." Almost-right code is
exactly the kind that takes the longest to review. Faros found review time up 91% across their sample; the Harvard data puts it at 56.1%.

Our review process was built for code written at human speed, by an author who understood it. Neither can be guaranteed anymore.

<br/>

_What we changed at Gigawatt_

The tempting fix is to add reviewers, or to put an AI reviewer on the PR and call it done. We tried neither. Instead,
we changed what arrives at a human reviewer's desk. Two changes did most of the work.

**1. A line-count limit for human review.**

New engineers joining Gigawatt were letting agents run unsupervised and pushing without reading the result. PRs
regularly came in at 10,000 to 15,000 lines. Reviewers couldn't engage with them seriously, so changes either sat
for days or got rubber-stamped.

Changes over 4,000 lines fail on upstream CI with guidance on how to split the changeset. A tech lead can bypass the
limit by adding the `tech-lead-approved` label to a PR that genuinely can't be broken up without losing critical
context. The label is not a free pass. It adds a second responsible party should something go wrong. We used it once
on an internal MV90 library that came in just over 6,000 lines, where splitting the change would have made it
impossible to evaluate whether the library was working end-to-end.

A [Cisco study of 2,500 reviews][smartbear] found that reviewers should look at under 200 lines at a time and never more
than 400, because their ability to find defects falls off sharply past that. Google's
[engineering practices][google-small-cls] call 100 lines "usually a reasonable size" and 1,000 "usually too large," and
explicitly allow reviewers to reject a change for size alone. What's new is that agents make it easy to blow past
those limits without noticing.

The limit also pushes agents to work in smaller steps, which makes the next stage work better.

**2. A local review loop over MCP.**

The CI check pushed engineers to work in smaller chunks, but it also introduced churn. Engineers would push, fail CI,
split and fix, then push again. Each failed run was time and compute wasted on something that could have been caught
locally.

We built **localreview**, an internal tool in our developer toolchain. Engineers run it on their changes before they
push. It stores feedback in a local SQLite database and exposes an stdio MCP server, so the coding agent can read the
feedback and revise the change in the same session. The server works across multiple repositories and commits, with
commit messages reviewed alongside the code, closer to Gerrit's changeset model than a standard diff review.

Moving review to the laptop before the push reduced the total number of active pushes and cut CI/CD churn. By the
time a change reaches CI, the change has already been through a revision. Waiting for a teammate can take a day
([Software Engineering at Google][swe-book]); an engineer reviewing their own change before the push takes minutes.

The underlying principle shows up in other places, though the mechanism differs. The [Claude Code team][claude-verification]
runs verification and evidence checks before human review under the rule that "changes can't edit their own judges."
[AWS's gated review pipeline][aws-gated] puts deterministic checks and AI reviewers in front of a human and scales
human review by risk. Both front-load automation; localreview front-loads the engineer.

<br/>

_How the pieces fit_

A change now moves through three stages:

1. An agent writes the change.
2. The engineer reviews the change with localreview, the agent reads that feedback and revises, and nothing is pushed until it's been through a revision.
3. A PR under 4,000 lines goes to a teammate, or CI sends it back to be split.

Each stage catches a cheaper class of problem than the one after it. By the time a teammate opens the PR, their
attention goes to the things only a person can judge: design, risk, and whether this is the right change at all.

<br/>

_What we measure now_

We stopped counting lines and PRs. Those numbers went up on their own, and they told us nothing useful. Instead, we watch:

- Time to approval
- PR size distribution
- PR merge rate
- Change failure rate

<br/>

_Where it still hurts_

This isn't free.

- Large refactors and migrations are easier to split than they look. We've coordinated most of them with stacked PRs,
  and localreview works well here because the engineer can review the full stack locally before anything gets pushed.
- A line limit is a blunt instrument. A 50-line change to auth code deserves more scrutiny than a 400-line test file.

If you're spending money on AI coding tools, spend some of it on the review side first. Make what reaches your
reviewers smaller and pre-checked. The next model will write code faster either way. Your process decides whether any
of it ships.

What's your merge rate on AI-coauthored PRs compared to human ones? If you don't know, that's the first number to
track.

<br/>

~ Ciao

[chen-stratton]: https://fion.ac/jellyfish.pdf
[faros]: https://www.faros.ai/blog/ai-productivity-paradox-report-2025
[linearb]: https://linearb.io/dev-interrupted/podcast/linearb-2026-benchmarks-ai-pr-merge-rate
[dora-roi]: https://www.infoq.com/news/2026/05/dora-roi-ai-assisted-dev-report/
[stackoverflow]: https://survey.stackoverflow.co/2025/ai
[smartbear]: https://static0.smartbear.co/support/media/resources/cc/book/code-review-cisco-case-study.pdf
[google-small-cls]: https://google.github.io/eng-practices/review/developer/small-cls.html
[swe-book]: https://abseil.io/resources/swe-book/html/ch09.html
[claude-verification]: https://claude.dev/blog/how-the-claude-code-team-thinks-about-verification/
[aws-gated]: https://aws.amazon.com/blogs/devops/building-a-gated-review-pipeline-for-ai-coding-agents-on-aws/

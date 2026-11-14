---
title: "Human out of the loop"
pubDate: "November 14 2026"
description: |
  AWS shipped 200+ services that no engineer wrote or reviewed and called it a feature.
  I've been building local agent tooling long enough to have opinions about why that's
  a problem, and what a better model looks like.
slug: 2026/11/14/human-out-of-the-loop
tags:
  - ai
  - software-engineering
  - aws
---

On November 11th, Amazon launched [AWS Emulator][], a local stand-in for 200+ AWS services. Framed as a flex, [Amazon's
announcement][] notes, _"our team hasn't written or reviewed any of the code."_ Looking at [the repo][], I can
understand why. Nearly 30,000 commits, 400+ API models, three agent teams (test, find, fix), CC0-licensed. No pull
requests accepted. Issues filed by agents. It's a real thing they shipped.

My reaction wasn't awe. _Of course that's what they did._ I wanted to know where the gaps were.

**My stake in this**

I've worked on projects built on AWS for years. Lambda, SQS, DynamoDB, S3, the whole stack. I know firsthand how much
time gets eaten by round-trips to a real environment during development. Local emulation means shorter feedback loops,
lower cloud costs during iteration, and the ability to test failure modes without touching production. The case for it
is real. I've wanted something like this to work for a long time.

I've also spent time this year building local tooling for coding agents, trying to tighten the iteration cycle without
removing myself from the loop. The goal isn't to automate anyone away. It's to go faster.

So while I want a solution like this to work, I'm skeptical about how it was built.

**How it was built**

Three specialized agent teams (one that tests, one that finds failures, one that fixes them) work against API models
derived from hundreds of AWS API definitions. Humans don't write or merge any of the code. What they own is the spec.
That means defining what "correct" behavior looks like for each service, and what the merge gate checks for.

The reporting on scale varies ([InfoWorld counts 426 services][infoworld-emulator], [AWS says 200+][AWS Emulator]), but
the model is clear. The engineer's job became authoring the definition of "done." Everything after that is agents.

**Where the gate leaks**

The merge gate is real. It merges nothing that doesn't pass. But specs don't cover what nobody thought to write down.

Early testers ran hands-on evaluations (The Chaos Guru, The Register) and found what you'd expect from automated-spec
coverage:

- Resources that report success while silently doing nothing (no-ops, no error raised)
- No IAM evaluation: permissions aren't checked, so local tests pass auth checks that would fail in real AWS
- No throttling: rate limit behavior you'd hit in production doesn't exist locally

This isn't a criticism of the agent teams. It's a property of spec-driven generation without human review. A human
reviewer would ask, "wait, what does this service actually do when permissions are denied?" A spec that was never
written can't answer that question.

There's a second problem. I've been burned by AWS documentation before. I've built against documented behavior only to
find that real AWS does something different, or that the docs were out of date, or that edge cases weren't covered. If
the agent teams are generating code from API models derived from that documentation, they inherit whatever gaps and
errors it has. The gate validates against the spec. The spec isn't the same thing as the truth.

This tracks with what the research shows. The [Stack Overflow 2026 developer survey][] found that 48% of developers only
trust AI output when it's easy to verify. [METR][] found that experienced developers were 19% _slower_ when working with
AI on complex tasks. Not because AI produces worse code, but because verifying it takes longer than writing it. Remove
the verifier and you don't remove the problem. You defer it to whoever hits the bug in production.

**The open-source question**

I tried LocalStack in 2018 during some Lambda development and [wrote about it at the time][lambda-local]. I got it
running, hit a bug deploying Lambda functions, filed a report, and moved on. LocalStack has matured a lot since then and
has become the default recommendation in most AWS-heavy shops. The community invested real time in it.

That context matters for the "no PRs" decision on AWS Emulator. Part of it is probably about maintaining consistency in
an agent-maintained codebase, since human PRs introduce drift. But it also sidesteps a growing problem in open-source.
AI-generated pull requests are flooding maintainer queues.

Maintainers on [LocalStack][] and [moto][] are fielding more AI-generated PRs than humans can triage. Some are good.
Most are superficially plausible and subtly wrong. The AWS Emulator model routes around this by making agents the only
author. No PR queue.

LocalStack and moto have human review and significantly deeper coverage in the services they implement. AWS Emulator has
an agent pipeline and will scale to new services faster. We'll see which advantage compounds. But "shipped by AWS"
doesn't automatically mean more accurate than what the community has built. Their docs' track record alone gives me
pause.

**What to borrow**

The parts of the model worth borrowing don't require removing humans from the loop:

- **Merge gates with published fidelity scores.** Make the gap between your emulator and real AWS visible. File it as
  issues, not surprises.
- **Agents for first-pass generation.** Humans own the spec and the final call. Agents do the volume work in between.
- **A real-cloud reference suite.** Run tests against actual AWS regularly. Keep the gap honest.

I wouldn't hand the merge decision to a gate with no human reviewer for anything that touches security, auth, or failure
modes. The IAM gap is a [known][chaos-guru] [leak][the-register]. An unknown leak is what a human reviewer catches that
the spec didn't anticipate.

The AWS Emulator is a useful reference model, but it's not a template I'd follow without a human in the loop.

~ Ciao

[AWS Emulator]: https://aws.amazon.com/blogs/aws/test-your-applications-against-aws-locally-with-aws-emulator/
[infoworld-emulator]:
  https://www.infoworld.com/article/4247383/aws-unveils-local-emulator-service-to-help-enterprises-accelerate-app-development-and-testing.html
[Amazon's announcement]: https://www.aboutamazon.com/news/aws/how-autonomous-ai-agents-built-aws-emulator
[the repo]: https://github.com/aws/aws-emulator
[LocalStack]: https://github.com/localstack/localstack
[moto]: https://github.com/getmoto/moto
[lambda-local]: /2018/10/27/lambda-local-development
[Stack Overflow 2026 developer survey]: https://survey.stackoverflow.co/2026/ai/data/ai-trust
[METR]: https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/
[chaos-guru]: https://chaosguru.substack.com/p/aws-finally-made-an-official-local?r=3f5ebc
[the-register]:
  https://www.theregister.com/off-prem/2026/11/12/aws-distills-its-cloud-into-a-local-emulator-that-runs-on-your-pc/5309251

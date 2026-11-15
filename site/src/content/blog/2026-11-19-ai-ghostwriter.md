---
title: "Treating AI like a ghostwriter"
pubDate: "November 19 2026"
description: |
  Executives who criticize AI content may already be publishing AI-assisted text,
  because their ghostwriter used it. The question isn't who typed the words but
  whether a named person owns, reviews, and stands behind them.
slug: 2026/11/19/ai-ghostwriter
tags:
  - ai
  - writing
---

The critique of AI-written content often comes from people who don't write their own content.

According to [a 2025 survey by Gotham Ghostwriters and Josh Bernoff][gotham], 68% of ghostwriters use AI at least some
of the time, and 63% use it to generate drafts they then edit. That means executives who outsource their LinkedIn posts
to a ghostwriting firm may already be publishing AI-assisted text without knowing it. The ghostwriter used it to draft,
then cleaned it up and charged $7,000 to $10,000 a month for the service ([Fortune, January 2026][fortune]).

The irony isn't that those executives are hypocrites, though some probably are. The actual complaint about AI content,
when you press on it, isn't that AI was involved. It's that nobody read it before it went out. Ghostwriting has always
had to clear that bar.

_The standard that already exists_

Ghostwriting has an ethics literature, and it reaches a fairly clear conclusion. In a reader survey conducted by
researchers at the University of Oregon, most readers expected executives and politicians to get writing help. The
researchers (Gallicano and Cho) concluded that having a professional write posts is ethical when the ideas come from the
stated author and the author edits each post ([Institute for Public Relations][gallicano-readers]).

A companion practitioner survey ([Gallicano, Brett and Hopp][gallicano-practitioners]) found broad support among PR
professionals for undisclosed ghost blogging under the same conditions. It also noted that the speechwriting comparison
breaks down if the author doesn't approve each post. Not because delegation is wrong, but because the author's judgment
is what makes it their work.

There's a meaningful exception. The reader survey found that too few nonprofit blog readers expected ghost blogging, so
the researchers judged undisclosed ghost blogging unethical for nonprofit executives. Reader expectations determine
whether the practice is deceptive. The standard isn't universal, it's calibrated to what an audience has reason to
expect.

The same calibration applies to AI. Some audiences will find any AI involvement disqualifying. Others, increasingly,
won't. The question is whether the stated author supplied the ideas and reviewed every word, not whether a human or a
model typed the first draft.

_The disclosure problem_

Here's where the argument gets harder. [Raj, Berg and Seamans][raj] ran 16 preregistered experiments with 27,491
participants and found that readers consistently rated writing lower when told AI wrote it or helped write it. The
average hit was 6.2%. Disclosing human-AI collaboration was penalized about as much as disclosing pure AI authorship. So
the review process I'm describing doesn't currently earn you much credit with readers.

Something worth noting is that study covers creative writing, not professional content. The results may not transfer
cleanly to a technical blog or a LinkedIn post, but the direction is clear.

The parallel from ghostwriting research is instructive. A [University of Florida study][kelleher] found that employees
saw CEO ghost posting as acceptable when disclosed, and rated it as less authentic even then. Delegated writing has
always taken an authenticity hit once people find out. Ghostwriting has just had decades to become expected, which is
why the hit is usually manageable.

None of this settles the ethics question. The existence of a penalty doesn't tell you whether the practice is wrong. It
tells you something about where norms are. Those norms can shift.

_Ownership through review_

The code review parallel is useful here. A reviewed pull request isn't considered inauthentic because a junior engineer
or a tool drafted it. What makes it the reviewer's responsibility is that they read it, understood it, and put their
name on the merge. I apply the same logic to any AI-drafted writing.

_Where the argument doesn't hold_

Three things make AI different enough from a ghostwriter to matter.

Scale is the first. A ghostwriter costs enough to stay rare, which creates pressure toward care. AI makes low-effort
content nearly free. One blog analysis estimated that more than half of long-form LinkedIn posts are likely AI-generated
([Live in the Future][linkedin]), with lower engagement than human-written posts. That analysis isn't peer-reviewed, but
the direction matches what most people observe.

The source of ideas is different too. A good ghostwriter interviews you, pushes back, and draws out thinking you already
had. AI can generate ideas you never had, which is a different kind of delegation. When an executive publishes a take
their ghostwriter invented, that's already a problem. AI makes it cheaper to do at scale.

There's also the effort signal. Writing used to demonstrate that someone cared enough to do it. After AI cover letter
tools arrived, one study found the correlation between cover letter quality and callbacks fell by 51% as employers
adjusted to the diminished signal ([Cui, Dias and Ye, 2025][cover-letter-signal]). The credential isn't the words; it's
the work behind them.

_What it actually requires_

Treating AI like a ghostwriter means you supply the ideas before the draft begins, you read every sentence when it comes
back, and you're willing to cut anything that doesn't reflect your thinking. If you're publishing without reading, it
isn't ghostwriting. It's outsourcing without review, and the ghostwriting research is pretty clear that the review is
the whole point.

The standard isn't about disclosure. It's about accountability. That standard already applies to ghostwriting and it
should apply to AI.

~ Ciao

[gotham]: https://gothamghostwriters.com/wp-content/uploads/2025/11/AI-Writer-Survey.pdf
[fortune]: https://www.fortune.com/2026/01/31/elizabeth-holmes-theranos-prison-social-media/
[gallicano-readers]: https://instituteforpr.org/blog-readers-think-survey-assess-ghost-blogging-commenting
[gallicano-practitioners]:
  https://instituteforpr.org/ghost-blogging-like-speechwriting-survey-practitioners-ethics-ghost-blogging
[raj]:
  https://michiganross.umich.edu/news/readers-less-favorable-toward-ai-generated-creative-writing-berg-research-finds
[kelleher]: https://www.jou.ufl.edu/insights/employee-perceptions-of-ceo-ghost-posting/
[linkedin]: https://liveinthefuture.org/stories/linkedin-thought-leadership-ai-authenticity-crisis
[cover-letter-signal]: https://arxiv.org/abs/2509.25054

---
slug: slos-for-oss
date: 2020-09-30
title: "SLOs for Open Source"
tags:
  - fmea
  - slo
  - sli
  - sla
  - reliability
  - open-source
  - oss
  - sre
  - runbooks

---

Open source software has been used to build organizations for years.
From libraries to complex infrastructure systems, the open source landscape provides a vast sea of solutions.
For larger infrastructure projects, organizations are asking maintainers for [service level objectives] (SLOs).
Many do not publish or provide any, even when projects come from organizations who likely had SLOs in place.
In this post, I walk through my process for developing indicators and objectives for open source projects.

[service level objectives]: https://en.wikipedia.org/wiki/Service-level_objective

<!--more-->

Site reliability engineering started at [Indeed] right around when Google released the book.
One of the first things they asked for was that every design review considered SLOs.
This has always felt out of place to me.
Projects would write in idealized values and end up adjusting them to match how the system performed post implementation.
What I found was this process took away from the useful work, proper failure analysis.

[Indeed]: https://indeed.com

### Failure mode and effect analysis

[FMEA] is the process of reviewing subsystems to identify potential failure modes, their causes, and effects.
Because it focuses on failure analysis, it fits nicely in the design review stage.
While engineers may not be able to accurately assess an SLO metric, they can reason about how systems might fail.
The process also helps prioritize runbook development.
It communicates the probability, severity, and risk of a given scenario.
Finally, the process is iterative allowing you to add more to it later on.

When performing an FMEA, you often complete a worksheet.
While the one provided on Wikipedia has more information, I decided to break this information down into two components: 

* a simplified FMEA worksheet (example shown below)
* a set of production outage scenarios derived from the worksheet

```markdown
| Item          | Failure Mode         | Possible Cause       | Effects                 | Probability (P)        | Severity (S)    | Detection (D) | Risk      |
|:--------------|:---------------------|:---------------------|:------------------------|:-----------------------|:----------------|:--------------|:----------|
| MySQL Primary | Outage / Unreachable | Host maintenance     | Data cannot be stored   | occasional (C)         | critical (IV)   | certain       | moderate  |
| MySQL Replica | Outage / Unreachable | Host maintenance     | Data cannot be read     | remote (B)             | critical (IV)   | certain       | moderate  |
| Service-X     | Not Running / Ready  | Crash loop           | ....                    | extremely unlikely (A) | critical (IV)   | certain       | low       |
| Service-X     | Not Running / Ready  | Cluster full         | ....                    | remote (B)             | critical (IV)   | high          | moderate  |
| Service-X     | Partial Outage       | MySQL primary outage | ....                    | occasional (B)         | critical (IV)   | high          | moderate  |
| Service-X     | Partial Outage       | MySQL replica outage | ....                    | remote (B)             | critical (IV)   | high          | moderate  |
```

The process and [ground rules] for completing this worksheet is quite simple.
For your system and each system your project depends on, start to brainstorm how components might fail.
Add each failure as a row in the table.
I've found this table to be easiest to complete in three passes.
First, focus on the items, their failure modes, causes, and effects.
Second, go through and assign priority, severity, and detection.
In your final pass, assign risk based on the [factors].

[FMEA]: https://en.wikipedia.org/wiki/Failure_mode_and_effects_analysis
[ground rules]: https://en.wikipedia.org/wiki/Failure_mode_and_effects_analysis#Ground_rules
[factors]: https://en.wikipedia.org/wiki/Failure_mode_and_effects_analysis#Risk_level_(P%C3%97S)_and_(D)

#### Production outage scenarios

Once the worksheet is complete, each line can be turned into a production outage scenario.
You can prioritize completion based on their relative risk factors.
Production outage scenarios are a lot like runbooks, but consolidated and focused on a single failure.
Each scenario contains the following information:

* **Symptoms** the system is likely exhibiting.
* **Context** to help assess the impact to end users.
* Steps to help **troubleshoot** and gather additional information about the state of the system.
* **Remediation steps** used to help resolve the underlying issues.
* **Next steps** should this scenario be insufficient (including additional scenarios to consider).

For ease of use, I wrote up a quick [template here](https://gist.github.com/mjpitz/985f8562addb8d137cd5b99872e3f5f8).
I prefer to write up a single document for each scenario instead of collecting every scenario into a single document.
I've found it helps improve the signal-to-noise ratio.

#### Monitoring and alerting

Some failures can be mitigated with proper monitoring and alerting.
Using your worksheet, you can brainstorm how to mitigate failures.
Some useful questions to probe for what kind of monitoring should be added include:

* What are some early warning signs of the given failure?
* What monitoring can we put in place to better detect a problem?

### Runbooks

When writing up runbooks for open source projects, I looked to some larger solutions.
[GitLab](https://gitlab.com/) has an excellent set of [runbooks](https://gitlab.com/gitlab-com/runbooks) published to the public.
While [kubernetes](https://kubernetes.io) does provide [one](https://github.com/kubernetes-monitoring/kubernetes-mixin/blob/master/runbook.md),
I've found it lacks a lot of useful information when I'm actually paged.

I really like [Caitie McCaffrey]'s [runbook template] from her [Tackling Alert Fatigue] talk.
It highlights everything I expect to see in a runbook.
There's a section for you to provide an overview of the functionality the system provides.
There's space for alerts and how to remediate them.
Some components do not map cleanly for open source projects, such as deployment configuration and contact info.
With a few modifications, I was able to assemble an [augmented template] for open source projects.

While I removed the deployment configuration and contact information, I still plan on providing a separate template for those.
There are many benefits to decoupling that information.
For commonly supported deployments, we can provide a set of well-known guides that work.
For less common deployments, individuals can write up a quick guide specific to their usage.
Some guides can even be contributed back.

[Caitie McCaffrey]: https://twitter.com/caitie
[runbook template]: https://github.com/CaitieM20/Talks/blob/master/TacklingAlertFatigue/runbook.md
[Tackling Alert Fatigue]: https://vimeo.com/173704290
[augmented template]: https://gist.github.com/mjpitz/fd7cb715d4d6f77dff97b89baebc60a6

### Indicators and objectives

One of the benefits to publishing your FMEA is that it allows others to quickly understand failures within your system.
This information is useful for writing runbooks, onboarding organizations, and determining service level indicators and objectives.

I strongly believe that you can't reliably set SLOs until your system until it is in production.
Even once you're there, some platforms can provide stronger reliability guarantees than others.
It's well-known a service's SLO cannot be greater than the product of its dependencies SLOs.
Dependencies come in all shapes and sizes.
As managed services provided by cloud providers, platforms running your systems, or even libraries in your application. 
The FMEA process forces you to think critically about your system, its dependencies, and the failure modes they can experience.
This better informs our understanding of a system, and helps guide our decisions around SLOs.

**What SLOs should I set?**

There's already a lot of information out there on what SLOs to set, monitoring, and alerting.
Availability and response latency are two of the most common objectives.
This [post from NewRelic](https://blog.newrelic.com/engineering/best-practices-for-setting-slos-and-slis-for-modern-complex-systems/) is a great guide on how to pick and set SLOs.
Generally speaking, features and capabilities should drive SLIs and SLIs should drive SLOs.

---
title: "Why the wait?"
pubDate: "November 20 2026"
description: |
  Rust just joined npm, pnpm, Yarn, Bun, uv, pip and Dependabot in supporting dependency cooldowns.
  Most malicious packages are pulled within hours, so waiting a few days is one of the cheapest
  supply-chain defenses there is. Here's how I set it up, and where it falls short.
slug: 2026/11/20/dependency-cooldowns
tags:
  - security
  - supply-chain
  - software-engineering
---

Last week, Rust became the latest major ecosystem to add a setting that says "don't install anything younger than N
days."

[Rust 1.100][rust-1100] (Nov 12) stabilized `global-min-publish-age` in Cargo. It joins npm, pnpm, Yarn, Bun, uv, pip
and Dependabot. Dependabot has used a [3-day cooldown by default][dependabot-cooldown] since July.

So, almost without anyone deciding it, "wait a few days" has become one of the main defenses against supply-chain worms.
It's now built into most of the tools we use every day. But in nearly all of them it's opt-in, and the default is zero.

I turned it on a long time ago. This post covers why, how I set it up, and where the approach falls short.

<br/>

_Why a few days is enough_

Most malicious packages are caught within hours. Look at how long recent registry attacks stayed live before someone
noticed and pulled them:

| Incident                                          | Date         | How long the malicious versions were live                                                                 | Source                                                                                                |
| ------------------------------------------------- | ------------ | --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| axios (npm): `1.14.1` and `0.30.4`                | Mar 31, 2026 | About 3 hours (00:21–03:15 UTC)                                                                           | [axios maintainers' postmortem](https://github.com/axios/axios/issues/10636)                          |
| arrayref, internment, append-only-vec (crates.io) | Aug 20, 2026 | 1h27m to 1h48m per crate                                                                                  | [Rust Security Response Team](https://blog.rust-lang.org/2026/08/20/supply-chain-attack-on-arrayref/) |
| ChainDrop worm (npm), starting from keyv          | Aug 4, 2026  | npm began removals about 1 hour after the first carrier; infected releases were gone within about 7 hours | [Keyv/Cacheable maintainer postmortem](https://jaredwray.com/blog/keyv-and-cacheable-chaindrop-worm)  |
| Nx "s1ngularity" (npm)                            | Aug 26, 2025 | About 4 hours (6:32–10:44 PM EDT)                                                                         | [Nx security advisory](https://github.com/nrwl/nx/security/advisories/GHSA-cxm3-wv7p-598c)            |

The axios case is the one I keep coming back to. It's one of the most-downloaded packages on npm, and the bad versions
were live for about three hours in the early hours of a Tuesday, UTC. Anyone with a 3-day cooldown never saw them.

William Woodruff [looked at ten well-known attacks][woodruff]. In eight of them, the exposure window was under a week.
The two exceptions, xz-utils and Kong, were slow, patient operations that a cooldown was never going to catch.

Attackers count on automation. A worm spreads because thousands of CI pipelines and bots grab the newest version the
minute it appears. If you wait a few days, you're out of that first wave, and the first wave is usually the whole
attack.

The cost is low. Almost no team needs a patch release within hours of publication. When you do, it's usually a security
fix, and that should go through a separate path anyway (more on that below).

<br/>

_How we do it_

I use two layers in Renovate, and you need both.

Renovate runs weekly, not daily. Dependency updates show up once a week as a batch. The team reviews them together
instead of handling a steady trickle of PRs, and nobody merges a version just because it happened to land in the middle
of their afternoon.

Every update must be at least 3 days old before Renovate will propose it. This is Renovate's `minimumReleaseAge`
setting, which used to be called `stabilityDays`.

Why both? A weekly schedule on its own isn't a cooldown. If a malicious version is published an hour before your Monday
run, a weekly bot picks it up just as eagerly as a daily one. The cooldown closes that gap.

Together, the two layers mean every version we pick up is at least 3 days old. Most are older, because of where the
release falls in the weekly cycle. Anything published in the past few days just waits for next week's batch.

A real Renovate config gets large fast. These are the two lines that matter here:

```json
{
  "schedule": ["* 0-5 * * 1"],
  "minimumReleaseAge": "3 days"
}
```

A few details from [Renovate's docs][renovate-docs] are worth knowing:

- Too-new updates don't get a branch. `internalChecksFilter` defaults to `strict`, so Renovate creates no branch and no
  PR until the release passes its minimum age. Older Renovate versions defaulted differently, so check yours.
- Use cron for the schedule. Renovate still accepts text like "before 6am on monday", but that syntax is
  [deprecated][renovate-config] in favor of cron.
- Presets cover the package manager too. The [security presets][renovate-security-presets]
  (`security:minimumReleaseAgeNpm`, `…Pypi` and `…Crate`) set a 3-day age in Renovate and in the package manager. That
  stops a lockfile refresh from pulling in a brand-new transitive version behind Renovate's back.
- Missing timestamps mean waiting. Since Renovate 42, a release with no publish timestamp is treated as too new. That's
  the safe default, but some digest and container-registry updates will sit indefinitely until you make an exception.
- Security updates skip both layers. On GitHub, Renovate's vulnerability-alert PRs always ignore `schedule`, and their
  minimum release age is unset by default. A known CVE is a reason to move fast, but a human still reviews every one.

<br/>

_Rolling it out on your team_

Commit the setting to the repo, not just a personal `~/.npmrc`. A dotfile cooldown covers one laptop. The repo covers
CI, the bots, and every new hire.

Other things that tripped us up, or that we've seen trip up others:

- The units differ. npm takes days, pnpm and Yarn take minutes, and Bun takes seconds. Copy-paste across tools
  carefully. Yarn [silently ignores][yarn-cooldown] a value like `"7d"`.
- Bots need their own config. Renovate and Dependabot don't read your package manager's cooldown when deciding what to
  propose. Set it in both places.
- Old tool versions ignore it. If CI pins an older npm or pnpm that predates the setting, the setting does nothing.
  Check the versions you actually run.
- Cargo fails rather than falling back. If the only version that satisfies a constraint is too new, Cargo [errors
  instead of picking an older one][cargo-cooldowns]. For a one-off override, set
  `CARGO_RESOLVER_INCOMPATIBLE_PUBLISH_AGE=allow`. Note that `cargo install` isn't covered.
- Lockfiles still matter. A cooldown controls what you add. A lockfile controls what you keep. You need both.

The main gaps are in Go and Maven/Gradle, which have no native support yet. The [Go proposal][go-proposal] is on hold
while the team explores doing it at the proxy level. Until then, the Renovate or Dependabot layer is your cooldown for
those ecosystems.

<br/>

_What cooldowns don't fix_

Cooldowns are a good habit, but they don't solve the underlying problem. Three critiques are worth taking seriously.

Free-riding is the honest one. Cal Paterson [makes the point][calpaterson] that a cooldown works only because _someone
else_ installed the bad version first and raised the alarm. It's individually rational and collectively bonkers. If
everyone waits three days, the detection just moves to day three. Today, detection mostly comes from security vendors
scanning registries, not from victims, so the math still works. But it's worth being clear about whose diligence we're
relying on.

The exception path is also the attack path. If security fixes skip the cooldown, an attacker's best move is a malicious
release labeled "security fix." That's why our fast lane is for _known advisories_, not for any release with "security"
in the changelog. A human still reviews every one.

The real fix belongs at the registry. Upload queues, trusted publishing done properly, and phishing-resistant 2FA for
maintainers would stop these attacks before they reach anyone. Debian has held new packages before release for decades.
Every team configuring its own cooldown is a workaround for registries that don't yet do this.

So we treat cooldowns as one layer, not the strategy. We also limit install scripts, restrict network egress from CI,
and check provenance where it exists. As ChainDrop showed, provenance alone isn't enough either.

Most security controls cost something: money, latency, or developer patience. A dependency cooldown costs almost
nothing. You get last week's patch release a few days later. Turn it on, commit it to the repo, and decide now who can
approve skipping it.

<br/>

~ Ciao

[rust-1100]: https://blog.rust-lang.org/2026/11/12/Rust-1.100.0/
[dependabot-cooldown]:
  https://github.blog/changelog/2026-07-14-dependabot-version-updates-introduce-default-package-cooldown/
[woodruff]: https://blog.yossarian.net/2025/11/21/We-should-all-be-using-dependency-cooldowns
[renovate-docs]: https://docs.renovatebot.com/key-concepts/minimum-release-age/
[renovate-config]: https://docs.renovatebot.com/configuration-options/
[renovate-security-presets]: https://docs.renovatebot.com/presets-security/
[yarn-cooldown]: https://craigory.dev/blog/2026-05-29/package-manager-release-cooldown/
[cargo-cooldowns]: https://socket.dev/blog/rust-cargo-cooldowns
[go-proposal]: https://github.com/golang/go/issues/76485
[calpaterson]: https://calpaterson.com/deps.html

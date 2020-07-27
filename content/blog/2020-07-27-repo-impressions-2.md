---
slug: repo-impressions-2
date: 2020-07-27
title: "Follow up: Tracking impressions on repositories"
tags:
  - github
  - gitlab
  - impression
  - tracking
  - analytics

---

Last week, I put a [tracking pixel](/blog/2020/07/17/repo-impression-tracking) on my GitHub repositories.
And I've got to say, the results have been really interesting.
In this post, I follow up on what I've learned since last week, changes I've made, and improvements I'm working through.

<!--more-->

## Learnings

From my experience, image ping monitoring can be rather primitive.
At Indeed, we really only got information around weather a user opened an email.
It turns out, that the [Google Analytics] ping can give you a fair bit more information.
For example there's a lot of information around sessions.

![](/statics/img/2020-07-27-depscloud-gh-ga-bounce.png)

For one, I'm able to break sessions down by page.
This has helped me understand which repositories receive the most attention.
By looking at new visitors week over week by repository, I'm also able to pick up on trends.

![](/statics/img/2020-07-27-depscloud-gh-ga.png)

What I didn't realize I got from the analytics ping was session duration data.
I figured I wouldn't be able to track cross-page meta-data since each ping was independent.
But the fact I was able to get average session duration per page was really valuable.

![](/statics/img/2020-07-27-depscloud-gh-ga-session.png)

## Changes I've made

Once I had data coming in, I noticed a few things that I wanted to improve.
The first thing was the document paths and title.
While I liked having a the GitHub organization in the path, it breaks all the click through links.
As a result, I've shortened the `dp` and `dt` variables to just be the name of the repository.

In addition to changing how entries appear in Google Analytics, I've made a few other changes.
To help get more data around this approach, I've adopted this practice on my personal repositories.
I even applied it to the magic `mjpitz/mjpitz` repository that embeds a `README.md` on my profile.

## Improvements

While the data is limited at this time, the practice has already started to show value.
In my preliminary analysis, I've found a few rough edges.
Since I'm working with an image ping, there's only so many changes that I can make.
For example, most of my analysis is done off of session data.
I would love to be able to distill this information down to visitors with unique IP addresses.
It's possible that this is a feature exists and I just haven't discovered it yet.

Beyond distilling down to unique IPs, I'd also like to loop in other areas of GitHub.
For example, I use GitHub Projects to track active work items.
The unfortunate part about GitHub projects is that it changes the base URL from `https://github.com/depscloud` to `https://github.com/orgs/depscloud/projects`.
Because Analytics only allows a single website URL, we would need to create another site in Analytics for this part of content.

## In summary

In any regard, I highly recommend applying this pattern.
It allows open source maintainers to capture previously unknown segment of information.
This information can be used in a variety of ways.
From improving content, to targeting and redirection, to location analysis.
While the setup is manual and may take an afternoon, there is value in these metrics.

[Google Analytics]: https://analytics.google.com

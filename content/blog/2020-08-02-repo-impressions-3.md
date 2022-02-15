---
slug: repo-impressions-3
date: 2020-08-02
title: "Conclusion: Tracking impressions on repositories"
tags:
  - software development

---

In this post, I bring a conclusion to my recent series on tracking impressions on repositories.
While it's the last in the series, I will likely continue to post updates as time goes on.
For now, I feel my current approach has yielded a wealth of information that I'm still fully digesting.
In this conclusion, I will walk through how several of my metrics have changed since my [original approach].

<!--more-->

## Bounce Rates

In the original post, I had used the `event` type.
After a week of lack luster data, I swapped over to `pageview`.
What a difference did this make.
It kept all the metrics that I was getting from my [follow up] post and unlocked many more capabilities.
For example, I'm now able to report on bounce rates across repositories.

![Repository Breakdown](/statics/img/2020-08-02-repo-breakdown.png)

Being able to report on a bounce rate for a project is huge.
In GitHub, `topics` are used to promote your project in [Explore](https://github.com/explore).
Having a high bounce rate _could_ mean your topics aren't set up properly.
Users likely see your project in Explore, click through, and quickly realize it wasn't what they were looking for.
Unfortunately, we can't track impressions on explore so there's no way to know which topics are ineffective.

To improve your bounce rate, I'd evaluate a projects topics and compare it with others in the space.
This will give you a sense for whether a given topic is appropriate or not. 

## Page views and bounce rates over time

The `pageview` type seems to do some reconciliation that wasn't being done as part of the `event` type.
For example, there's now a distinction between page views, unique page views, and entrances.
With the `event` type, we would only get the ping, with none of these distinctions.
We still get this information with the page views metric, we're just able to distill additional information.
Consider the following graph.

![Page Views Over Time](/statics/img/2020-08-02-pageviews-over-time.png)

Both page views and events, allowed us to break views down over time.
But by using page views, we're now able to track bounce rates over time.

![Bounce Rate Over Time](/statics/img/2020-08-02-bouncerate-over-time.png)

Together, this information can be used to better tune the content of your `README.md` and `topics`.
This can help point people in the right direction on how to contribute or find additional information.

## Understanding user navigation

One of the most surprising features I was able to start to leverage was user flows.
By having this information, I can track how users navigate from one page to another.  

![Navigation Flow](/statics/img/2020-08-02-navigation-flow.png)

My [deps.cloud](https://github.com/depscloud) project has many small repositories. 
Many of which are really only useful for developers of the system, not the end users.
As a result, I try to redirect users to appropriate content from the `README.md`.
By having access to this navigational flow, I can tell if these redirects are working as expected.

---

Thank you for joining me in this series!
Be sure to check out the other parts.

- [Part 1 - Set Up](/blog/2020/07/17/repo-impression-tracking/)
- [Part 2 - Follow Up](/blog/2020/07/27/repo-impressions-2/)
- [Part 3 - Conclusion](/blog/2020/08/02/repo-impressions-3/)

[original approach]: /blog/2020/07/17/repo-impression-tracking/
[follow up]: /blog/2020/07/27/repo-impressions-2/

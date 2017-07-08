---
layout: post
title: "Delaying Asynchronous Message Processing"
redirect: http://engineering.indeedblog.com/blog/2017/06/delaying-messages/
tags:
  - indeed

---

At Indeed, we always consider what’s best for the job seeker.
When a job seeker applies for a job, we want them to have every opportunity to be hired. 
It is unacceptable for a job seeker to miss an employment opportunity because their application was waiting to be processed while the employer makes a hire. 
The team responsible for handling applies to jobs posted on Indeed maintains service level objectives (SLOs) for application processing time. 
We constantly consider better solutions for processing applications and scaling this system.

<!--more-->

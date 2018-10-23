---
layout: post
title: "Performing a Successful Application Rewrite"

---

Full application rewrites are one of the things that we as engineers try to avoid.
For a rewrite to occur, new feature development must slow down.
This is to keep the product in a stable state as the rewrite occurs. 
The larger the code base is, the more risk involved with performing one. 
In some cases, a rewrite can bring new life to an application.
In others, certain death.

I was recently involved in an application rewrite.
We took the company's iOS prototype and re-built it off of a new backing platform.
In this post, I describe the role I played in the project and the steps I took to ensure the backend would perform reliably.

<!--more-->

## Background

When I started on the project, the original implementations of the applications were set up to call each corresponding service directly.
This meant that when a client wanted to construct a view, they needed to know which backing service to call out to for that information. 
This resulted in business logic being shipped along into the applications, coupling them with the backing systems.

<br/>
<div style="text-align:center">
    <img src="/statics/img/performing-a-successful-rewrite--0.png" alt="original" title="Original Implementation" />
</div>
<br/>

When we built out one feature on iOS, we often needed to duplicate that logic across both clients. 
This duplication came with some amount of risk, but in the end enabled both platforms to be built alongside one another. 
In the rewrite of the application, one of the key goals was to pull some of this business logic up into a data aggregation layer.
This layer was responsible for knowing how to assemble to core view models used by the clients by calling out to the appropriate backend service.

<br/>
<div style="text-align:center">
    <img src="/statics/img/performing-a-successful-rewrite--1.png" alt="rewrite" title="Rewritten Implementation" />
</div>
<br/>

My role was to build out this new data aggregation layer for the next iteration of the application. 
While it’s functionality was rather simple, there were a lot of things to consider about the addition of this layer.

## Maintaining Feature Parity

## Ensuring System Reliability

## Securing GraphQL

## The Result

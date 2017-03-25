---
layout: post
title: "Gracefully Degrading Functionality Using Status"
redirect: http://engineering.indeedblog.com/blog/2017/01/degrade-functionality/
---

In a previous blog post, we described how to use our Status library to create a robust health check for your applications. 
In this follow-up, we show how you can check and degrade your application during an outage by:

* short-circuiting code paths of your application
* removing a single application instance from a data center load balancer
* removing an entire data center from rotation at the DNS level

<!--more-->

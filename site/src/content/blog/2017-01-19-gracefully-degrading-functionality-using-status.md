---
title: "Gracefully Degrading Functionality Using Status"
pubDate: "January 19 2017"
heroImage: '/img/blog-placeholder-5.jpg'
description: ""

slug: 2017/01/19/gracefully-degrading-functionality-using-status
canonical: http://engineering.indeedblog.com/blog/2017/01/degrade-functionality/
tags:
  - software development

---

In a previous [blog post](/blog/2015/07/10/status-java-library-for-system-status-health-checks/), we described how to use our [Status] library to create a robust health check for your applications. 
In this follow-up, we show how you can check and degrade your application during an outage by:

* short-circuiting code paths of your application
* removing a single application instance from a data center load balancer
* removing an entire data center from rotation at the DNS level

<!--more-->
Evaluating application health
The Status library allows you to perform two different types of checks on a system — a single dependency check and a system-wide evaluation. A dependency is a system or service that your system requires in order to function.

During a single dependency check, the [AbstractDependencyManager] uses an evaluate method that takes the dependency’s ID and returns a [CheckResult].

A `CheckResult` includes:

* the health of the dependency
* some basic information about the dependency
* the time it took to evaluate the health of the dependency

A CheckResult is a Java enum that is one of `OK`, `MINOR`, `MAJOR`, or `OUTAGE`.
The `OUTAGE` status indicates that the dependency is not usable.

```java
final CheckResult checkResult = dependencyManager.evaluate("dependencyId");
final CheckStatus status = checkResult.getStatus();
```

The second approach to evaluating an application’s health is to look at the system as a whole.
This gives you a high-level overview of how the entire system is performing.
When a system is in `OUTAGE`, this indicates that the instance of an application is not usable.

```java
final CheckResultSet checkResultSet = dependencyManager.evaluate();
final CheckStatus systemStatus = checkResultSet.getSystemStatus();
```

If a system is unhealthy, it’s often best to short circuit requests made to the system and return an HTTP status code 500 (“Internal Server Error”).
In the example below, we use an interceptor in Spring to capture the request, evaluate the system’s health, and respond with an error in the event that the application is in an outage.

```java
public class SystemHealthInterceptor extends HandlerInterceptorAdapter {
    private final DependencyManager dependencyManager;
 
    @Override
    public boolean preHandle(
            final HttpServletRequest request,
            final HttpServletResponse response,
            final Object handler
    ) throws Exception {
        final CheckResultSet checkResultSet = dependencyManager.evaluate();
        final CheckStatus systemStatus = checkResultSet.getSystemStatus();
         
        switch (systemStatus) {
            case OUTAGE:
                response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
                return false;
            default:
                break;
        }
 
        return true;
    }
}
```

## Comparing the health of dependencies

[CheckResultSet] and [CheckResult] have methods for returning the current status of the system or the dependency, respectively. 
Once you have CheckStatus, there are a couple of methods that allow you to compare the results.

`isBetterThan()` determines if the current status is better than the provided status. This is an exclusive comparison.

```java
CheckStatus.OK.isBetterThan(CheckStatus.OK)              // evaluates to false
CheckStatus.OK.isBetterThan(/* any other CheckStatus */) // evaluates to true
```

`isWorseThan()` determines if the current status is worse than the provided status. Again, this operation is exclusive.

```java
CheckStatus.OUTAGE.isWorseThan(CheckStatus.OUTAGE)          // evaluates to false
CheckStatus.OUTAGE.isWorseThan(/* any other CheckStatus */) // evaluates to true
```

The `isBetterThan()` and `isWorseThan()` methods are great tools to check for a desired state of an evaluated dependency.
Unfortunately, these methods do not offer enough control to produce a graceful degradation.
Either the system was healthy, or it was in an outage.
To better control the graceful degradation of our system, two additional methods were needed.

`noBetterThan()` returns the unhealthier of the two statuses.

```java
CheckStatus.MINOR.noBetterThan(CheckStatus.MAJOR) // returns CheckStatus.MAJOR
CheckStatus.MINOR.noBetterThan(CheckStatus.OK)    // returns CheckStatus.MINOR
```

`noWorseThan()` returns the healthier of the two statuses.

```java
CheckStatus.MINOR.noWorseThan(CheckStatus.MAJOR) // returns CheckStatus.MINOR
CheckStatus.MINOR.noWorseThan(CheckStatus.OK)    // returns CheckStatus.OK
```

During the complete system evaluation, we use a combination of these methods and the `Urgency#downgradeWith()` methods to gracefully degrade our application’s health.

By having the ability to inspect the outage state, engineers can dynamically toggle feature visibility based on the health of its corresponding dependency.
Suppose that our service that provides company information was unable to reach its database.
The service’s health check would change its state to MAJOR or OUTAGE.
Our job search product would then omit the company widget from the right rail on the search results page.
The core functionality that helps people find jobs would be unaffected.

**Healthy**

![healthy](/img/2017-status-healthy.png)

**Unhealthy (Gracefully)**

![gracefully unhealthy](/img/2017-status-unhealthy.png)

Status offers more than just the ability to control features based on a service’s health.
We also use it to control access to instances of our front end web applications.
When an instance is unable to service requests, we remove it from the load balancer until it is healthy again.

## Instance level failovers

Generally, running multiple instances of your application in production is highly recommended.
This helps keep your system resilient by allowing it to continue to handle requests even if a single instance of your application crashes.
These instances of your application can live on a single machine, multiple machines, and even in multiple data centers.

The Status library lets you configure your load balancer to remove an instance if it becomes unhealthy.
Consider the following basic example within a single data center.

![all healthy](/img/2017-status-all-healthy.png)

_When all of the applications within a single data center are healthy, the load balancer distributes requests among them evenly. To determine if an application is healthy, the load balancer sends a request to the health check endpoint and evaluates the response code._

![one unhealthy](/img/2017-status-one-unhealthy.png)

_When an instance becomes unhealthy, the health check endpoint returns a non-200 status code, indicating that it should no longer receive traffic. The load balancer then removes the unhealthy instance from rotation, preventing it from receiving requests._

![one removed](/img/2017-status-one-removed.png)

_When instance 1 is removed from rotation, the other instances within a data center start to receive instance 1’s traffic. Within each data center, we provision enough instances so that we can handle traffic even if some of the instances go down._

## Data center level failovers

Before a request is even sent to a data center, our domain (e.g. www.indeed.com) is resolved to an IP address using DNS. We use Global Server Load Balancer (GSLB) that allows us to geographically distribute traffic across our data centers. After the GSLB resolves the domain to the IP address of the nearest available data center, the data center load balancer then routes and fails over traffic as described above.

![healthy](/img/2017-status-dc-healthy.png)

What if an entire data center can no longer service requests? Similar to the single instance approach, GSLB constantly checks each of our data centers for their health (using the same health check endpoint). When GSLB detects that a single data center can no longer service requests, it fails requests over to another data center and removes the unhealthy data center from rotation. Again, this helps keep the site available by ensuring that requests can be processed, even during an outage.

![failout](/img/2017-status-dc-removed.png)

As long as a single data center remains healthy, the site can continue to service requests. For users that hit unhealthy data centers, this just looks like a slower web page load. While not ideal, the experience is better than an unprocessed request.

The last scenario is a complete system outage. This occurs when every data center becomes unhealthy and can no longer service requests. Engineers try to avoid this situation like the plague.

![failopen](/img/2017-status-all-dc-removed.png)

When Indeed encounters complete system outages, we reroute traffic to every data center and every instance. This policy, known as “failing open,” allows for graceful degradation of our system. While every instance may report an unhealthy state, it is possible that an application can perform some work. And being able to perform some work is better than performing no work.

## Status works for Indeed and can work for you

The [Status] library is an integral part of the systems that we develop and run at Indeed. We use Status to:

* quickly fail over application instances and data centers
* detect when a deploy is going to fail before the code reaches a high traffic data center
* keep our applications fast by failing requests quickly, rather than doing work we know will fail
* keep our sites available by ensuring that only healthy instances of our applications service requests

To get started with Status, read our [quick start guide] and take a look at the [samples].
If you need help, you can reach out to us on [GitHub] or [Twitter].

[Status]: https://github.com/indeedeng/status
[AbstractDependencyManager]: https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/AbstractDependencyManager.java
[CheckResult]: https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/CheckResult.java
[CheckResultSet]: https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/CheckResultSet.java
[quick start guide]: http://opensource.indeedeng.io/status/docs/quick-start/
[samples]: https://github.com/indeedeng/status/tree/master/status-samples
[GitHub]: https://github.com/indeedeng/
[Twitter]: https://twitter.com/indeedeng

---
title: "Status: A Java Library For Robust System Status Health Checks"
pubDate: "July 10 2015"
description: |
  We are excited to highlight the open source availability of Status, a Java library that can report a system’s status in a readable format.
  The Status library enables dynamic health checks and monitoring of system dependencies.
  In this post, we will show how to add health checks to your applications.

canonical: https://engineering.indeedblog.com/blog/2015/07/status-java-library-for-system-status-health-checks/
slug: 2015/07/10/status-java-library-for-system-status-health-checks
tags:
  - software development
---

We are excited to highlight the open source availability of [Status], a Java library that can report a system’s status in a readable format.
The Status library enables dynamic health checks and monitoring of system dependencies.
In this post, we will show how to add health checks to your applications.

<!--more-->

## Why use system status health checks?
Health checks play an important role at Indeed. We set up and run large-scale services and applications every day.
Health checks allow us to see the problematic components at an endpoint, rather than combing through logs.

In production, a health check can let us know when a service is unreachable, a file is missing, or the system cannot talk with the database.
Additionally, these health checks provide a controlled way for developers to communicate issues to system administrators.
In any of these situations, the application can evaluate its own health check and gracefully degrade behavior, rather than taking the entire system offline.

The Status library will capture stack traces from dependencies and return the results in a single location.
This feature makes it easy to resolve issues as they arise in any environment.
Typical dependencies include MySQL tables, MongoDB collections, RabbitMQ message queues, and API statuses.

## System states

When dependencies fail, they affect the condition of the system. 
System states include:

* OUTAGE – the system is unable to process requests;
* MAJOR – the system can service some requests, but may fail for the majority;
* MINOR – the system can service the majority of requests, but not all;
* OK – the system should be able to process all requests.

## Get started with Status

Follow these instructions to start using the [Status] library:

Extend the [AbstractDependencyManager](https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/AbstractDependencyManager.java). 
The dependency manager will keep track of all your dependencies.

```java
public class MyDependencyManager extends AbstractDependencyManager {
  public MyDependencyManager() {
    super("MyApplication");
  }
}
```

Extend [PingableDependency] for each component that your application requires to run.

```java
public class MyDependency extends PingableDependency {
  @Override
  public void ping() throws Exception {
    // Throw exception if considered unhealthy or unavailable
  }
}
```

Extending the [PingableDependency] class is the simplest way to incorporate a dependency into your application.
Alternatively, you can extend [AbstractDependency] or [ComparableDependency] to get more control over the state of a dependency.
You can control how your dependency affects the system’s condition by providing an [Urgency] level.

Add your new dependencies to your dependency manager.

```java
dependencyManager.addDependency(myDependency);
// ...
```

For web-based applications and services, create an [AbstractDaemonCheckReportServlet](https://github.com/indeedeng/status/blob/master/status-web/src/main/java/com/indeed/status/web/AbstractDaemonCheckReportServlet.java) that will report the status of your application.

```java
public class StatusServlet extends AbstractDaemonCheckReportServlet {
  private final AbstractDependencyManager manager;
 
  public StatusServlet(AbstractDependencyManager manager) {
    this.manager = manager;
  }
 
  @Override
  protected AbstractDependencyManager newManager(ServletConfig config) {
    return manager;
  }
}
```

Once this process is complete and your application is running, you should be able to access the servlet to read a JSON representation of your application status.

Below is a sample response returned by the servlet. 
If the application is in an OUTAGE condition, the servlet returns a 500 status code. 
Associating the health check outcome with an HTTP status code enables integration with systems (like [Consul](https://consul.io/)) that make routing decisions based on application health.
Otherwise, the servlet returns a 200 since it can still process requests.
In this case, the application may gracefully degrade less-critical functionality that depends on unhealthy code paths.

```json
{
  "hostname": "pitz.local",
  "duration": 19,
  "condition": "OUTAGE",
  "dcStatus": "FAILOVER",
  "appname": "crm.api",
  "catalinaBase": "/var/local/tomcat",
  "leastRecentlyExecutedDate": "2015-02-24T22:48:37.782-0600",
  "leastRecentlyExecutedTimestamp": 1424839717782,
  "results": {
    "OUTAGE": [{
      "status": "OUTAGE",
      "description": "mysql",
      "errorMessage": "Exception thrown during ping",
      "timestamp": 1424839717782,
      "duration": 18,
      "lastKnownGoodTimestamp": 0,
      "period": 0,
      "id": "mysql",
      "urgency": "Required: Failure of this dependency would result in complete system outage",
      "documentationUrl": "http://www.mysql.com/",
      "thrown": {
        "exception": "RuntimeException",
        "message": "Failed to communicate with the following tables:
          user_authorities, oauth_code, oauth_approvals, oauth_client_token,
          oauth_refresh_token, oauth_client_details, oauth_access_token",
        "stack": [
          "io.github.jpitz.example.MySQLDependency.ping(MySQLDependency.java:68)",
          "com.indeed.status.core.PingableDependency.call(PingableDependency.java:59)",
          "com.indeed.status.core.PingableDependency.call(PingableDependency.java:15)",
          "java.util.concurrent.FutureTask.run(FutureTask.java:262)",
          "java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)",
          "java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)",
          "java.lang.Thread.run(Thread.java:745)"
        ]
      },
      "date": "2015-02-24T22:48:37.782-0600"
    }],
    "OK": [{
      "status": "OK",
      "description": "mongo",
      "errorMessage": "ok",
      "timestamp": 1424839717782,
      "duration": 0,
      "lastKnownGoodTimestamp": 0,
      "period": 0,
      "id": "mongo",
      "urgency": "Required: Failure of this dependency would result in complete system outage",
      "documentationUrl": "http://www.mongodb.org/",
      "date": "2015-02-24T22:48:37.782-0600"
    }]
  }
}
```

This report includes these key fields to help you evaluate the health of a system and the health of a dependency:

* `condition` - Identifies the current health of the system as a whole.
* `leastRecentlyExecutedDate` - The last date and time that the report was updated.

Use these fields to inspect individual dependencies:

* `status` - Identifies the health of the current dependency.
* `thrown` - The exception that caused the dependency to fail.
* `duration` - The length of time it took to evaluate the dependency’s health. Because the system caches the result of a dependency’s evaluation, this value can be 0.
* `urgency` - The urgency of the dependency. Dependencies with a WEAK urgency may not need to be fixed immediately. Dependencies with a REQUIRED urgency must be fixed as soon as possible

## Learn more about Status

Stay tuned for a [future post](/blog/2017/01/19/gracefully-degrading-functionality-using-status/) about using the Status library, in which we’ll show how to gracefully degrade unhealthy applications. 
To get started, read our [quick start guide] and take a look at the [samples]. 
If you need help, you can reach out to us on [GitHub] or [Twitter].


[Status]: https://github.com/indeedeng/status
[AbstractDependencyManager]: https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/AbstractDependencyManager.java
[PingableDependency]: https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/PingableDependency.java
[AbstractDependency]: https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/AbstractDependency.java
[ComparableDependency]: https://github.com/indeedeng/status/blob/master/status-core/src/main/java/com/indeed/status/core/ComparableDependency.java
[Urgency]: https://github.com/indeedeng/status/blob/fff009ad24d1641afe6d792e582e374e8e5f63a6/status-core/src/main/java/com/indeed/status/core/Urgency.java
[quick start guide]: http://opensource.indeedeng.io/status/docs/quick-start/
[samples]: https://github.com/indeedeng/status/tree/master/status-samples
[GitHub]: https://github.com/indeedeng/
[Twitter]: https://twitter.com/indeedeng

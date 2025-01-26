---
title: "Spring Bean Method Invocation"
pubDate: "April 1 2017"
description: |
  In my day to day development, I spend a fair bit of time working with Spring since it offers a lot of scaffolding to get a project off the ground.
  At Indeed, I spent a fair bit of time upgrading us from Spring 3 to Spring 4 and came across many good uses of Spring and many bad ones too.
  In this Bad Practices series, I will talk about some of these bad practices, why they should be avoided, and what you can do instead.

slug: 2017/04/01/spring-bean-method-invocation
tags:
  - software development
  
---

In my day to day development, I spend a fair bit of time working with [Spring] since it offers a lot of scaffolding to get a project off the ground.
At [Indeed], I spent a fair bit of time upgrading us from Spring 3 to Spring 4 and came across many good uses of Spring and many bad ones too.
In this _Bad Practices_ series, I will talk about some of these bad practices, why they should be avoided, and what you can do instead.

<!--more-->

```java
@Configuration
public class MyConfig {
    @Bean
    public Service myService() {
        ...
    }
    
    @Bean
    public ServiceCacheWrapper myServiceCache() {
        ...
        myService();    // bad!
        ...
    }
}
```

This is generally considered a bad practice because it hides edges in the dependency graph from Spring during the pre processing step.
While much easier for developers to understand where beans are coming from, this approach has some downfalls when it comes to runtime.
With a missing edge in the dependency graph, your application is more prone to a variety of start up failures.

### Instead: Inject through Method Signature
 
```java
@Configuration
public class MyConfig {
    @Bean
    public Service myService() {
        ...
    }
    
    @Bean
    public ServiceCacheWrapper myServiceCache(
        final Service myService
    ) {
        ... = myService;
    }
}
```

Spring uses reflection at runtime to inspect annotated method signatures and construct the dependency graph of your application.
From the signature, Spring will:

* infer the name of the method as the bean name if one is not provided in the [@Bean] annotation.
* interpret the return type as the type to match on constructors / methods where no [@Qualifier] is provided on the designated parameter.
* Use the parameter types as the accepted class that should be wired in.
  * **Note** that Spring cannot use parameter names as the name of the beans since those are re-written by the compiler.
  * To clarify which of the many beans you may have defined in your dependency graph, you can use the [@Qualifier] annotation.

With this information, it's able to:
know about all the nodes;
know about all the edges;
reliably build the complete dependency graph.

<!--Recently, I came across a talk that spoke of a powerful optimization that will speed up application start up.-->
<!--It can do this by pre-processing the dependency graph and writing it out to an artifact during compilation.-->
<!--This artifact can then be read in at startup and processed without needing to re-scan all the dependant jar files.-->

[Spring]: https://spring.io/
[Indeed]: https://www.indeed.com/
[@Qualifier]: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Qualifier.html
[@Bean]: http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html

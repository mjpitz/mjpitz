---
title: "Component Scanning Library Code"
pubDate: "April 18 2017"
heroImage: '/img/blog-placeholder-3.jpg'
description: ""

slug: 2017/04/18/spring-component-scanning
tags:
  - software development
  
---

Component scanning packages can be both your best friend and worst nightmare.
In this post, I will cover several bad practices when it comes to component scanning.
In detailing a few of these anti-patterns, I will also offer a few better patterns that are much cleaner to use.

<!--more-->

## Abuse of ComponentScan.Filter

[@ComponentScan.Filter] has its uses, but I often find it used incorrectly.
One case where I've seen this used is when they don't want to pull in [@Controller]'s.
This usually happens when someone wants to pull code into a background daemon or cronjob.
In these types of applications, you may not have a web server running for the controllers to bind to.
To better handle this pattern, the library can offer two different [@Configuration] classes.
One for the non-web context, and one for the web.
This offers a few benefits over component scanning.

1. The library has complete control over the configuration class and can add [@Bean]s as they need to.
2. The importing application know exactly what [@Bean]s they are importing.
3. It is much more obvious what to do to start using the library. They import the configuration, and then move on with their day.

Another way to address this filtering problem is to better structure the target package to better support scanning.
One way I've found to better support this, is by offering a ```core``` and ```web``` package.
This makes it clear that all the web components should belong to the ```web``` package, while all other components should be in the ```core``` package.
This approach has an added benefit.
Suppose that one day in the future, your web package has grown and now you need to break it out into it's own library.
This happens for a variety of reasons, one of the most common being to slim down transitive dependencies.
With this package structure, you can now split out the web code with very little effort. 


## Component Scanning Library Code

This is another pattern that I've see used in a few different cases.
The biggest downside to this approach is that by scanning a single package, you open yourself up to all the beans that come along with it.
Keep in mind, that often times packages become split across several libraries.
That means that one day your may be pulling in only 10 beans, but the next you may add a new project dependency and now be pulling in 100.
Now if the package space that you are defining is specific enough to a single project, then scan away.
My general line in the sand is to not component scan outside the context of the project that I'm working on.
Additionally, I abide to the former principle of ensuring that all projects have a specific namespace.
I've found this to be a pretty practical practice both within library and application code.


## ComponentScan#useDefaultFilters

The documentation around this code is a little misleading.

From [@ComponentScan#useDefaultFilters]:

> Indicates whether automatic detection of classes annotated with @Component @Repository, @Service, or @Controller should be enabled.

Many people read this and assume that [@Configuration] classes aren't picked up in the scan.
As a result, they often add an include [@ComponentScan.Filter] to be extra sure they are pulling in configurations.
It's important to note that without the addition of the filter, [Spring] would still wire up the configuration into the context.
This is because the [@Configuration] class is a specialization of [@Component].
In looking at the source code, you can see it is annotated with [@Component]:

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Configuration {
```

[source](https://github.com/spring-projects/spring-framework/blob/master/spring-context/src/main/java/org/springframework/context/annotation/Configuration.java#L404)


[Spring]: https://spring.io/
[@Component]: http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Component.html
[@Configuration]: http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html
[@Import]: http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Import.html
[@Controller]: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Controller.html
[@Bean]: http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html
[@ComponentScan.Filter]: http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/ComponentScan.Filter.html
[@ComponentScan#useDefaultFilters]: http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/ComponentScan.html#useDefaultFilters--

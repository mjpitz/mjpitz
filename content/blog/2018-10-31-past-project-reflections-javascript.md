---
slug: past-project-reflections-javascript
date: 2018-10-31
title: "Reflecting on Past Projects - JavaScript"

---

Every now and then, a friend of mine reaches out and discuss previous projects we had worked on together.
As we looked back at code, there was some obvious lessons that we took away from the project.
In this post, I reflect on several JavaScript projects that I have worked on over the course of my career.
In each project, I will try to provide:

* technologies used and rough size of project
* an overview of the project
* a critique about the approach taken to manage the project
* what I would’ve done differently

<!--more-->

## Rochester Institute of Technology

### Educational Design Resources

_October 2009 - September - 2012_

Core Technologies: Windows IIS, JavaScript, jQuery

Lines of Code: unknown

During my college career, I worked for a small development shop on campus.
We built applications that facilitated the education of deaf and hard of hearing students.
One of our platforms enabled students to submit assignments in a manner more familiar to them, using sign language.
We did this by providing live video streaming and video recording functionality in a browser.
At the time, services like Youtube were young and lacked support for private channels.
Due to the lack of access restrictions, we had to build our own video hosting platform.

Pros:
* full stack JavaScript for easy code reuse
* mono-repo, easy to make cross-cutting changes
* delegated functionality to external services (Wowza Media Server for storage)

Cons:
* use of slow IIS JavaScript Runtime
* no dependency management
* required tribal knowledge to be effective

In the end, the system worked but was a nightmare to maintain.
Looking back, there are many things that I would have done differently.
Technology has certainly progressed since then .
Keep in mind, many of the modern tool sets available to you today may not have been available then.

## Indeed

### Employer Products

_June 2013 - December 2015_

Core Technologies: Java, JavaScript, Closure, jsdoc-typed

Lines of Code: 20K+

I joined Indeed working on the employer products.
This application allowed employers to post a job directly on our site and manage all candidates that apply.
We built the product targeting small to medium sized businesses.
Many larger systems were difficult for these smaller companies to get started.
Indeed sought to make the experience better.

Pros:
* static type checking via the Closure Linter
* wholistic tool chain provided by Closure
* able to apply object oriented principles to frontend application development

Cons:
* not widely used, making it difficult to find support
* few internal experts on the framework
* dependency management of frontend dependencies coupled to backend

The biggest critique I had about this system was how it grew.
Instead of refactoring and pulling parts out into their own system, we added more and more to the single system.
We took a prototype, continued to iterate on it, and pushed it through to production.
The biggest lesson I took away from this project was that sometimes, it's ok to slow down and refactor.
Every now and then, this is a necessity.


### Eclair

_June 2016 - April 2018_

Core Technologies: Java, JavaScript, NodeJS, jsdoc-typed

Lines of Code: < 5K

Eclair is a process I wrote to facilitate upgrading Spring from version 3 to 4 at Indeed.
Major library upgrades come with a fair amount of risk involved.
Classes that are deprecated are often cleaned up.
Components move between packages.
In the end, you have a set of changes that must be applied to your code base.
Before getting into the details of the library upgrade, I first build Darwin.
This service parsed dependency management files and maintained a queryable graph of dependencies.
Eclair used this API to apply the set of changes to every project that was impacted by the upgrade.

Pros:
* NPM made managing dependencies really easy
* worked on the command line and was easy to trace through
* system ran quickly and was easy to grow over time

Cons:
* use of jsdoc types proved to be cumbersome 
* jsdoc types didn’t work well for things that weren’t imported directly
* using wrong node version caused some events to be emitted differently
* lack of included logging made it difficult to track down problems

This being one of my first independent code bases, it’s hard to sit and critique it.
First, I would have baked in a better troubleshooting feature.
This would help facilitate investigations when other engineers were attempting to run the program. 
Another thing I would have done differently was build in reporting from the start.
Often times, we wanted to have a cohesive report of the state of the world before the change set was applied, and after.

## Dosh

### GraphQL

_May 2018 - November 2018_

Core Technologies: AWS Lambda, JavaScript, NodeJS, flow-typed

Lines of Code: ~ 13K

After Indeed, I wanted to vary up some of the technical experience that I had exposure to.
A colleague of mine had recently gone and joined Dosh, a cash back app.
Their backend systems were going through a large rewrite of some of their system components.
Upon joining, I was assigned to build out our new graphql layer.
Much of the schema was already specified and it was my job to glue the remote service calls into place.
It gave me great exposure to all the backing systems which drove our front end and running on AWS Lambda.

Pros:
* flow finally started bringing some static type analysis to JavaScript
* code base was sectioned by level of authentication, making exposure levels clear

Cons:
* flow’s opt-in model became difficult to work with on a largely untyped code base
* flow types aren’t preserved across library boundaries
* supporting compilation and flow meant adding babel and tons of plugins to support
* result in a lot of development toil needing to track down the right plugin for the right job

All in all, I really liked this project.
While working with flow and babel was painful at times, it wound up saving a lot of headaches.
The biggest thing I would do differently was use a types file to declare service contracts.
By using something like a `.d.ts`, you would be able to attach the types to the package.
Those types are then shipped along with the client when users install via npm.

## At Home

### Finch

_May 2018 - Present_

Core Technologies: Docker, TypeScript, NodeJS

Lines of Code: ~ 5K

The last project I wanted to talk about was a recent project I started after leaving Indeed.
This project was intended to be the evolution of the Darwin process I wrote at Indeed.
Darwin was written to accomplish a single task.
It turned into a system that proved promising to automate a good portion of process.
And so I started working on Finch in my free time.
Finch is a process composed of 3 parts: a crawler, a web interface, and a service.
Since this system was largely handling parsing and normalizing of XML and JSON data, I chose to write it in JavaScript.
Instead of using Flow, I decided to take TypeScript for a bigger spin.
In the past, I played around with TypeScript a bit in the past and it seemed really promising.
With this project, I finally had an opportunity to use it in a larger scale project.
I instantly fell in love with the simplicity and reduced toolchain that came with it.

Pros:
* reduced toolchain, making development straight forward
* works with existing NodeJS ecosystem
* establishing abstractions and integration points becomes intuitive

Cons:
* migrating to lerna is proving to be difficult, but not impossible

In retrospect, I really wish I figured out the multi-package story.
When I started the project, I did try to incorporate lerna.
But that only seemed to hinder the process of developing the proof of concept.
So I decided to shelve the multi-package story.
Instead, I isolated components using packaging and establishing rules between them.
In the end, I still found myself wanting the distinct independent packages.

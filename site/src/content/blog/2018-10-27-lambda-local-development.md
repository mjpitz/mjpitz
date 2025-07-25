---
title: "AWS Lambda - Local Development"
pubDate: "October 27 2018"
description: |
  While working at Dosh, I had pretty heavy exposure to managing NodeJS services running in AWS Lambda.
  During that time, I had learned a few things about the platform that can be leveraged when writing Lambda services.
  Some of these lessons may influence how you write services but can also give you some performance boosts.
  It’s important to note that some of the behaviors that I observed about AWS Lambda may not apply to other serverless technologies.

slug: 2018/10/27/lambda-local-development
tags:
  - software development
---

While working at Dosh, I had pretty heavy exposure to managing NodeJS services running in AWS Lambda. During that time,
I had learned a few things about the platform that can be leveraged when writing Lambda services. Some of these lessons
may influence how you write services but can also give you some performance boosts. It’s important to note that some of
the behaviors that I observed about AWS Lambda may not apply to other serverless technologies.

<!--more-->
<hr/>

Developing locally enables engineers to test their changes before sending it off to a cloud. Running on AWS Lambda, I
found myself wondering just how you might test lambda HTTP endpoints locally. A few of my co-workers pointed me at
[serverless-offline](https://www.npmjs.com/package/serverless-offline). This system works by standing up an http proxy,
constructing the expected data payload, and executing `sls invoke local` under the hood. This approach enabled testing
of functions locally with little effort, but didn’t enable service to service testing.

<br/>
<div style="text-align:center">
    <img src="/img/localstack.png" alt="localstack" title="Localstack Header" />
</div>
<br/>

Next I considered [localstack](https://github.com/localstack/localstack). Localstack offers a wide range of mock AWS
services for testing or developing locally. While I was able to get localstack up and running, I wasn’t able to deploy
my lambda functions. After a fair bit of digging around, I filed a bug with what I was able to find and moved onto
locating another option.

<br/>
<div style="text-align:center">
    <img src="/img/serverless.png" alt="serverless" title="Serverless" />
</div>
<br/>

Finally, I came across [serverless-plugin-simulate](https://www.npmjs.com/package/serverless-plugin-simulate). This did
a great job separating the lambda execution environment from the API gateway. By doing so, I was able to run a single
“lambda” instance on top of all the code and start up individual API gateways for each service. This approach started to
feel more like the AWS ecosystem. Not only did it start to look more like the ecosystem, it also enabled end to end
testing of changes. The biggest downside to this approach was that the plugin needed to be installed on all services. If
it could be abstracted into a stand-alone process, then it could be an extremely powerful tool for Lambda development.

In the end, I wound up using serverless-offline to test each change in isolation. Then doing incremental integration
tests in our development environment before proceeding to staging and production.

---
slug: lambda-handler-lifetime
date: 2018-10-28
title: "AWS Lambda - Handler Lifetime"
tags:
  - software development

---

While working at Dosh, I had pretty heavy exposure to managing NodeJS services running in AWS Lambda.
During that time, I had learned a few things about the platform that can be leveraged when writing Lambda services.
Some of these lessons may influence how you write services but can also give you some performance boosts.
It’s important to note that some of the behaviors that I observed about AWS Lambda may not apply to other serverless technologies.

<!--more-->
<hr/>

When I first began working on AWS Lambda, I was skeptical.
I remember a conversation with my manager where I made the comment about how Lambda feels like we are writing PHP transaction scripts all over again.
As time went on, I learned a few things about the way that AWS Lambda manages it’s containers under the hood.
By far, the biggest thing I took away was how long the lifespan of a Lambda function actually is.
Consider the following Typescript handler:
<br/><br/>

```typescript
import { APIGatewayEvent, Callback, Context, Handler } from 'aws-lambda';
import * as uuidv4 from "uuid/v4";

const instanceId = uuidv4();

export const hello: Handler = (event: APIGatewayEvent, context: Context, cb: Callback) => {
  const response = {
    statusCode: 200,
    headers: {
        "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: 'Go Serverless Webpack (Typescript) v1.0! Your function executed successfully!',
      instanceId,
      input: event,
    }),
  };

  cb(null, response);
}
```

<br/>
My initial understanding of AWS Lambda was that every execution of a handler, would result in a new context.
To me, that meant that instanceId would be different for every execution of the function.
In fact, you can see this using the [serverless-offline](https://www.npmjs.com/package/serverless-offline) plugin (a common utility for locally testing AWS Lambda functions).
<br/><br/>

<div>
    <div style="text-align:center">
        <p><i>Execution 1</i></p>
        <img src="/statics/img/offline-execution-1.png" alt="Execution 1" title="Execution 1"/>
    </div>
    <br/>
    <div style="text-align:center">
        <p><i>Execution 2</i></p>
        <img src="/statics/img/offline-execution-2.png" alt="Execution 2" title="Execution 2"/>
    </div>
    <br/>
    <div style="text-align:center">
        <p><i>Execution 3</i></p>
        <img src="/statics/img/offline-execution-3.png" alt="Execution 3" title="Execution 3"/>
    </div>
    <br/>
</div>

<br/>
Once I got into production, we saw a very different type of behavior.
Instead of seeing one instanceId per request, we saw many requests being handled my the same instanceId.
<br/><br/>

<div class="row">
    <div style="text-align:center">
        <img src="/statics/img/executions-per-instance.png" alt="Executions/Instance" title="Executions/Instance"/>
    </div>
</div>

<br/>
What this meant was that the application container for a Lambda function was spun up and reused to service **multiple** requests.
This was the first bit of insight into how AWS makes Lambda functions work efficiently.
One way I’ve been able to think about the underlying infrastructure was equating it to an elastic container pool. 
Lambda (or the container pool), maintains some minimum number of provisioned instances responsible for servicing traffic.
When a request comes in, Lambda attempts to pull from it’s pool of existing containers.
If we were able to find an existing container, then it is used to service the current request. 
If we were unable to find an existing container, then we spin up a new one to service the current request (cold start). 
When a request completes, its container is returned to the pool for reuse.
After some idle time, containers are shut down to keep resources to a minimum.
In practice, this process is distributed across a cluster of machines so that there is no single point of failure.

From an engineering standpoint, this means that we can write lambda functions a lot like how we write your typical HTTP server.
Services that load some data at start up can continue to benefit by doing that once and then re-using the loaded data for subsequent requests.
Many of our reliability patterns can continue to be applied, such as circuit breaking, persistent connections, and distributed tracing.
All in all, working in AWS Lambda isn't all that different from your typical application development.
<br/><br/>

_Update: 2018-10-29_

I went and took a look at some larger windows of time.
Over a 24 hour window, I found some lambda's running all day and even all night.
The image below shows a provisioned lambda running from 9pm to 2am US Central Time.
<br/><br/>

<div class="row">
    <div style="text-align:center">
        <img src="/statics/img/long-running-lambda.png" alt="Long Running Lambda" title="Long Running Lambda"/>
    </div>
</div>
<br/>

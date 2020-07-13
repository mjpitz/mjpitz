---
slug: nodejs-grpc-code-reference
date: 2018-05-07
title: "NodeJS gRPC Code Reference"

---

While working at Indeed, I did a fair amount with [gRPC](https://grpc.io/).
I became rather familiar with the Java, Go, NodeJS, and python implementations.
During my vacation between jobs, I decided to revisit one of my old projects and try to migrate it to using gRPC.
By doing so, I would be able to support a larger variety of request types (streaming, non-streaming, etc).
When I started to look for good NodeJS code samples or reference implementations, I was rather disappointed with what I found.
Many of the ones I could get my hands on only demonstrated unary methods and not any of the streaming API's.
After a lot of time digging through source and a few implementations online, I finally assembled a good reference.

In this post, I only wanted to detail what the method calls look like on both ends of the wire.
There are some additional best practices that should be taken into consideration, but I do not plan on covering those here.


<!--more-->

## Protocol Buffers Definition

```
message Request {
}

message Response {
}

service MyService {
    rpc unaryMethod(Request) returns (Response);
    rpc clientStreamingMethod(stream Request) returns (Response);
    rpc serverStreamingMethod(Request) returns (stream Response);
    rpc bidirectionalStreamingMethod(stream Request) returns (stream Response);
}
```

## Service Implementation

```js
const grpc = require('grpc');
const MyServiceGrpc = grpc.load(require.resolve('./MyService.proto'));

class MyServiceImpl {
    unaryMethod(call, callback) {
        const request = call.request;
        // handle request
        callback('error', response);
    }
    
    clientStreamingMethod(call, callback) {
        call.on('data', (request) => {
            // handle request
        });
        
        call.on('end', () => {
            callback(response);
        });
    }
    
    serverStreamingMethod(call) {
        const request = call.request;
        
        // call N times
        call.write(response);
        
        // call once
        call.end();
    }
    
    bidirectionalStreamingMethod(call) {
        call.on('data', (request) => {
            // handle request
            call.write(response);
        });
        
        call.on('end', () => {
            call.end();
        });
    }
}

const server = new grpc.Server();
server.addService(MyServiceGrpc.MyService.service, new MyServiceImpl());
server.bind('0.0.0.0:1234', grpc.ServerCredentials.createInsecure());
server.start();
```

## Client Usage

```js
const grpc = require('grpc');
const MyServiceGrpc = grpc.load(require.resolve('./MyService.proto'));

const credentials = grpc.credentials.createInsecure();
const client = new MyServiceGrpc.MyService('0.0.0.0:1234', credentials);
const md = new grpc.Metadata();

// unary
client.unaryMethod(request, md, (err, response) => {
    if (err) {
        // handle err
    } else {
        // handle response
    }
});

// client streaming
{
    const call = client.clientStreamingMethod(md, (err, response) => {
        if (err) {
            // handle err
        } else {
            // handle response
        }
    });
    
    // call N times
    call.write(request);
    
    // call once
    call.end();
}

// server streaming
{
    const call = client.serverStreamingMethod(request, md);
    
    call.on('data', (response) => {
        // handle response
    });
    
    call.on('end', () => {
        // handle end of server
    });
}

// bidirectional streaming
{
    const call = client.bidirectionalStreamingMethod(md);
    
    call.on('data', (response) => {
        // handle response
    });
    
    call.on('end', () => {
        // handle end of server
    });
    
    // call N times
    call.write(request);
    
    // call once
    call.end();
}
```

## Other Points of Reference

**Code in grpc/grpc-node**

Source code is always a great point of reference.
gRPC has several good integration tests where you can see some of these approaches being used.

* [https://github.com/grpc/grpc-node/blob/master/test/interop/interop_server.js](https://github.com/grpc/grpc-node/blob/master/test/interop/interop_server.js)
* [https://github.com/grpc/grpc-node/blob/master/test/interop/interop_client.js](https://github.com/grpc/grpc-node/blob/master/test/interop/interop_client.js)
* [https://github.com/grpc/grpc-node/blob/master/test/performance/benchmark_server.js](https://github.com/grpc/grpc-node/blob/master/test/performance/benchmark_server.js)
* [https://github.com/grpc/grpc-node/blob/master/test/performance/benchmark_client.js](https://github.com/grpc/grpc-node/blob/master/test/performance/benchmark_client.js)
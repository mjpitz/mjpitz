---
title: "Show us Your Setup!"
description: ""
pubDate: "October 19 2020"
heroImage: '/img/blog-placeholder-4.jpg'

slug: 2020/10/19/show-us-your-setup
tags:
  - software development
  - work from home

---


Indeed had an internal blog series called "Show us Your Setup."
It was a great way to get an idea of others workspaces, the equipment they use, and software they run.
Recently, I had noticed a few folks doing a walk through of their equipment.
In this post, I will show and walk through my setup.
I'll discuss the things I like, and the things I don't.

<!--more-->

### Desktop hardware

![desktop](/img/2020-10-19-desktop.jpeg)

My desk is an [Autonomous SmartDesk2].
Early in my career, I hopped on the standing desk kick and loved it.
This desk has been the best one yet.
With 4 programmable settings, I'm able to choose between a height that works for the day.
If you enjoy standing and are looking for a high quality desk, take a look at this one.
Since I stand often, I also have an [anti-fatigue floor mat].
This helps reduce stress and pain on joints when I'm standing.

The thing I like about my setup is that it's hot-swappable.
I attach everything through a single [Anker USB C Hub].
At the end of the week, I can unplug my work laptop, and connect my personal one.
I don't need to reconfigure anything.
Just plug and play.

This is only possible because of my [Dell P2418D] monitor.
It provides additional USB ports that I'm able to connect my peripherals to.
Specifically, my [Blue snowball] microphone and [Logitech c920s] webcam.
I've been told on some occasions that the snowball mic is too quiet.
It's rather sensitive to the direction that you're speaking.
So make sure it's well positioned.

While I only got the webcam today, I've been a long time user of Logitech.
In college, I built web-based video software for [NTID] at [RIT].
We had tons of webcams from different vendors.
The best one we used by far was a Logitech 9xx model.
So when I started to look around, I naturally gravitated toward them.
After some exhaustive searching, I picked up the last webcam available in the North-west Austin area.
At least it feels that way.

Currently, I mount my monitor using an [AmazonBasics arm mount].
At first, I was excited to use it.
Over time, it hasn't held up well and is starting to show some strain.
I've been looking for a new one, but it's tempting to unmount and go back to the stand.

To keep my laptop level with the screen, it rests on a [Nuxaly laptop stand].
This gives it a few inches underneath allowing for better circulation when things get hot and heavy.
Since it's raised, I needed a mouse and keyboard.
Luckily I had a few around.
My keyboard is a 2013 [Razer BlackWidow Tournament Edition].
While it's not back-lit like the linked chroma edition, the model I link is more or less the same.
I used an Apple TrackPad for a little while, and finally broke down for a more responsive mouse.
I wound up buying the [Razer Basilisk X HyperSpeed] mouse.
The mouse can be connected wirelessly or using bluetooth.
It has a handful of programmable buttons and is comfortable ot hold in your hand.
While I was skeptical about a gaming mouse pad at first, I've come to enjoy the [Razer Goliathus Mobile Stealth].
It's thin and lightweight making it easy to travel with, when that's a thing again.
The thing that caught my eye about the mouse pad is the anti-fray aspect.
Many of my previous mouse pads wore down and frayed at the edge making them difficult to use.

Finally, I connect a pair of [Cowin E7 active noise cancelling headphones].
At a $60 price point, it's hard to argue with these.
You get great sound for a pretty reasonable price.

[Autonomous SmartDesk2]: https://www.autonomous.ai/standing-desks/smartdesk-2-home

[Anker USB C Hub]: https://www.amazon.com/gp/product/B07YZ48HCT
[Nuxaly laptop stand]: https://www.amazon.com/gp/product/B07P54RSPY
[anti-fatigue floor mat]: https://www.amazon.com/gp/product/B073BQKHPR

[AmazonBasics arm mount]: https://www.amazon.com/gp/product/B079YQQDT2
[Dell P2418D]: https://www.amazon.com/Dell-P2418D-23-8-16-Monitor/dp/B074MMR1V3 

[Razer BlackWidow Tournament Edition]: https://www.razer.com/gaming-keyboards/Razer-BlackWidow-Tournament-Edition-Chroma-V2/RZ03-02190700-R3M1
[Razer Basilisk X HyperSpeed]: https://www.razer.com/gaming-mice/Razer-Basilisk-X-HyperSpeed/RZ01-03150100-R3U1
[Razer Goliathus Mobile Stealth]: https://www.razer.com/gaming-mouse-mats/Razer-Goliathus-Mobile-Stealth-Edition/RZ02-01820500-R3M1

[Blue snowball]: https://www.bluemic.com/en-us/products/snowball/
[Logitech c920s]: https://www.logitech.com/en-us/products/webcams/c920s-pro-hd-webcam.960-001257.html
[Cowin E7 active noise cancelling headphones]: https://www.cowinaudio.com/collections/active-noise-cancelling-headphones/products/cowin-e7-noise-cancelling-headphone?variant=8261760221235

[NTID]: https://www.rit.edu/ntid/
[RIT]: https://www.rit.edu

### Cluster hardware

![clusters](/img/2020-10-19-clusters.jpeg)

While independent of my desk, I consider my cluster(s) part of my setup.
I have full access to them and am able to send work to them when I need to.
Because of their specifications, I largely leverage them for parallel processing.
As shown, I have 3 racks each with the same specifications.
I give each rack a `/29` to allow for growth.
Each rack contains the following hardware:

- 1x [Raspberry Pi 4 (4GB model)]
- 4x [Raspberry Pi 3b+]
- [GeauxRobot 5-Layer DogBone Rack]
- [Anker 60W power supply]
- Heat sinks

I've talked more in depth about how I set up the cluster in previous posts.
But the gist is that each rack acts as an "availability zone".
This helps give me control over the placement of my workloads as well as test out features.

[Raspberry Pi 4 (4GB model)]: https://shop.pimoroni.com/products/raspberry-pi-4?variant=29157087445075
[Raspberry Pi 3b+]: https://shop.pimoroni.com/products/raspberry-pi-3-b-plus
[GeauxRobot 5-Layer DogBone Rack]: https://www.amazon.com/GeauxRobot-Raspberry-Model-5-layer-Enclosure/dp/B01D90TX1O
[Anker 60W power supply]: https://www.amazon.com/Anker-Charger-PowerPort-iPhone-Galaxy/dp/B00P936188

## Software

I primarily use [IntelliJ IDEA] for active development.
While I mostly write in Golang, I've been a long time subscriber to IntelliJ.
While there are other language specific versions from IntelliJ, their architecture allows you to cross-install plugins.
The things I like most about IntelliJ is their code intelligence.
When implementing a feature, I can click through to function implementations, go to definitions, show inheritance, you name it.

If I need to modify something quickly, I'll use a simpler piece of software like [VSCode].
While not as feature rich as IntelliJ, it does provide enough for me to get familiar with a project or investigate an issue.
There are a lot of times I'm working in VSCode where I wish I had some more powerful capabilities.

Since I spend a lot of time working on Kubernetes and surrounding tooling, I'll often run a cluster locally.
I often do this one of two ways: using [minikube] with the docker driver or [kind].
Both approaches will spin up a cluster in my well sized [Docker4Mac] instance.
While the full feature set of kubernetes isn't available, I have enough to work with locally.

[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[VSCode]: https://code.visualstudio.com/
[minikube]: https://minikube.sigs.k8s.io/docs/
[kind]: https://kind.sigs.k8s.io/
[Docker4Mac]: https://docs.docker.com/docker-for-mac/

Anyway, I hope y'all enjoyed a quick peak at my setup.
Feel free to reach out if you have any questions.
Cheers!

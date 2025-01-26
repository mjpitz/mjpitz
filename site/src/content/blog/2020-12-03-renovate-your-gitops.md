---
title: "Renovate your GitOps"
pubDate: "December 3 2020"
description: |
  Recently, I noticed Renovate submit pull requests for dependencies in my Helm v3 charts.
  This gave me an idea.
  What if Renovate could automatically manage something like a GitOps repository?
  This means organizations would no longer need to tediously query for newer versions of applications.
  Instead, they'd automatically receive a pull request when an update becomes available.
  In this blog post, I demonstrate how to set this up for an ArgoCD GitOps repository.

slug: 2020/12/03/renovate-your-gitops
tags:
  - software development

---

Every engineering organization struggles to stay up to date with the latest versions of applications they run.
When an organization deploys an open source project, their versions start to drift from day one.
The longer a project runs without an update, the more likely it is to contain a vulnerability.
To help applications stay on top of library versions, the project [Renovate][] was developed.
Renovate works by parsing manifest files (like `package.json` and `go.mod`) and checking for newer versions of libraries.
When Renovate discovers an update, it submits a pull request with the newer version to the project.

Recently, I noticed Renovate submit pull requests for dependencies in my [Helm][] v3 charts.
This gave me an idea.
What if Renovate could automatically manage something like a GitOps repository?
This means organizations would no longer need to tediously query for newer versions of applications.
Instead, they'd automatically receive a pull request when an update becomes available.
In this blog post, I demonstrate how to set this up for an [ArgoCD][] GitOps repository.

[Renovate]: https://github.com/renovatebot/
[Helm]: https://helm.sh/
[ArgoCD]: https://github.com/argoproj/argo-cd/

<!--more-->

## What is GitOps?

[GitOps][] is the process of managing infrastructure using `git` and pull requests.
It enables developers to manage their infrastructure and applications with a declarative source of truth.
Because workloads must be declared, it provides transparency around what versions of applications are running.

Recently, GitOps has become more popular within the [Kubernetes][] community.
We've seen new tooling like FluxCD, ArgoCD, and GitOps toolkit.
While it has solved many problems for organizations, it's also led to some challenges.
As our ability to deploy and manage software has become easier, we've also increased the number of things we need to manage.
Staying on top of all the recent versions of these systems can sometimes feel like a full time job.  

[GitOps]: https://www.weave.works/blog/what-is-gitops-really
[Kubernetes]: https://kubernetes.io

## Why ArgoCD?

ArgoCD is an incubating project in the [Cloud Native Computing Foundation][] (CNCF).
It enables declarative delivery of workloads to Kubernetes through GitOps.
One of the nice things about ArgoCDs [Application][] model is that it lets you point at Helm charts stored in git.
This is convenient because Renovate can identify these charts and manage the versions of dependencies within them.

As a result, we have an automated cycle that self-manages.
ArgoCD will roll out any changes whenever someone merges something into your default branch (`HEAD`).
Renovate will periodically open pull requests with newer versions of dependent applications as they become available.
Once an engineer merges that pull request, the changes propagate out via ArgoCD.

[Cloud Native Computing Foundation]: https://www.cncf.io/
[Application]: https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#applications

## Here we go! 

Before setting up a project, here are a few things you'll need:

* Some version control system (VCS) like GitHub, GitLab, and BitBucket.
  I'm using GitHub, but you can download a zip and pull it into your VCS of choice.
  For simplicity, this repository should be public.
  This makes the ArgoCD side of the world a bit easier.
* A **personal access token** to your VCS for Renovate to use.
* [Docker][] - A popular container runtime.
* [kind][] - We will be spinning up a cluster in docker for this demonstration.
* Helm v3 - Used to perform the initial deployment of ArgoCD.

[Docker]: https://www.docker.com/
[kind]: https://kind.sigs.k8s.io/

To help reduce the setup, I created a template on GitHub.
You can either fork the template, or use it to create your own project and follow along.

https://github.com/mjpitz/auto-gitops-demo

With your newly created project, you'll need to replace references to the source.
You can find these references by executing `git grep` within the project root.

```bash
## replace with your project
git clone https://github.com/mjpitz/renovate-gitops.git 
cd renovate-gitops

git grep "mjpitz/renovate-gitops" | grep -v README.md
```

**Note:** If you're not using GitHub, you'll need to change your platform in Renovate's configuration.

Once replaced, be sure to commit and push your changes.
ArgoCD deploys code from the remote repository, not from your local copy.

```bash
git commit -a -m "replace references"
git push
```

Next, we'll deploy a local kind cluster.

```bash
kind create cluster --name demo
kubectl config use-context kind-demo
```

At this point, you'll want to give kind a minute or two to initialize.
Kind runs the control plane components inside the cluster, so it takes a minute for things to come up.
You can watch the pods come up in the `kube-system` namespace.
Once initialized, we can deploy ArgoCD.

```bash
kubectl apply -f namespaces/argocd.yaml
helm dependency update workloads/argocd/
helm upgrade -i argocd ./workloads/argocd/ -n argocd
kubectl rollout status -n argocd deployment/argocd-server -w
```

The last command above will hang until the `argocd-server` has successfully been deployed.
Once released, you can try logging into ArgoCD using `admin` for the username and `password` for the password.
To do this, you'll need to forward the port for the service before opening `localhost:8080` in the browser.

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:80
```

Next, we're going to create a root ArgoCD Application named `applications`.
This is used to bootstrap all the other applications running in the cluster.
In the end, there should be a total of 5 applications (`applications`, `argocd`, `cert-manager`, `namespaces`, `renovate`).

```bash
kubectl apply -f applications.yaml

watch kubectl get applications -A
```

Once all five applications are there, you should be able to watch the pods come up.
You can do this either in the ArgoCD UI (from earlier) or by getting pods for all namespaces.

In order for Renovate to run, it needs a secret.
The secret should contain any sensitive configuration for renovate.
For GitHub or GitLab, you just need to provide an access token (`RENOVATE_TOKEN`).
For BitBucket, you will also need to include a username (`RENOVATE_USERNAME`).

```bash
kubectl create secret generic \
    -n renovate renovate-secrets \
    --from-literal RENOVATE_TOKEN=access_token 
```

Now, we just need to kick off a job for Renovate.

```bash
kubectl create job -n renovate --from cronjob/renovate renovate-$(date +%s)
```

When the job completes, you should wind up with a few pull requests.
You can see some examples under the [pull requests](https://github.com/mjpitz/auto-gitops-demo/pulls) tab.

![screenshot](/img/2020-12-03-renovate-gitops.png)

Once we merge one of these pull requests, ArgoCD will kick off a deployment.
It might take a minute or two for ArgoCD to realize there are changes.
If time is of the essence, you can always go into the UI and force refresh the application.
In production deployments, you might consider configuring a hook that runs a sync in your CI job.

## Conclusion

Together, these technologies reduce the burden of running software yourself.
It can free up time for your developers, allowing them to focus on valuable work for your company.
With proper testing, you can configure Renovate to automatically merge changes if they pass your checks.

I've been using this configuration for my projects, and it's been working out great.
I hope others find this as useful as I have.
Enjoy!

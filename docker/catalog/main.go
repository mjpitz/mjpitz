// Copyright (C) 2022 Mya Pitzeruse
// The MIT License (MIT)

package main

import (
	"github.com/mjpitz/emc/catalog"
	"github.com/mjpitz/emc/catalog/grafana"
	"github.com/mjpitz/emc/catalog/linkgroup"
	"github.com/mjpitz/emc/catalog/service"
)

const (
	// Services

	Drone        = "Drone"
	Gitea        = "Gitea"
	Grafana      = "Grafana"
	AlertManager = "AlertManager"
	Prometheus   = "Prometheus"
	Maddy        = "Maddy"
	Registry     = "Registry"

	// Common link groups

	Dashboards    = "Dashboards"
	Documentation = "Documentation"

	// Common links

	Golang     = "Golang"
	Litestream = "Litestream"
	Redis      = "Redis"
	RedisQueue = "Redis Queue"
)

func main() {
	catalog.Serve(
		catalog.Service(
			Drone,
			service.LogoURL("https://alikhil.github.io/images/posts/drone-logo.png"),
			service.URL("https://deploy.pitz.tech"),
			service.Description("Drone is a self-service Continuous Integration platform for busy development teams."),
			service.LinkGroup(
				Dashboards,
				linkgroup.Link(Drone, grafana.Drone("cicd", "drone")),
				linkgroup.Link(Golang, grafana.Golang("cicd", "drone")),
				linkgroup.Link(Litestream, grafana.Litestream("cicd", "drone")),
				linkgroup.Link(RedisQueue, grafana.Redis("cicd", "drone-redis-queue")),
			),
			service.LinkGroup(
				Documentation,
				linkgroup.Link("docs.drone.io", "https://docs.drone.io/"),
			),
		),
		catalog.Service(
			Gitea,
			service.LogoURL("https://th.bing.com/th/id/OIP.vTBHIhs_ZVwADrlakNWr2gHaHa?pid=ImgDet&rs=1"),
			service.URL("https://code.pitz.tech"),
			service.Description("Gitea is an open-source forge software package for hosting software development version control using Git as well as other collaborative features like bug tracking, wikis and code review."),
			service.LinkGroup(
				Dashboards,
				linkgroup.Link(Gitea, grafana.Gitea("vcs", "gitea")),
				linkgroup.Link(Golang, grafana.Golang("vcs", "gitea")),
				linkgroup.Link(Litestream, grafana.Litestream("vcs", "gitea")),
				linkgroup.Link(Redis, grafana.Redis("vcs", "gitea-redis")),
				linkgroup.Link(RedisQueue, grafana.Redis("vcs", "gitea-redis-queue")),
			),
			service.LinkGroup(
				Documentation,
				linkgroup.Link("docs.gitea.io", "https://docs.gitea.io/"),
			),
		),
		catalog.Service(
			Grafana,
			service.LogoURL("https://logodix.com/logo/1736692.png"),
			service.URL("https://grafana.pitz.tech"),
			service.Description("Query, visualize, alert on, and understand your data no matter where it’s stored. With Grafana you can create, explore and share all of your data through beautiful, flexible dashboards."),
			service.LinkGroup(
				Dashboards,
				linkgroup.Link(Golang, grafana.Golang("monitoring", "kube-prometheus-stack-grafana")),
			),
			service.LinkGroup(
				Documentation,
				linkgroup.Link("grafana.com", "https://grafana.com/docs/"),
			),
		),
		catalog.Service(
			AlertManager,
			service.LogoURL("https://res.cloudinary.com/practicaldev/image/fetch/s--LW4NmNdM--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/g60cdrr4ywgbnm1j7d3u.jpg"),
			service.Description("AlertManager handles alerts sent by client applications such as the prometheus server."),
			service.LinkGroup(
				Dashboards,
				linkgroup.Link(Golang, grafana.Golang("monitoring", "kube-prometheus-stack-alertmanager")),
			),
			service.LinkGroup(
				Documentation,
				linkgroup.Link("prometheus.io", "https://prometheus.io/docs/alerting/latest/overview/"),
			),
		),
		catalog.Service(
			Prometheus,
			service.LogoURL("https://res.cloudinary.com/practicaldev/image/fetch/s--LW4NmNdM--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/g60cdrr4ywgbnm1j7d3u.jpg"),
			service.Description("Prometheus is an open-source systems monitoring and alerting toolkit."),
			service.LinkGroup(
				Dashboards,
				linkgroup.Link(Golang, grafana.Golang("monitoring", "kube-prometheus-stack-prometheus")),
			),
			service.LinkGroup(
				Documentation,
				linkgroup.Link("prometheus.io", "https://prometheus.io/docs/introduction/overview/"),
			),
		),
		catalog.Service(
			Maddy,
			service.Description("Maddy Mail Server implements all functionality required to run a e-mail server. It can send messages via SMTP (works as MTA), accept messages via SMTP (works as MX) and store messages while providing access to them via IMAP."),
			service.LinkGroup(
				Dashboards,
				linkgroup.Link(Maddy, grafana.Maddy("email", "maddy-internal")),
				linkgroup.Link(Golang, grafana.Golang("email", "maddy-internal")),
				linkgroup.Link(Litestream, grafana.Litestream("email", "maddy-internal")),
			),
			service.LinkGroup(
				Documentation,
				linkgroup.Link("maddy.email", "https://maddy.email/"),
			),
		),
		catalog.Service(
			Registry,
			service.LogoURL("https://th.bing.com/th/id/OIP.t7fUu4Fb0-0KGLuz4sM7nwHaHa?pid=ImgDet&rs=1"),
			service.URL("https://img.pitz.tech"),
			service.Description("A registry is a storage and content delivery system, holding named Docker images, available in different tagged versions."),
			service.LinkGroup(
				Dashboards,
				linkgroup.Link(Golang, grafana.Golang("registry", "registry")),
				linkgroup.Link(Redis, grafana.Redis("registry", "registry-redis")),
			),
			service.LinkGroup(
				Documentation,
				linkgroup.Link("docs.docker.com", "https://docs.docker.com/registry/"),
			),
		),
	)
}

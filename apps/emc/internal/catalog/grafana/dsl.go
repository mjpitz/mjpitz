// Copyright (c) 2022 Mya Pitzeruse
// The MIT License (MIT)

package grafana

import (
	"fmt"
	"net/url"
)

// Grafana provides functionality for rendering links to dashboards. This implementation provides some short-hand calls
// that assume the use of my personal dashboards (provided at https://github.com/mjpitz/mjpitz/tree/main/monitoring).
type Grafana string

// Link renders a link to a grafana deployment given a dashboard id, namespace, and job (assumes a kubernetes based
// deployment).
func (g Grafana) Link(dashboard, namespace, job string) string {
	return fmt.Sprintf(
		"%s/d/%s?var-namespace=%s&var-job=%s",
		g, url.PathEscape(dashboard), url.QueryEscape(namespace), url.QueryEscape(job),
	)
}

func (g Grafana) Maddy(namespace, job string) string {
	return g.Link("82a7b6b2c9516ef16c08616edc8a90c1", namespace, job)
}

func (g Grafana) Redis(namespace, job string) string {
	return g.Link("36cf4a03d9f16d8a4221fecbbd2ff5c6", namespace, job)
}

func (g Grafana) Drone(namespace, job string) string {
	return g.Link("2c241b4cea8d493ef632bf33b10d04cf", namespace, job)
}

func (g Grafana) Litestream(namespace, job string) string {
	return g.Link("bf44e72e619451e2c85cda80fe17b28b", namespace, job)
}

func (g Grafana) Golang(namespace, job string) string {
	return g.Link("8cd750f455ca9fc93a465fd9a34993cc", namespace, job)
}

func (g Grafana) Gitea(namespace, job string) string {
	return g.Link("354a485fe64f93ea707a7f6e061ff71b", namespace, job)
}

// default instance

var grafana = Grafana("https://grafana.pitz.tech")

func Link(dashboard, namespace, job string) string {
	return grafana.Link(dashboard, namespace, job)
}

func Maddy(namespace, job string) string {
	return grafana.Maddy(namespace, job)
}

func Redis(namespace, job string) string {
	return grafana.Redis(namespace, job)
}

func Drone(namespace, job string) string {
	return grafana.Drone(namespace, job)
}

func Litestream(namespace, job string) string {
	return grafana.Litestream(namespace, job)
}

func Golang(namespace, job string) string {
	return grafana.Golang(namespace, job)
}

func Gitea(namespace, job string) string {
	return grafana.Gitea(namespace, job)
}

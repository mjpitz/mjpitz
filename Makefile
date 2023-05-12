export PATH := $(shell pwd)/bin:$(PATH)
export SHELL := env PATH=$(PATH) /bin/bash

help:
	@cat Makefile | egrep '^[a-zA-Z]+/[a-zA-Z]+:'

#== DOCKER TARGETS

docker/build:	# build docker images in this repo.
	@cd docker && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make build TARGET={} ; \
	}

#== GRAFANA TARGETS

grafana/deps:	# install jsonnet dependencies for generating dashboards and alerts.
	@cd monitoring && { \
		jb install ; \
	}

grafana/format:	# format grafana dashboards and alerts.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make format TARGET={} ; \
	}

grafana/lint:	# lint the grafana dashboards and alerts.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make lint TARGET={} ; \
	}

grafana/build:	# build the grafana dashboards and alerts.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make build TARGET={} ; \
	}

grafana/sync:	# synchronize the built dashboards and alerts for deployment.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make sync TARGET={} ; \
	}

#== HELM TARGETS

helm/docs:	# generate documentation for helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make docs TARGET={} ; \
	}

helm/lint:	# lint helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make lint TARGET={} ; \
	}

#== SITE TARGETS

site/deps:	# install dependencies needed for the site.
	@bash -c "[[ -e site/themes/anatole ]] || git submodule update --init --recursive"
	@bash -c "[[ -e site/themes/anatole/node_modules ]] || { cd site/themes/anatole; npm install; }"

site/serve:	# generate the website for development.
	@cd site && { \
		hugo serve -D ; \
	}

site/build:	# generate the website for production.
	@cd site && { \
		hugo ; \
		cp public/index.xml public/feed.xml ; \
	}

site/test:	# test the site for errors.
	@cd site && { \
		htmltest ; \
	}

#### old targets

bin: bin.yaml
	@bin-vendor

clean:
	@rm -rf bin/ site/public/ site/resources/_gen/ tmp/

docs: helm/docs

deps: site/deps
serve: site/serve
build: site/build
test: site/test

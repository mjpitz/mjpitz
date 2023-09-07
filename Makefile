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

helm/deps:	# update dependencies for helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make deps TARGET={} ; \
	}

helm/docs:	# generate documentation for helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make docs TARGET={} ; \
	}

helm/lint:	# lint helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make lint TARGET={} ; \
	}

#== HELM TARGETS

infra/helm/deps:	# update dependencies for helm charts.
	@cd infra/helm && { \
		find . -mindepth 1 -maxdepth 2 -name Chart.yaml -exec dirname {} \; | xargs -I{} bash -c 'echo "==> {}"; helm dep up {}' ; \
	}

#== SITE TARGETS

site/deps:	# install dependencies needed for the site.
	@cd site && npm install

site/serve:	# generate the website for development.
	@cd site && npm start

site/build:	# generate the website for production.
	@cd site && npm run build

site/test:	# test the site for errors.
	@cd site && npm run test

#### old targets

bin: bin.yaml
	@bin-vendor

clean:
	@rm -rf site/dist/

docs: helm/docs

deps: site/deps
serve: site/serve
build: site/build
test: site/test

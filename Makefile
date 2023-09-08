help:			# outputs help text for this project.
	@cat Makefile | egrep '^[a-zA-Z]+[/[a-zA-Z]+]*:'

clean:			# clean up artifacts and compiled assets.
	@rm -rf site/dist/

#== CHARTS TARGETS

charts/deps:		# update dependencies for helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make deps TARGET={} ; \
	}

charts/docs:		# generate documentation for helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make docs TARGET={} ; \
	}

charts/lint:		# lint helm charts.
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make lint TARGET={} ; \
	}

#== DOCKER TARGETS

docker/build:		# build docker images in this repo.
	@cd docker && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make build TARGET={} ; \
	}

#== INFRA TARGETS

infra/helm/deps:	# update dependencies for helm charts.
	@cd infra/helm && { \
		find . -mindepth 1 -maxdepth 2 -name Chart.yaml -exec dirname {} \; | xargs -I{} bash -c 'echo "==> {}"; helm dep up {}' ; \
	}

#== MONITORING TARGETS

monitoring/deps:	# install jsonnet dependencies for generating dashboards and alerts.
	@cd monitoring && { \
		jb install ; \
	}

monitoring/format:	# format grafana dashboards and alerts.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make format TARGET={} ; \
	}

monitoring/lint:	# lint the grafana dashboards and alerts.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make lint TARGET={} ; \
	}

monitoring/build:	# build the grafana dashboards and alerts.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make build TARGET={} ; \
	}

monitoring/sync:	# synchronize the built dashboards and alerts for deployment.
	@cd monitoring && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | egrep -v 'common|out|vendor' | \
			xargs -I{} make sync TARGET={} ; \
	}

#== SITE TARGETS

site/deps:		# install dependencies needed for the site.
	@cd site && npm install

site/serve:		# generate the website for development.
	@cd site && npm start

site/build:		# generate the website for production.
	@cd site && npm run build

site/test:		# test the site for errors.
	@cd site && npm run test

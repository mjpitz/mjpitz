export PATH := $(shell pwd)/bin:$(PATH)
export SHELL := env PATH=$(PATH) /bin/bash

clean:
	rm -rf bin/ site/public/ site/resources/_gen/ tmp/

.helm.docs:
	@helm-docs -c charts/${CHART} --dry-run | prettier --parser markdown > charts/${CHART}/README.md

chart-docs:
	@$(MAKE) .helm.docs CHART=auth
	@$(MAKE) .helm.docs CHART=drone
	@$(MAKE) .helm.docs CHART=gitea
	@$(MAKE) .helm.docs CHART=litestream
	@$(MAKE) .helm.docs CHART=maddy
	@$(MAKE) .helm.docs CHART=redis
	@$(MAKE) .helm.docs CHART=redis-queue
	@$(MAKE) .helm.docs CHART=registry
	@$(MAKE) .helm.docs CHART=storj

bin: bin.yaml
	bin-vendor

deps:
	bash -c "[[ -e site/themes/anatole ]] || git submodule update --init --recursive"
	bash -c "[[ -e site/themes/anatole/node_modules ]] || { cd site/themes/anatole; npm install; }"

serve:
	cd site && { hugo serve -D ; }

build:
	cd site && { \
		hugo ; \
		cp public/index.xml public/feed.xml ; \
	}

test:
	htmltest

export PATH := $(shell pwd)/bin:$(PATH)
export SHELL := env PATH=$(PATH) /bin/bash

clean:
	rm -rf bin/ node_modules/ public/ resources/_gen/ tmp/

.helm.docs:
	@helm-docs -c charts/${CHART} --dry-run | prettier --parser markdown > charts/${CHART}/README.md

chart-docs:
	@$(MAKE) .helm.docs CHART=auth
	@$(MAKE) .helm.docs CHART=maddy
	@$(MAKE) .helm.docs CHART=redis
	@$(MAKE) .helm.docs CHART=registry
	@$(MAKE) .helm.docs CHART=storj

bin: bin.yaml
	bin-vendor

deps: build-deps
	git submodule update --init --recursive

build:
	hugo
	cp public/index.xml public/feed.xml

test:
	htmltest
	# htmltest --conf .htmltest.external.yml

export PATH := $(shell pwd)/bin:$(PATH)
export SHELL := env PATH=$(PATH) /bin/bash

clean:
	rm -rf bin/ node_modules/ public/ resources/_gen/ tmp/

chart-docs:
	helm-docs -c charts/auth --dry-run | prettier --parser markdown > charts/auth/README.md
	helm-docs -c charts/redis --dry-run | prettier --parser markdown > charts/redis/README.md
	helm-docs -c charts/registry --dry-run | prettier --parser markdown > charts/registry/README.md

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

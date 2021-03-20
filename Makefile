export PATH := $(shell pwd)/bin:$(PATH)
export SHELL := env PATH=$(PATH) /bin/bash

clean:
	rm -rf bin/ node_modules/ public/ resources/_gen/ tmp/

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

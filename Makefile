export PATH := $(shell pwd)/bin:$(PATH)
export SHELL := env PATH=$(PATH) /bin/bash

docker/build:
	@cd docker && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make build TARGET={} ; \
	}

helm/docs:
	@cd charts && { \
		find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | xargs -I{} make docs TARGET={} ; \
	}

site/deps:
	@bash -c "[[ -e site/themes/anatole ]] || git submodule update --init --recursive"
	@bash -c "[[ -e site/themes/anatole/node_modules ]] || { cd site/themes/anatole; npm install; }"

site/serve:
	@cd site && { \
		hugo serve -D ; \
	}

site/build:
	@cd site && { \
		hugo ; \
		cp public/index.xml public/feed.xml ; \
	}

site/test:
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

clean:
	rm -rf bin/ node_modules/ public/ resources/_gen/ tmp/

build-deps:
	curl https://raw.githubusercontent.com/wjdp/htmltest/master/godownloader.sh | bash

deps: build-deps
	git submodule update --init --recursive
	npm install

build:
	hugo
	cp public/index.xml public/feed.xml

test:
	bin/htmltest
	#bin/htmltest --conf .htmltest.external.yml


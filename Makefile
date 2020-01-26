deps:
	bundle install

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve --incremental

ci:
	bundle install
	bundle exec jekyll build
	bundle exec htmlproofer ./_site --disable-external

deps:
	bundle install

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve --incremental

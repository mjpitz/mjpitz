SKAFFOLD_DEFAULT_REPO ?= ghcr.io/mjpitz

export IMAGE_NAME ?=
export IMAGE_VERSION ?=

export IMAGE_SOURCE = https://github.com/mjpitz/mjpitz/docker/$(IMAGE_NAME)
export IMAGE_LICENSES ?=
export IMAGE_TITLE ?=
export IMAGE_DESCRIPTION ?==

export BASE_OS ?=
export BASE_OS_VERSION ?=

help:
	@echo "no help available"

docker/build:
	docker build ./$(IMAGE_NAME) \
		--build-arg "BASE_OS=$(BASE_OS)" \
		--build-arg "BASE_OS_VERSION=$(BASE_OS_VERSION)" \
		--build-arg "IMAGE_NAME=$(IMAGE_NAME)" \
		--label "org.opencontainers.image.source=$(IMAGE_SOURCE)" \
		--label "org.opencontainers.image.version=$(IMAGE_VERSION)" \
		--label "org.opencontainers.image.licenses=$(IMAGE_LICENSES)" \
		--label "org.opencontainers.image.title=$(IMAGE_TITLE)" \
		--label "org.opencontainers.image.description=$(IMAGE_DESCRIPTION)" \
		--tag $(SKAFFOLD_DEFAULT_REPO)/$(IMAGE_NAME):latest-$(BASE_OS) \
		--tag $(SKAFFOLD_DEFAULT_REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)-$(BASE_OS) \
		--tag $(SKAFFOLD_DEFAULT_REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)-$(BASE_OS)$(BASE_OS_VERSION) \
		--file ./Dockerfile

docker/release:
	docker buildx build ./$(IMAGE_NAME) \
		--platform linux/amd64,linux/arm64 \
		--build-arg "BASE_OS=$(BASE_OS)" \
		--build-arg "BASE_OS_VERSION=$(BASE_OS_VERSION)" \
		--build-arg "IMAGE_NAME=$(IMAGE_NAME)" \
		--label "org.opencontainers.image.source=$(IMAGE_SOURCE)" \
		--label "org.opencontainers.image.version=$(IMAGE_VERSION)" \
		--label "org.opencontainers.image.licenses=$(IMAGE_LICENSES)" \
		--label "org.opencontainers.image.title=$(IMAGE_TITLE)" \
		--tag $(SKAFFOLD_DEFAULT_REPO)/$(IMAGE_NAME):latest-$(BASE_OS) \
		--tag $(SKAFFOLD_DEFAULT_REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)-$(BASE_OS) \
		--tag $(SKAFFOLD_DEFAULT_REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)-$(BASE_OS)$(BASE_OS_VERSION) \
		--file ./Dockerfile \
		--push

docker/base:
	@[[ ! -e $(IMAGE_NAME)/alpine.sh ]] || { $(MAKE) $(TARGET) BASE_OS=alpine BASE_OS_VERSION=3.14; }
	@[[ ! -e $(IMAGE_NAME)/centos.sh ]] || { $(MAKE) $(TARGET) BASE_OS=centos BASE_OS_VERSION=7; }
	@[[ ! -e $(IMAGE_NAME)/ubuntu.sh ]] || { $(MAKE) $(TARGET) BASE_OS=ubuntu BASE_OS_VERSION=20.04; }

build:
	@$(MAKE) docker/base TARGET=docker/build $$( cat $(TARGET)/image.conf | tr $$'\n' ' ' )

release:
	@$(MAKE) docker/base TARGET=docker/release $$( cat $(TARGET)/image.conf | tr $$'\n' ' ' )

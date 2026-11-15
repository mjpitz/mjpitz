#!/usr/bin/env bash
set -euo pipefail

SKAFFOLD_DEFAULT_REPO="${SKAFFOLD_DEFAULT_REPO:-img.pitz.tech/mya}"

set -a
# shellcheck source=/dev/null
source ./image.conf
set +a

IMAGE_SOURCE="https://github.com/mjpitz/mjpitz/docker/${IMAGE_NAME}"

build_variant() {
  local BASE_OS="$1" BASE_OS_VERSION="$2"
  docker build . \
    --build-arg "BASE_OS=${BASE_OS}" \
    --build-arg "BASE_OS_VERSION=${BASE_OS_VERSION}" \
    --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
    --build-arg "IMAGE_VERSION=${IMAGE_VERSION}" \
    --build-arg "SKAFFOLD_DEFAULT_REPO=${SKAFFOLD_DEFAULT_REPO}" \
    --label "org.opencontainers.image.source=${IMAGE_SOURCE}" \
    --label "org.opencontainers.image.version=${IMAGE_VERSION}" \
    --label "org.opencontainers.image.licenses=${IMAGE_LICENSES}" \
    --label "org.opencontainers.image.title=${IMAGE_TITLE}" \
    --label "org.opencontainers.image.description=${IMAGE_DESCRIPTION}" \
    --tag "${SKAFFOLD_DEFAULT_REPO}/${IMAGE_NAME}:latest-${BASE_OS}" \
    --tag "${SKAFFOLD_DEFAULT_REPO}/${IMAGE_NAME}:${IMAGE_VERSION}-${BASE_OS}" \
    --tag "${SKAFFOLD_DEFAULT_REPO}/${IMAGE_NAME}:${IMAGE_VERSION}-${BASE_OS}${BASE_OS_VERSION}" \
    --file ./Dockerfile
}

release_variant() {
  local BASE_OS="$1" BASE_OS_VERSION="$2"
  docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg "BASE_OS=${BASE_OS}" \
    --build-arg "BASE_OS_VERSION=${BASE_OS_VERSION}" \
    --build-arg "IMAGE_NAME=${IMAGE_NAME}" \
    --build-arg "IMAGE_VERSION=${IMAGE_VERSION}" \
    --build-arg "SKAFFOLD_DEFAULT_REPO=${SKAFFOLD_DEFAULT_REPO}" \
    --label "org.opencontainers.image.source=${IMAGE_SOURCE}" \
    --label "org.opencontainers.image.version=${IMAGE_VERSION}" \
    --label "org.opencontainers.image.licenses=${IMAGE_LICENSES}" \
    --label "org.opencontainers.image.title=${IMAGE_TITLE}" \
    --tag "${SKAFFOLD_DEFAULT_REPO}/${IMAGE_NAME}:latest-${BASE_OS}" \
    --tag "${SKAFFOLD_DEFAULT_REPO}/${IMAGE_NAME}:${IMAGE_VERSION}-${BASE_OS}" \
    --tag "${SKAFFOLD_DEFAULT_REPO}/${IMAGE_NAME}:${IMAGE_VERSION}-${BASE_OS}${BASE_OS_VERSION}" \
    --file ./Dockerfile \
    --push
}

COMMAND="${1:-build}"

case "$COMMAND" in
  build)
    [[ ! -e ./alpine.sh ]] || build_variant alpine 3.14
    [[ ! -e ./ubuntu.sh ]] || build_variant ubuntu 20.04
    ;;
  release)
    [[ ! -e ./alpine.sh ]] || release_variant alpine 3.14
    [[ ! -e ./ubuntu.sh ]] || release_variant ubuntu 20.04
    ;;
  *)
    echo "Usage: $0 [build|release]" >&2
    exit 1
    ;;
esac

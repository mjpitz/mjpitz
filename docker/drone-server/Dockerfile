ARG BASE_OS
ARG BASE_OS_VERSION

FROM golang:1.18-${BASE_OS}${BASE_OS_VERSION} AS builder

ARG IMAGE_NAME
WORKDIR /home/${IMAGE_NAME}

ARG BASE_OS
COPY ${BASE_OS}.sh install.sh
RUN sh install.sh && rm install.sh

FROM ${BASE_OS}:${BASE_OS_VERSION}

COPY --from=builder /go/bin /go/bin
COPY docker-entrypoint.sh docker-entrypoint.sh

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]

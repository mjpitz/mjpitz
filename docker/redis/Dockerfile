ARG BASE_OS
ARG BASE_OS_VERSION

FROM ${BASE_OS}:${BASE_OS_VERSION} AS builder

ARG IMAGE_NAME
ARG IMAGE_VERSION
ARG BASE_OS

WORKDIR /home/${IMAGE_NAME}

COPY ${BASE_OS}.sh install.sh
RUN env IMAGE_VERSION=${IMAGE_VERSION} sh install.sh && rm install.sh

FROM ${BASE_OS}:${BASE_OS_VERSION}

ARG IMAGE_NAME

WORKDIR /home/${IMAGE_NAME}

COPY --from=builder /usr/local/bin /redis/bin
COPY docker-entrypoint.sh docker-entrypoint.sh
COPY redis.conf /redis/etc/redis.conf

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]
CMD [ "/redis/etc/redis.conf" ]

ARG BASE_OS
ARG BASE_OS_VERSION
ARG SKAFFOLD_DEFAULT_REPO

FROM ${SKAFFOLD_DEFAULT_REPO}/redis:6.2.7-${BASE_OS}${BASE_OS_VERSION} AS builder

ARG IMAGE_NAME
WORKDIR /home/${IMAGE_NAME}

ARG BASE_OS
COPY ${BASE_OS}.sh install.sh
RUN sh install.sh && rm install.sh

FROM ${BASE_OS}:${BASE_OS_VERSION}

ARG IMAGE_NAME
WORKDIR /home/${IMAGE_NAME}

COPY --from=builder /usr/local/bin /redis/bin
COPY --from=builder /redis/src/redisraft/redisraft.so /redis/modules/redisraft.so

COPY docker-entrypoint.sh docker-entrypoint.sh
COPY redis.conf /redis/etc/redis.conf

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]
CMD [ "/redis/etc/redis.conf" ]

ARG BASE_OS
ARG BASE_OS_VERSION

FROM ${BASE_OS}:${BASE_OS_VERSION}

ARG IMAGE_NAME
ARG IMAGE_VERSION
ARG BASE_OS

WORKDIR /home/${IMAGE_NAME}

COPY ${BASE_OS}.sh install.sh
RUN sh install.sh && rm install.sh

COPY etc /opt/presto/etc
COPY docker-entrypoint.sh docker-entrypoint.sh

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]

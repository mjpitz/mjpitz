ARG BASE_OS
ARG BASE_OS_VERSION

FROM ${BASE_OS}:${BASE_OS_VERSION}

ARG IMAGE_NAME
WORKDIR /home/${IMAGE_NAME}

ARG BASE_OS
COPY ${BASE_OS}.sh install.sh
COPY docker-entrypoint.sh docker-entrypoint.sh

RUN sh install.sh && rm install.sh

ENTRYPOINT [ "sh", "docker-entrypoint.sh" ]

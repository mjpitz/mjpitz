ARG BASE_OS
ARG BASE_OS_VERSION

FROM python:3-${BASE_OS}${BASE_OS_VERSION}

ARG IMAGE_NAME
WORKDIR /home/${IMAGE_NAME}

ARG BASE_OS
COPY ${BASE_OS}.sh install.sh

RUN sh install.sh && rm install.sh

ENTRYPOINT [ "taky" ]

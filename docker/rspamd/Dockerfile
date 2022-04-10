ARG BASE_OS
ARG BASE_OS_VERSION

FROM ${BASE_OS}:${BASE_OS_VERSION}

ARG BASE_OS
COPY ${BASE_OS}.sh install.sh

RUN sh install.sh && rm install.sh

ENTRYPOINT [ "rspamd", "-f" ]

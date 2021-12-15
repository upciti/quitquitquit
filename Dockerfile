ARG DEBIAN_VERSION="bullseye"

FROM wakemeops/debian:${DEBIAN_VERSION}-slim
WORKDIR /shared

RUN install_packages xh && \
    mv /usr/bin/xh .

ADD entrypoint.sh .

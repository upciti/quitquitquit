FROM wakemeops/minideb:latest
WORKDIR /shared

RUN install_packages xh && \
    mv /usr/bin/xh .

ADD entrypoint.sh .

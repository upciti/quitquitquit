ARG DEBIAN_VERSION="buster"

#### Get xh binary
FROM debian:${DEBIAN_VERSION}-slim as builder

ARG XH_VERSION="0.13.0"
ENV XH_VERSION=${XH_VERSION}

RUN apt-get update && \
    apt-get install -y curl tar && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/ducaale/xh/releases/download/v${XH_VERSION}/xh-v${XH_VERSION}-x86_64-unknown-linux-musl.tar.gz | tar xzpf - && \
    mv xh-v${XH_VERSION}-x86_64-unknown-linux-musl/xh /usr/bin/xh


#### Runner
FROM debian:${DEBIAN_VERSION}-slim as runner
WORKDIR /shared
COPY --from=builder /usr/bin/xh .
ADD entrypoint.sh .

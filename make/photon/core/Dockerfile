ARG harbor_base_image_version
ARG harbor_base_namespace

FROM golang:1.20.2 AS builder
WORKDIR /build
RUN git clone --depth 1 --branch v1.20.2 https://github.com/go-delve/delve.git && \
    cd /build/delve/cmd/dlv && \
    go build -o /build/delve/bin/dlv

FROM ${harbor_base_namespace}/harbor-core-base:${harbor_base_image_version}

HEALTHCHECK CMD curl --fail -s http://localhost:8080/api/v2.0/ping || curl -k --fail -s https://localhost:8443/api/v2.0/ping || exit 1
COPY ./make/photon/common/install_cert.sh /harbor/
COPY ./make/photon/core/entrypoint.sh /harbor/
COPY ./make/photon/core/harbor_core /harbor/
COPY ./src/core/views /harbor/views
COPY ./make/migrations /harbor/migrations
COPY ./icons /harbor/icons

RUN chown -R harbor:harbor /etc/pki/tls/certs \
    && chown -R harbor:harbor /harbor/ \
    && chmod u+x /harbor/entrypoint.sh \
    && chmod u+x /harbor/install_cert.sh \
    && chmod u+x /harbor/harbor_core

COPY --from=builder /build/delve/bin/dlv /usr/local/bin/dlv

ENV GO_VERSION 1.20.2
RUN tdnf install -y tar gzip
RUN curl -fsSL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o go.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

WORKDIR /harbor/
USER harbor
ENTRYPOINT ["/harbor/entrypoint.sh"]
COPY make/photon/prepare/versions /harbor/

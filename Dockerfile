FROM alpine:3.23

ARG TARGETARCH
ARG TARGETVARIANT

RUN apk add --no-cache ca-certificates mailcap

# Map Docker architecture variables to artifact naming convention
ARG ARTIFACT_ARCH
RUN if [ -z "$ARTIFACT_ARCH" ]; then \
    case "${TARGETARCH}${TARGETVARIANT}" in \
        "amd64") export ARTIFACT_ARCH="amd64" ;; \
        "arm64") export ARTIFACT_ARCH="arm64" ;; \
        "armv7") export ARTIFACT_ARCH="armv7" ;; \
        "armv6") export ARTIFACT_ARCH="armv6" ;; \
        "386") export ARTIFACT_ARCH="386" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}${TARGETVARIANT}" && exit 1 ;; \
    esac; \
    echo "ARTIFACT_ARCH=$ARTIFACT_ARCH" >> /etc/environment; \
fi
# Copy the pre-built binary based on mapped architecture
COPY artifacts/caddy-linux-${ARTIFACT_ARCH}/caddy-linux-${ARTIFACT_ARCH} /usr/bin/caddy
RUN chmod +x /usr/bin/caddy

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

VOLUME /data
VOLUME /config

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
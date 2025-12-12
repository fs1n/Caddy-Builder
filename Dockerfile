FROM alpine:latest

ARG TARGETARCH
ARG TARGETVARIANT

RUN apk add --no-cache ca-certificates mailcap

# Copy the pre-built binary based on architecture
COPY --chmod=755 artifacts/caddy-linux-${TARGETARCH}${TARGETVARIANT}/caddy-linux-${TARGETARCH}${TARGETVARIANT} /usr/bin/caddy

EXPOSE 80 443 2019

VOLUME /data
VOLUME /config

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
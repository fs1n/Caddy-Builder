FROM alpine:3.23

ARG TARGETARCH
ARG TARGETVARIANT

RUN apk add --no-cache ca-certificates mailcap

# Copy the pre-built binary based on architecture.
# Docker buildx passes TARGETARCH and TARGETVARIANT separately:
# - amd64/arm64/386: TARGETARCH=amd64|arm64|386, TARGETVARIANT=""
# - arm/v7: TARGETARCH=arm, TARGETVARIANT=v7 -> becomes "arm-v7"
# - arm/v6: TARGETARCH=arm, TARGETVARIANT=v6 -> becomes "arm-v6"
# Build naming convention matches this exactly: caddy-linux-{TARGETARCH}-{TARGETVARIANT}
# (with dash separator for variant, e.g., caddy-linux-arm-v7, not armv7)
COPY --chmod=755 artifacts/caddy-linux-${TARGETARCH}${TARGETVARIANT:+-$TARGETVARIANT}/caddy-linux-${TARGETARCH}${TARGETVARIANT:+-$TARGETVARIANT} /usr/bin/caddy

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

VOLUME /data
VOLUME /config

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
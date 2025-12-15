ARG CADDY_VERSION=latest
FROM caddy:${CADDY_VERSION}

ARG TARGETARCH
ARG TARGETVARIANT

# Replace the caddy binary with our custom-built version with additional plugins
COPY --chmod=755 artifacts/caddy-linux-${TARGETARCH}${TARGETVARIANT}/caddy-linux-${TARGETARCH}${TARGETVARIANT} /usr/bin/caddy
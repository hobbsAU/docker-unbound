FROM alpine:3.17

ENV     PACKAGES "unbound curl openssl drill tzdata bash"
ENV     UNBOUND_VERSION "1.17.0"

LABEL   org.opencontainers.image.version=${UNBOUND_VERSION} \
        org.opencontainers.image.title="hobbsau/unbound" \
        org.opencontainers.image.description="Alpine based validating, recursive, and caching DNS resolver" \
        org.opencontainers.image.url="https://github.com/hobbsAU/docker-unbound" \
        org.opencontainers.image.vendor="Adrian Hobbs" \
        org.opencontainers.image.licenses="MIT" \
        org.opencontainers.image.source="https://github.com/hobbsAU/docker-unbound" \
        org.opencontainers.image.authors="Adrian Hobbs <adrianhobbs@gmail.com>"

# Install package using --no-cache to update index and remove unwanted files
RUN     apk --no-cache --update upgrade && \
        apk --no-cache add ${PACKAGES} && \
        cp /usr/share/zoneinfo/UTC /etc/localtime && \
        echo "UTC" > /etc/timezone && \
        curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache && \
        chown root:unbound /etc/unbound && \
        chmod 775 /etc/unbound

EXPOSE 53/udp 53/tcp

COPY docker-entrypoint.sh /docker-entrypoint.sh

#HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 CMD drill @127.0.0.1 cloudflare.com || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/unbound"]


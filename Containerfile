ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG PROMETHEUSVER
ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Prometheus" \
    org.opencontainers.image.description="Systems monitoring and alerting toolkit" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/prometheus" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/prometheus" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U net-mgmt/prometheus${PROMETHEUSVER}; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

WORKDIR /prometheus

RUN mkdir -p /prometheus

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 9090
VOLUME ["/prometheus"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--config.file=/usr/local/etc/prometheus.yml", \
     "--storage.tsdb.path=/prometheus"]

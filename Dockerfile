FROM arm32v6/alpine:3.11.5
# Updated here: https://hub.docker.com/r/arm32v6/alpine/tags
# Inspired from: https://github.com/prometheus/pushgateway/blob/master/Dockerfile

ARG VERSION
ENV PUSH_GW_VERSION=${VERSION}

RUN apk add bash coreutils \
    && mkdir /app \
    && cd /app \
    && wget https://github.com/prometheus/pushgateway/releases/download/v${VERSION}/pushgateway-${VERSION}.linux-armv6.tar.gz \
    && tar xzf pushgateway-${VERSION}.linux-armv6.tar.gz \
    && cp pushgateway-${VERSION}.linux-armv6/pushgateway /bin/ \
    && rm -rf /app

EXPOSE 9091
USER nobody
COPY run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]


ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Prometheus Push Gateway (arm32v6)" \
      org.label-schema.description="Prometheus Push Gateway- Repackaged for ARM32v6" \
      org.label-schema.url="https://prometheus.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/alexswilliams/arm32-v6-prometheus-push-gateway-docker" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

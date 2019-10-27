FROM arm32v6/alpine:3.10.3

ARG VERSION
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

RUN mkdir /app && cd /app \
    && wget https://github.com/prometheus/pushgateway/releases/download/v${VERSION}/pushgateway-${VERSION}.linux-armv6.tar.gz \
    && tar xzf pushgateway-${VERSION}.linux-armv6.tar.gz \
    && cp pushgateway-${VERSION}.linux-armv6/pushgateway /bin/ \
    && rm -rf /app \
    && mkdir /pushgateway

COPY run.sh /run.sh
ENV PUSH_GW_VERSION=${VERSION}

EXPOSE 9091
ENTRYPOINT [ "sh", "/run.sh" ]

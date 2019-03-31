#!/bin/sh

echo "Starting Prometheus Push Gateway $PUSH_GW_VERSION"
echo "Relevant Environment Variables (PUSH_GW_*):"
env | grep PUSH_GW | sort

/bin/pushgateway \
    --web.listen-address=${PUSH_GW_WEB_LISTEN_ADDRESS:-:9091}
    --web.telemetry-path=${PUSH_GW_WEB_TELEMETRY_PATH:-/metrics}
    --web.route-prefix=${PUSH_GW_WEB_ROUTE_PREFIX:-""}
    --persistence.file=${PUSH_GW_PERSISTENCE_FILE:-""}
    --persistence.interval=${PUSH_GW_PERSISTENCE_INTERVAL:-5m}
    --log.level=${PUSH_GW_LOG_LEVEL:-info}
    --log.format=${PUSH_GW_LOG_FORMAT:-logger:stderr}
    $@


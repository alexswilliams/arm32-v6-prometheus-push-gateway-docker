#!/bin/bash

echo "Starting Prometheus Push Gateway $PUSH_GW_VERSION"
echo "Relevant Environment Variables (PUSH_GW_*):"
env | grep PUSH_GW | sort
echo ""


# Flags updated here: https://github.com/prometheus/pushgateway/blob/master/main.go
# Logger flags updated here: https://github.com/prometheus/common/blob/master/promlog/flag/flag.go


# Booleans are treated specially in kingpin so they need passing in differently.
declare -a booleans=(
    web.enable-lifecycle
    web.enable-admin-api
    push.disable-consistency-check
)
declare -a flags=(
    web.listen-address
    web.telemetry-path
    web.external-url
    web.route-prefix
    persistence.file
    persistence.interval
    log.format
    log.level
)

# Defaults taken from original prometheus Dockerfile
declare -a command=(
    "/bin/pushgateway"
)

for flag in "${booleans[@]}"; do
    envVarName="PUSH_GW_$(echo "${flag}" | tr 'a-z-.' 'A-Z__')"
    lowerVarValue="$(echo "${!envVarName}" | tr 'A-Z' 'a-z')"
    if [ ! -z "${lowerVarValue}" ]; then
        if [ "${lowerVarValue}" == "true" ]; then command+=("--${flag}"); else command+=("--no-${flag}"); fi
    fi
done
for flag in "${flags[@]}"; do
    envVarName="PUSH_GW_$(echo "${flag}" | tr 'a-z-.' 'A-Z__')"
    if [ ! -z "${!envVarName}" ]; then
        command+=("--${flag}=${!envVarName}")
    fi
done

unset envVarName lowerVarValue flag booleans flags
set -ex

exec "${command[@]}" $@

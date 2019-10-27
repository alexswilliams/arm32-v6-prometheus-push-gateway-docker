#!/usr/bin/env bash

set -ex

function buildAndPush {
    local version=$1
    local imagename="alexswilliams/arm32v6-prometheus-push-gateway"
    local fromline=$(grep -e '^FROM ' Dockerfile | tail -n -1 | sed 's/^FROM[ \t]*//' | sed 's#.*/##' | sed 's/:/-/' | sed 's/#.*//' | sed -E 's/ +.*//')

    docker build -t ${imagename}:${version} \
        --build-arg VERSION=${version} \
        --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        --build-arg VCS_REF=$(git rev-parse --short HEAD) \
        --file Dockerfile . \
    && docker tag ${imagename}:${version} ${imagename}:${version}-${fromline} \
    && docker push ${imagename}:${version} \
    && docker push ${imagename}:${version}-${fromline} \
    && (
        if [ "$2" == "latest" ]; then
            docker tag ${imagename}:${version} ${imagename}:latest \
            && docker push ${imagename}:latest
        fi
    )
}

# buildAndPush "0.7.0"
# buildAndPush "0.8.0"
# buildAndPush "0.9.0"
# buildAndPush "0.9.1"
buildAndPush "0.10.0"
buildAndPush "1.0.0" latest

curl -X POST "https://hooks.microbadger.com/images/alexswilliams/arm32v6-prometheus-push-gateway/Xrunc81LwVPUfwFs_wAMFS9kffQ="

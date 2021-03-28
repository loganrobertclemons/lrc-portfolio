#!/bin/bash

istioctl manifest generate --set unvalidatedValues.global.mtls.enabled=true \
    --set unvalidatedValues.security.selfSigned=true \
    --set values.global.proxy.resources.limits.cpu=250m \
    --set values.global.proxy.resources.limits.memory=256Mi \
    --set unvalidatedValues.gateways.istio-ingressgateway.enabled=true \
> ./istio-manifest.yaml

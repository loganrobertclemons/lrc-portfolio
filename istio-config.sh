#!/bin/bash

kubectl label namespace istio-system istio-injection=enabled

istioctl manifest generate -- set values.global.mtls.enabled=false \
    --set values.kiali.enabled=false \
    --set values.tracing.enabled=false \
    --set values.tracing.provider=zipkin \
    --set values.global.controlPlaneSecurityEnabled=true \
    --set values.istiocoredns.enabled=true \
    --set values.global.proxy.resources.limits.cpu=250m \
    --set values.global.proxy.resources.limits.memory=256Mi \
    --set values.gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/aws-load-balancer-internal"="0\.0\.0\.0/0" \

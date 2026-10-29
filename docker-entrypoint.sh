#!/bin/sh
set -eu

# Runtime credentials belong outside the image and persistent TSDB volume.
: "${PROMETHEUS_WEB_PASSWORD:?PROMETHEUS_WEB_PASSWORD is required}"
: "${PROMETHEUS_WEB_PASSWORD_HASH:?PROMETHEUS_WEB_PASSWORD_HASH is required}"
: "${FREEDESIGN_METRICS_TOKEN:?FREEDESIGN_METRICS_TOKEN is required}"
umask 077
mkdir -p /run/prometheus-secrets
printf '%s' "$PROMETHEUS_WEB_PASSWORD" > /run/prometheus-secrets/web-password
printf 'basic_auth_users:\n  metrics: %s\n' "$PROMETHEUS_WEB_PASSWORD_HASH" > /run/prometheus-secrets/web.yml
printf '%s' "$FREEDESIGN_METRICS_TOKEN" > /run/prometheus-secrets/freedesign-token
unset PROMETHEUS_WEB_PASSWORD PROMETHEUS_WEB_PASSWORD_HASH FREEDESIGN_METRICS_TOKEN

exec /bin/prometheus --web.config.file=/run/prometheus-secrets/web.yml "$@"

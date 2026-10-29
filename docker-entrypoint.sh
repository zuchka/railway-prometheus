#!/bin/sh
set -eu

# Runtime credentials belong outside the image and persistent TSDB volume.
: "${PROMETHEUS_WEB_PASSWORD:?PROMETHEUS_WEB_PASSWORD is required}"
: "${PROMETHEUS_WEB_PASSWORD_HASH:?PROMETHEUS_WEB_PASSWORD_HASH is required}"
umask 077
mkdir -p /run/prometheus-secrets
printf '%s' "$PROMETHEUS_WEB_PASSWORD" > /run/prometheus-secrets/web-password
printf 'basic_auth_users:\n  metrics: %s\n' "$PROMETHEUS_WEB_PASSWORD_HASH" > /run/prometheus-secrets/web.yml
unset PROMETHEUS_WEB_PASSWORD PROMETHEUS_WEB_PASSWORD_HASH

exec /bin/prometheus --web.config.file=/run/prometheus-secrets/web.yml "$@"

---
title: Prometheus
description: A minimal example of the Prometheus timeseries database
tags:
  - prometheus
  - observability
---

# Prometheus Example

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/KmJatA?referralCode=9kQOPq)

Deploy Prometheus on Railway with one click. Pre-configured to self-monitor the Prometheus service and [a well-known demo-application](https://node.demo.prometheus.io/metrics)

## Railway authentication

The web UI and query API require HTTP Basic authentication as user `metrics`.
Set `PROMETHEUS_WEB_PASSWORD` and its matching bcrypt
`PROMETHEUS_WEB_PASSWORD_HASH` in Railway service variables. Do not commit
credentials. Railway terminates public HTTPS; Prometheus listens on port 9090.
The startup script writes private runtime files under `/run/prometheus-secrets`
and removes credentials from the server process environment. Self-monitoring
uses the same login through a password file.

Validate configuration changes with `sh -n docker-entrypoint.sh` and
`promtool check config --syntax-only prometheus.yml` before deployment.

## Free design.md collection

Set `FREEDESIGN_METRICS_TOKEN` to the app's `PROMETHEUS_METRICS_TOKEN` using
Railway service variables. The token is written to a private runtime file and
sent only to `https://freedesign.md/api/metrics`. The `freedesign` job scrapes
every two minutes with a ten-second timeout and does not follow redirects.

After deployment, check `up{job="freedesign"} == 1` and both
`fdmd_persistent_metrics_available` and `fdmd_billing_metrics_available` equal 1.
Wait for two successful scrapes before retiring the old collector. This starts
new collection only; historical DigitalOcean data is not imported.

This service and free design.md run in separate Railway projects, so the
scrape uses public HTTPS. Moving the collector into the application's project
would be necessary to use Railway private networking. Data is retained on the
existing `/prometheus` volume.

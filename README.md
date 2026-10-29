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

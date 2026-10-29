---
title: Prometheus
description: A minimal example of the Prometheus timeseries database
tags:
  - prometheus
  - observability
---

# Prometheus Example

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/KmJatA?referralCode=9kQOPq)

Deploy Prometheus on Railway with one click. This reusable template contains no
instance-specific targets, accounts, or required credentials.

## Included examples

| Job | Target | Interval | What it demonstrates |
| --- | --- | --- | --- |
| `prometheus` | `http://localhost:9090/metrics` | 15 seconds | Prometheus process health, memory, and scrape performance |
| `node_demo` | `https://node.demo.prometheus.io/metrics` | 60 seconds | A public Node Exporter demo with CPU, memory, filesystem, and network metrics |

Open the Prometheus query UI after deployment and try:

```promql
# Both included targets should report 1.
up

# Go heap memory used by this Prometheus process, in bytes.
go_memstats_heap_alloc_bytes{job="prometheus"}

# Available memory on the public demo machine, in bytes.
node_memory_MemAvailable_bytes{job="node_demo"}

# CPU utilization on the public demo machine, as a percentage.
100 * (1 - avg(rate(node_cpu_seconds_total{job="node_demo",mode="idle"}[5m])))
```

Allow up to a minute for the first public scrape; rate queries need at least
two samples.

The public demo is a best-effort example, not a production dependency. Its target
status can change independently of your deployment. Replace or remove `node_demo`
when configuring your own monitoring. Public scrapes incur network egress; use
Railway private addresses for your own services in the same project/environment.

## Customize an instance

Create a separate repository for instance-specific targets and authentication;
keep this repository generic because it is the template source. Never commit
scrape tokens, passwords, or credentials. If collecting private metrics, protect
the Prometheus UI/query API as well as the source endpoint.

## Validate

```sh
promtool check config prometheus.yml
```

Then check `/api/v1/targets` and `up` in the running server. HTTP 200 alone is
insufficient: a target must return a supported metrics format and scrape
successfully. The public Node Exporter exposes some legacy metric names that
may generate naming lint warnings; those are distinct from scrape failures.

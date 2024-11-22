# Prometheus

Prometheus is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

prometheus.io

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Prometheus_software_logo.svg/1200px-Prometheus_software_logo.svg.png" alt="prometheus logo" width="30%" height="auto">

## How to use this Makejail

```sh
mkdir -p .volumes/data
appjail makejail \
    -j prometheus \
    -f gh+AppJail-makejails/prometheus \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=9090 \
    -o fstab="$PWD/.volumes/data prometheus-data <volumefs>" \
    -o fstab="/path/to/your/prometheus.yml prometheus-conf <volumefs>"
```

### Arguments (stage: build):

* `prometheus_tag` (default: `13.4`): see [#tags](#tags).

### Volumes

| Name              | Owner | Group | Perm | Type | Mountpoint                    |
| ----------------- | ----- | ----- | ---- | ---- | ----------------------------- |
| prometheus-data   | 478   | 478   |  -   |  -   | /var/db/prometheus            |
| prometheus-conf   | 0     | 0     |  -   |  -   | /usr/local/etc/prometheus.yml |

## Tags

| Tag    | Arch    | Version        | Type   |
| ------ | ------- | -------------- | ------ |
| `13.4` | `amd64` | `13.4-RELEASE` | `thin` |
| `14.1` | `amd64` | `14.1-RELEASE` | `thin` |

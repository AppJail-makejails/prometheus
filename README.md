# Prometheus

Prometheus is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

Prometheus' main distinguishing features as compared to other monitoring systems are:

- a multi-dimensional data model (timeseries defined by metric name and set of key/value dimensions)
- a flexible query language to leverage this dimensionality
- no dependency on distributed storage; single server nodes are autonomous
- timeseries collection happens via a pull model over HTTP
- pushing timeseries is supported via an intermediary gateway
- targets are discovered via service discovery or static configuration
- multiple modes of graphing and dashboarding support
- support for hierarchical and horizontal federation

wikipedia.org/wiki/Prometheus_(software)

<img src="https://github.com/prometheus/prometheus/raw/main/documentation/images/prometheus-logo.svg" width="30%" height="auto" alt="Prometheus logo">

## How to use this Makejail

### Basic usage

Running Prometheus on AppJail is as simple as `appjail oci run -Pd -o overwrite=force -o virtualnet=":<random> default" -o nat -o expose=9090 ghcr.io/appjail-makejails/prometheus prometheus`. This starts Prometheus with a sample configuration and exposes it on port 9090.

### Setting command line parameters

The OCI image is started with a number of default command line parameters, which can be found in the [Containerfile](Containerfile).

If you want to add extra command line parameters to the `appjail oci run` command, you will need to re-add these yourself as they will be overwritten.

### Volumes & nullfs-mount

To provide your own configuration, nullfs-mount your `prometheus.yml` from the host by running:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/path/to/prometheus.yml usr/local/etc/prometheus.yml nullfs ro" \
    ghcr.io/appjail-makejails/prometheus prometheus
```

### Save your Prometheus data

Prometheus data is stored in `/prometheus` dir inside the container, so the data is cleared every time the container is recreated. To save your data, you need to set up persistent storage (or nullfs mounts) for your container.

Run Prometheus container with persistent storage:

```console
$ mkdir -p /var/appjail-volumes/prometheus/data
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/path/to/prometheus.yml usr/local/etc/prometheus.yml nullfs ro" \
    -o fstab="/var/appjail-volumes/prometheus/data /prometheus" \
    ghcr.io/appjail-makejails/prometheus prometheus
```

### Custom image

To avoid managing a file on the host and nullfs-mount it, the configuration can be baked into the image. This works well if the configuration itself is rather static and the same across all environments.

For this, create a new directory with a Prometheus configuration and a `Containerfile` like this:

```dockerfile
FROM ghcr.io/appjail-makejails/prometheus
ADD prometheus.yml /usr/local/etc
```

Now build and run it:

```console
$ buildah build --network=host -t my-prometheus .
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    localhost/my-prometheus prometheus
```

A more advanced option is to render the configuration dynamically on start with some tooling or even have a daemon update it periodically.

### Arguments (stage: build)

* `prometheus_from` (default: `ghcr.io/appjail-makejails/prometheus`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `prometheus_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.
* `UMASK` (default: `0022`): Override default umask setting.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-3a6eb7bbb8-prometheus | `${PUID}` | `${PGID}` | - | - | /prometheus |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1-3
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        PROMETHEUSVER: "3"
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-2
      containerfile: Containerfile
      args:
        PROMETHEUSVER: "2"
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-1
      containerfile: Containerfile
      args:
        PROMETHEUSVER: "1"
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```

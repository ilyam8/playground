# Apache collector

## Overview
Apache is an open-source HTTP server for modern operating systems including UNIX and Windows.

This module will monitor one or more Apache servers, depending on your configuration.

## Metrics

- global: qwqw
- http_upstream_name: qqq
- http_upstream_name: qqq

### global

#### Labels:

No labels.

#### Metrics:

| Metric                       |                            Dimensions                             |     Units     |
|------------------------------|:-----------------------------------------------------------------:|:-------------:|
| client_connections_rate      |                         accepted, dropped                         | connections/s |
| client_connections_count     |                           active, idle                            |  connections  |
| ssl_handshakes_rate          |                        successful, failed                         | handshakes/s  |
| ssl_handshakes_failures_rate | no_common_protocol, no_common_cipher, timeout, peer_rejected_cert |  failures/s   |
| ssl_verification_errors_rate |   no_cert, expired_cert, revoked_cert, hostname_mismatch, other   |   errors/s    |
| ssl_session_reuses_rate      |                            ssl_session                            |   reuses/s    |
| http_requests_rate           |                             requests                              |  requests/s   |
| http_requests_count          |                             requests                              |   requests    |
| uptime                       |                              uptime                               |    seconds    |


### http server zone

Labels

| Label            | Description                                                  |
|------------------|--------------------------------------------------------------|
| http_server_zone | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                                         |       Dimensions        |    Units    |
|------------------------------------------------|:-----------------------:|:-----------:|
| http_server_zone_requests_rate                 |        requests         | requests/s  |
| http_server_zone_responses_per_code_class_rate | 1xx, 2xx, 3xx, 4xx, 5xx | responses/s |
| http_server_zone_traffic_rate                  |     received, sent      |   bytes/s   |
| http_server_zone_requests_processing_count     |       processing        |  requests   |
| http_server_zone_requests_discarded_rate       |        discarded        | requests/s  |

### http location zone

Labels

| Name               | Description                                                  |
|--------------------|--------------------------------------------------------------|
| http_location_zone | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                                           |       Dimensions        |    Units    |
|--------------------------------------------------|:-----------------------:|:-----------:|
| http_location_zone_requests_rate                 |        requests         | requests/s  |
| http_location_zone_responses_per_code_class_rate | 1xx, 2xx, 3xx, 4xx, 5xx | responses/s |
| http_location_zone_traffic_rate                  |     received, sent      |   bytes/s   |
| http_location_zone_requests_discarded_rate       |        discarded        | requests/s  |

### http upstream

Labels

| Name               | Description                                                  |
|--------------------|--------------------------------------------------------------|
| http_upstream_name | this label will monitor one or more Apache servers, depends. |
| http_upstream_zone | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                        | Dimensions |    Units    |
|-------------------------------|:----------:|:-----------:|
| http_upstream_peers_count     |   peers    |    peers    |
| http_upstream_zombies_count   |   zombie   |   servers   |
| http_upstream_keepalive_count | keepalive  | connections |

### http upstream server

Labels

| Name                         | Description                                                  |
|------------------------------|--------------------------------------------------------------|
| http_upstream_name           | this label will monitor one or more Apache servers, depends. |
| http_upstream_zone           | this label will monitor one or more Apache servers, depends. |
| http_upstream_server_address | this label will monitor one or more Apache servers, depends. |
| http_upstream_server_name    | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                                             |                    Dimensions                    |    Units     |
|----------------------------------------------------|:------------------------------------------------:|:------------:|
| http_upstream_server_requests_rate                 |                     requests                     |  requests/s  |
| http_upstream_server_responses_per_code_class_rate |             1xx, 2xx, 3xx, 4xx, 5xx              | responses/s  |
| http_upstream_server_response_time                 |                     response                     | milliseconds |
| http_upstream_server_response_header_time          |                      header                      | milliseconds |
| http_upstream_server_traffic_rate                  |                  received, sent                  |   bytes/s    |
| http_upstream_server_state                         | up, down, draining, unavail, checking, unhealthy |    state     |
| http_upstream_server_connections_count             |                      active                      | connections  |
| http_upstream_server_downtime                      |                     downtime                     |   seconds    |

### http cache

Labels

| Name       | Description                                                  |
|------------|--------------------------------------------------------------|
| http_cache | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric           |       Dimensions        |    Units    |
|------------------|:-----------------------:|:-----------:|
| http_cache_state |       warm, cold        |    state    |
| http_cache_iops  | served, written, bypass | responses/s |
| http_cache_io    | served, written, bypass |   bytes/s   |
| http_cache_size  |          size           |    bytes    |

### stream server zone

Labels

| Name               | Description                                                  |
|--------------------|--------------------------------------------------------------|
| stream_server_zone | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                                          |   Dimensions   |     Units     |
|-------------------------------------------------|:--------------:|:-------------:|
| stream_server_zone_connections_rate             |    accepted    | connections/s |
| stream_server_zone_sessions_per_code_class_rate | 2xx, 4xx, 5xx  |  sessions/s   |
| stream_server_zone_traffic_rate                 | received, sent |    bytes/s    |
| stream_server_zone_connections_processing_count |   processing   |  connections  |
| stream_server_zone_connections_discarded_rate   |   discarded    | connections/s |

### stream upstream

Labels

| Name                 | Description                                                  |
|----------------------|--------------------------------------------------------------|
| stream_upstream_name | this label will monitor one or more Apache servers, depends. |
| stream_upstream_zone | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                        | Dimensions |  Units  |
|-------------------------------|:----------:|:-------:|
| stream_upstream_peers_count   |   peers    |  peers  |
| stream_upstream_zombies_count |   zombie   | servers |

### stream upstream

Labels

| Name                           | Description                                                  |
|--------------------------------|--------------------------------------------------------------|
| stream_upstream_name           | this label will monitor one or more Apache servers, depends. |
| stream_upstream_zone           | this label will monitor one or more Apache servers, depends. |
| stream_upstream_server_address | this label will monitor one or more Apache servers, depends. |
| stream_upstream_server_name    | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                                   |               Dimensions               |     Units     |
|------------------------------------------|:--------------------------------------:|:-------------:|
| stream_upstream_server_connections_rate  |               forwarded                | connections/s |
| stream_upstream_server_traffic_rate      |             received, sent             |    bytes/s    |
| stream_upstream_server_state             | up, down, unavail, checking, unhealthy |     state     |
| stream_upstream_server_downtime          |                downtime                |    seconds    |
| stream_upstream_server_connections_count |                 active                 |  connections  |

### stream upstream

Labels

| Name          | Description                                                  |
|---------------|--------------------------------------------------------------|
| resolver_zone | this label will monitor one or more Apache servers, depends. |

Metrics

| Metric                                             |                                Dimensions                                |     Units     |
|----------------------------------------------------|:------------------------------------------------------------------------:|:-------------:|
| resolver_zone_requests_rate                        |                             name, srv, addr                              |  requests/s   |
| resolver_zone_responses_rate                       | noerror, formerr, servfail, nxdomain, notimp, refused, timedout, unknown |  responses/s  |

## Setup

## Prerequisites

### Enabling your Apache server

- Ensure the [Apache status module](https://httpd.apache.org/docs/2.4/mod/mod_status.html) is enabled and configured for Apache instance.
- Ensure the Apache status module endpoint (default `server-status`) is available from the host containing the Apache integration.


### Configuration

#### File format

This file is in YAML format. Generally the format is:

```yaml
update_every: 1
autodetection_retry: 0
jobs:
  - name: some_name1
  - name: some_name1
```

#### Options

The following options can be defined globally: update_every, autodetection_retry.

<details>
<summary>See all options</summary>

| Name   | Description | Default | Required |
| :-------:| ----------- | :-------: | :--------: |
|update_every|Data collection frequency.|1 |no|
|autodetection_retry|Re-check interval in seconds. Zero means not to schedule re-check.|0 |no|
|url|Server URL.|`http://127.0.0.1/server-status?auto` |yes|
|username|Username for basic HTTP authentication.|- |no|
|password|Password for basic HTTP authentication.|- |no|
|timeout|HTTP request timeout.|1 |no|

</details>

#### Examples

##### Basic

Local and remote servers.
<details>
<summary>Example</summary>

```yaml
jobs:
  - name: local
    url: http://127.0.0.1/server-status?auto

  - name: remote
    url: http://203.0.113.10/server-status?auto
```

</details>

##### Basic HTTP auth

Local server with basic HTTP authentication.
<details>
<summary>Example</summary>

```yaml
jobs:
  - name: local
    url: https://127.0.0.1/server-status?auto
    username: foo
    password: bar
```

</details>

## Troubleshooting

### Debug mode

To troubleshoot issues with the `apache` collector, run the `go.d.plugin` with the debug option enabled. The output
should give you clues as to why the collector isn't working.

- Navigate to the `plugins.d` directory, usually at `/usr/libexec/netdata/plugins.d/`. If that's not the case on
  your system, open `netdata.conf` and look for the `plugins` setting under `[directories]`.

  ```bash
  cd /usr/libexec/netdata/plugins.d/
  ```

- Switch to the `netdata` user.

  ```bash
  sudo -u netdata -s
  ```

- Run the `go.d.plugin` to debug the collector:

  ```bash
  ./go.d.plugin -d -m apache
  ```


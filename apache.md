# Apache collector

## Overview

Apache is an open-source HTTP server for modern operating systems including UNIX and Windows.

This module will monitor one or more Apache servers, depending on your configuration.

## Collected metrics

TBD


### global

Global scope

This scope no labels.

Metrics:

| Metric             |         Dimensions          |    Unit     |
|--------------------|:---------------------------:|:-----------:|
| apache.connections |         connections         | connections |
| apache.conns_async | keepalive, closing, writing | connections |
| apache.workers     |         idle, busy          |   workers   |


## Setup

### Prerequisites

#### Enabling your Apache server

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
<summary>All options</summary>

|         Name         | Description                                                               |                Default                |
|:--------------------:|---------------------------------------------------------------------------|:-------------------------------------:|
|     update_every     | Data collection frequency.                                                |                   1                   |
| autodetection_retry  | Re-check interval in seconds. Zero means not to schedule re-check.        |                   0                   |
|         url          | Server URL.                                                               | `http://127.0.0.1/server-status?auto` |
|       timeout        | HTTP request timeout.                                                     |                   1                   |
|       username       | Username for basic HTTP authentication.                                   |                   -                   |
|       password       | Password for basic HTTP authentication.                                   |                   -                   |
|    proxy_username    | Username for proxy basic HTTP authentication.                             |                   -                   |
|    proxy_password    | Password for proxy basic HTTP authentication.                             |                   -                   |
|        method        | HTTP request method.                                                      |                  GET                  |
|         body         | HTTP request body.                                                        |                   -                   |
|       headers        | HTTP request headers.                                                     |                   -                   |
| not_follow_redirects | Whether to not follow redirects from the server.                          |                  no                   |
|   tls_skip_verify    | Whether to skip verifying server's certificate chain and hostname.        |                  no                   |
|        tls_ca        | Certificate authority that client use when verifying server certificates. |                   -                   |
|       tls_cert       | Client tls certificate.                                                   |                   -                   |
|       tls_key        | Client tls key.                                                           |                   -                   |

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


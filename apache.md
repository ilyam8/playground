# CockroachDB collector

## Overview

[CockroachDB](https://www.cockroachlabs.com/)  is the SQL database for building global, scalable cloud services that
survive disasters.

This collector monitors one or more CockroachDB databases, depending on your configuration.

## Collected metrics

Metrics grouped by *scope*.

The scope defines the instance that the metric belongs to. An instance is uniquely identified by a set of labels.

### global

These metrics refer to the entire monitored application.

This scope has no labels.

Metrics:

| Metric                                           |                                                                              Dimensions                                                                               |     Unit     | Description                                                     |
|--------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:------------:|:----------------------------------------------------------------|
| cockroachdb.process_cpu_time_combined_percentage |                                                                                 used                                                                                  |  percentage  | Combined CPU Time Percentage, Normalized 0-1 by Number of Cores |
| cockroachdb.process_cpu_time_percentage          |                                                                               user, sys                                                                               |  percentage  | CPU Time Percentage                                             |
| cockroachdb.process_cpu_time                     |                                                                               user, sys                                                                               |      ms      | CPU Time                                                        |
| cockroachdb.process_memory                       |                                                                                  rss                                                                                  |     KiB      | Memory Usage                                                    |
| cockroachdb.process_file_descriptors             |                                                                                 open                                                                                  |      fd      | File Descriptors                                                |
| cockroachdb.process_uptime                       |                                                                                uptime                                                                                 |   seconds    | Uptime                                                          |
| cockroachdb.host_disk_bandwidth                  |                                                                              read, write                                                                              |     KiB      | Host Disk Cumulative Bandwidth                                  |
| cockroachdb.host_disk_operations                 |                                                                             reads, writes                                                                             |  operations  | Host Disk Cumulative Operations                                 |
| cockroachdb.host_disk_iops_in_progress           |                                                                              in_progress                                                                              |     iops     | Host Disk Cumulative IOPS In Progress                           |
| cockroachdb.host_network_bandwidth               |                                                                            received, sent                                                                             |   kilobits   | Host Network Cumulative Bandwidth                               |
| cockroachdb.host_network_packets                 |                                                                            received, sent                                                                             |   packets    | Host Network Cumulative Packets                                 |
| cockroachdb.live_nodes                           |                                                                              live_nodes                                                                               |    nodes     | Live Nodes in the Cluster                                       |
| cockroachdb.node_liveness_heartbeats             |                                                                          successful, failed                                                                           |  heartbeats  | Node Liveness Heartbeats                                        |
| cockroachdb.total_storage_capacity               |                                                                                 total                                                                                 |     KiB      | Total Storage Capacity                                          |
| cockroachdb.storage_capacity_usability           |                                                                           usable, unusable                                                                            |     KiB      | Storage Capacity Usability                                      |
| cockroachdb.storage_usable_capacity              |                                                                            available, used                                                                            |     KiB      | Storage Usable Capacity                                         |
| cockroachdb.storage_used_capacity_percentage     |                                                                             total, usable                                                                             |  percentage  | Storage Used Capacity Utilization                               |
| cockroachdb.sql_connections                      |                                                                                active                                                                                 | connections  | Active SQL Connections                                          |
| cockroachdb.sql_bandwidth                        |                                                                            received, sent                                                                             |     KiB      | SQL Bandwidth                                                   |
| cockroachdb.sql_statements_total                 |                                                                           started, executed                                                                           |  statements  | SQL Statements Total                                            |
| cockroachdb.sql_errors                           |                                                                        statement, transaction                                                                         |    errors    | SQL Statements and Transaction Errors                           |
| cockroachdb.sql_started_ddl_statements           |                                                                                  ddl                                                                                  |  statements  | SQL Started DDL Statements                                      |
| cockroachdb.sql_executed_ddl_statements          |                                                                                  ddl                                                                                  |  statements  | SQL Executed DDL Statements                                     |
| cockroachdb.sql_started_dml_statements           |                                                                    select, update, delete, insert                                                                     |  statements  | SQL Started DML Statements                                      |
| cockroachdb.sql_executed_dml_statements          |                                                                    select, update, delete, insert                                                                     |  statements  | SQL Executed DML Statements                                     |
| cockroachdb.sql_started_tcl_statements           |             begin, commit, rollback, savepoint, savepoint_cockroach_restart, release_savepoint_cockroach_restart, rollback_to_savepoint_cockroach_restart             |  statements  | SQL Started TCL Statements                                      |
| cockroachdb.sql_executed_tcl_statements          |             begin, commit, rollback, savepoint, savepoint_cockroach_restart, release_savepoint_cockroach_restart, rollback_to_savepoint_cockroach_restart             |  statements  | SQL Executed TCL Statements                                     |
| cockroachdb.sql_active_distributed_queries       |                                                                                active                                                                                 |   queries    | Active Distributed SQL Queries                                  |
| cockroachdb.sql_distributed_flows                |                                                                            active, queued                                                                             |    flows     | Distributed SQL Flows                                           |
| cockroachdb.live_bytes                           |                                                                         applications, system                                                                          |     KiB      | Used Live Data                                                  |
| cockroachdb.logical_data                         |                                                                             keys, values                                                                              |     KiB      | Logical Data                                                    |
| cockroachdb.logical_data_count                   |                                                                             keys, values                                                                              |     num      | Logical Data Count                                              |
| cockroachdb.kv_transactions                      |                                                                committed, fast-path_committed, aborted                                                                | transactions | KV Transactions                                                 |
| cockroachdb.kv_transaction_restarts              | write_too_old, write_too_old_multiple, forwarded_timestamp, possible_reply, async_consensus_failure, read_within_uncertainty_interval, aborted, push_failure, unknown |   restarts   | KV Transaction Restarts                                         |
| cockroachdb.ranges                               |                                                                                ranges                                                                                 |    ranges    | Ranges                                                          |
| cockroachdb.ranges_replication_problem           |                                                            unavailable, under_replicated, over_replicated                                                             |    ranges    | Ranges Replication Problems                                     |
| cockroachdb.range_events                         |                                                                       split, add, remove, merge                                                                       |    events    | Range Events                                                    |
| cockroachdb.range_snapshot_events                |                                                generated, applied_raft_initiated, applied_learner, applied_preemptive                                                 |    events    | Range Snapshot Events                                           |
| cockroachdb.rocksdb_read_amplification           |                                                                                 reads                                                                                 | reads/query  | RocksDB Read Amplification                                      |
| cockroachdb.rocksdb_table_operations             |                                                                         compactions, flushes                                                                          |  operations  | RocksDB Table Operations                                        |
| cockroachdb.rocksdb_cache_usage                  |                                                                                 used                                                                                  |     KiB      | RocksDB Block Cache Usage                                       |
| cockroachdb.rocksdb_cache_operations             |                                                                             hits, misses                                                                              |  operations  | RocksDB Block Cache Operations                                  |
| cockroachdb.rocksdb_cache_hit_rate               |                                                                               hit_rate                                                                                |  percentage  | RocksDB Block Cache Hit Rate                                    |
| cockroachdb.rocksdb_sstables                     |                                                                               sstables                                                                                |   sstables   | RocksDB SSTables                                                |
| cockroachdb.replicas                             |                                                                               replicas                                                                                |   replicas   | Number of Replicas                                              |
| cockroachdb.replicas_quiescence                  |                                                                           quiescent, active                                                                           |   replicas   | Replicas Quiescence                                             |
| cockroachdb.replicas_leaders                     |                                                                       leaders, not_leaseholders                                                                       |   replicas   | Number of Raft Leaders                                          |
| cockroachdb.replicas_leaseholders                |                                                                             leaseholders                                                                              | leaseholders | Number of Leaseholders                                          |
| cockroachdb.queue_processing_failures            |                                   gc, replica_gc, replication, split, consistency, raft_log, raft_snapshot, time_series_maintenance                                   |   failures   | Queues Processing Failures                                      |
| cockroachdb.rebalancing_queries                  |                                                                                  avg                                                                                  |  queries/s   | Rebalancing Average Queries                                     |
| cockroachdb.rebalancing_writes                   |                                                                                  avg                                                                                  |   writes/s   | Rebalancing Average Writes                                      |
| cockroachdb.timeseries_samples                   |                                                                                written                                                                                |   samples    | Time Series Written Samples                                     |
| cockroachdb.timeseries_write_errors              |                                                                                 write                                                                                 |    errors    | Time Series Write Errors                                        |
| cockroachdb.timeseries_write_bytes               |                                                                                written                                                                                |     KiB      | Time Series Bytes Written                                       |
| cockroachdb.slow_requests                        |                                                              acquiring_latches, acquiring_lease, in_raft                                                              |   requests   | Slow Requests                                                   |
| cockroachdb.code_heap_memory_usage               |                                                                                go, cgo                                                                                |     KiB      | Heap Memory Usage                                               |
| cockroachdb.goroutines                           |                                                                              goroutines                                                                               |  goroutines  | Number of Goroutines                                            |
| cockroachdb.gc_count                             |                                                                                  gc                                                                                   |   invokes    | GC Runs                                                         |
| cockroachdb.gc_pause                             |                                                                                 pause                                                                                 |      us      | GC Pause Time                                                   |
| cockroachdb.cgo_calls                            |                                                                                  cgo                                                                                  |    calls     | Cgo Calls                                                       |

## Setup

### Prerequisites

No action required.

### Configuration

#### File

The configuration file name is `go.d/cockroachdb.conf`.

The file format is YAML. Generally, the format is:

```yaml
update_every: 1
autodetection_retry: 0
jobs:
  - name: some_name1
  - name: some_name1
```

You can edit the configuration file using the `edit-config` script from the
Netdata [config directory](https://github.com/netdata/netdata/blob/master/docs/configure/nodes.md#the-netdata-config-directory).

```bash
cd /etc/netdata 2>/dev/null || cd /opt/netdata/etc/netdata
sudo ./edit-config go.d/cockroachdb.conf
```

#### Options

The following options can be defined globally: update_every, autodetection_retry.

<details>
<summary>Config options</summary>

|         Name         | Description                                                                                               |              Default               | Required |
|:--------------------:|-----------------------------------------------------------------------------------------------------------|:----------------------------------:|:--------:|
|     update_every     | Data collection frequency.                                                                                |                 10                 |          |
| autodetection_retry  | Re-check interval in seconds. Zero means not to schedule re-check.                                        |                 0                  |          |
|         url          | Server URL.                                                                                               | http://127.0.0.1:8080/_status/vars |   yes    |
|       timeout        | HTTP request timeout.                                                                                     |                 1                  |          |
|       username       | Username for basic HTTP authentication.                                                                   |                                    |          |
|       password       | Password for basic HTTP authentication.                                                                   |                                    |          |
|      proxy_url       | Proxy URL.                                                                                                |                                    |          |
|    proxy_username    | Username for proxy basic HTTP authentication.                                                             |                                    |          |
|    proxy_password    | Password for proxy basic HTTP authentication.                                                             |                                    |          |
|        method        | HTTP request method.                                                                                      |                GET                 |          |
|         body         | HTTP request body.                                                                                        |                                    |          |
|       headers        | HTTP request headers.                                                                                     |                                    |          |
| not_follow_redirects | Redirect handling policy. Controls whether the client follows redirects.                                  |                 no                 |          |
|   tls_skip_verify    | Server certificate chain and hostname validation policy. Controls whether the client performs this check. |                 no                 |          |
|        tls_ca        | Certification authority that the client uses when verifying the server's certificates.                    |                                    |          |
|       tls_cert       | Client TLS certificate.                                                                                   |                                    |          |
|       tls_key        | Client TLS key.                                                                                           |                                    |          |

</details>

#### Examples

##### Basic

An example configuration.
<details>
<summary>Config</summary>

```yaml
jobs:
  - name: local
    url: http://127.0.0.1:8080/_status/vars
```

</details>

##### HTTP authentication

Local server with basic HTTP authentication.
<details>
<summary>Config</summary>

```yaml
jobs:
  - name: local
    url: http://127.0.0.1:8080/_status/vars
    username: username
    password: password
```

</details>

##### HTTPS with self-signed certificate

CockroachDB with enabled HTTPS and self-signed certificate.
<details>
<summary>Config</summary>

```yaml
jobs:
  - name: local
    url: https://127.0.0.1:8080/_status/vars
    tls_skip_verify: yes
```

</details>

##### Multi-instance

> **Note**: When you define multiple jobs, their names must be unique.

Collecting metrics from local and remote instances.

<details>
<summary>Config</summary>

```yaml
jobs:
  - name: local
    url: http://127.0.0.1:8080/_status/vars

  - name: remote
    url: http://203.0.113.10:8080/_status/vars
```

</details>

## Troubleshooting

### Debug mode

To troubleshoot issues with the `cockroachdb` collector, run the `go.d.plugin` with the debug option enabled. The output
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
  ./go.d.plugin -d -m cockroachdb
  ```


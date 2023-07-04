# Overview

Brief description of configuration files/data collection jobs processing in go.d.plugin.

## Configuration files format and location

All files are in YAML format.

There are 2 kinds of configuration files: plugin and module.

| Kind   | Name            | Stock Dir                       | User Dir             |
|--------|-----------------|---------------------------------|----------------------|
| plugin | go.d.conf       | `/usr/lib/netdata/conf.d/`      | `/etc/netdata/`      |
| module | moduleName.conf | `/usr/lib/netdata/conf.d/go.d/` | `/etc/netdata/go.d/` |

### Plugin configuration file

Contains global plugin options (e.g. enabled/disabled, max number of used CPUs) and options for each module (only
enable/disable). See stock [go.d.conf](https://github.com/netdata/go.d.plugin/blob/master/config/go.d.conf).

Generally, the format is:

```yaml
# go.d.conf
option1: value
# ...
optionN: value
modules:
  - module1: yes/no
  - ...
  - moduleN: yes/no
```

### Module configuration file

Contains module options. For example, see
stock [apache.conf](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/apache.conf).

Usually it is a configuration file for each module.

```cmd
/opt/netdata/usr/lib/netdata/conf.d/go.d
├── activemq.conf
├── apache.conf
├── bind.conf
├── cassandra.conf
├── chrony.conf
├── cockroachdb.conf
├── consul.conf
├── coredns.conf
├── couchbase.conf
├── ...

```

#### Single-module configuration file

Contains a list of data collection jobs for a single module. The filename MUST be in `moduleName.conf` format. This is
necessary so that the plugin can associate jobs with the corresponding module.

Generally, the format is:

```yaml
# moduleName.conf (e.g. apache.conf)
jobs:
  - name: local
    module_specific_option1: value
    # ...
    module_specific_optionN: value

```

#### Multi-module configuration file

It is acceptable to have data collection jobs for multiple modules in one file. In this case, each data collection job
MUST have a `module: moduleName` setting. This is necessary so that the plugin can associate jobs with the corresponding
module.

Generally, the format is:

```yaml
# anyName.conf (e.g. whateverName.conf)
jobs:
  - name: local
    module: apache
    apache_specific_option1: value
    # ...
    apache_specific_optionN: value

  - name: local
    module: nginx
    nginx_specific_option1: value
    # ...
    nginx_specific_optionN: value
```

## Configuration files processing

go.d.plugin can Read and Watch files.

The result of processing the configuration file is a list of data collection jobs.

### User vs Stock vs Watch

The configuration directories are set by Netdata through environment variables.

| Directory | Environment variable             |
|-----------|----------------------------------|
| User      | `NETDATA_USER_CONFIG_DIR`        |
| Stock     | `NETDATA_STOCK_CONFIG_DIR`       |
| Watch     | `NETDATA_PLUGINS_GOD_WATCH_PATH` |

### Read

Configuration files are Read:

- at startup
- on reload (SIGHUP)

For each module **enabled** in go.d.conf go.d.plugin tries:

- to find `module.conf` in the User and Stock directories.
- the first one found will be used (Stock will not be read if User exists).

### Watch

Configuration files are (re)Read:

- at startup
- on files modification

Directory watching (automatically watching new files matching the pattern) is supported but not used.

## Jobs

A job is just a dictionary. It has 2 kind of keys/options.

- internal: `module`, `__source__`, `__provider__`.
- the rest are collector configuration settings (e.g. `url`, `dsn`, `address`, `timeout`).

So the following configuration

```yaml
# /etc/netdata/go.d/apache.conf
jobs:
  - name: local
    url: http://127.0.0.1/server-status?auto

  - name: local
    url: http://192.0.2.1/server-status?auto
```

will result in

```yaml
  - name: local
    url: http://127.0.0.1/server-status?auto
    module: apache
    __source__: /etc/netdata/go.d/apache.conf
    __provider__: file_read

  - name: local
    url: http://192.0.2.1/server-status?auto
    module: apache
    __source__: /etc/netdata/go.d/apache.conf
    __provider__: file_read
```

### Hash/uniqueness

For each Job we calculate hash. All **internal** keys (`__NAME__`) are ignored.

### Add/remove interface

There are 2 components:

- Job Discovery: find jobs (e.g. reading config files) and send them to Job Manager.
- Job Manager: start/stop jobs, maintain their state.

Job Discovery has to discover jobs and provide them to Job Manager.

It is expected similar jobs (configs) to be grouped together by Source, in the form of a config Group.

```go
package confgroup

type Group struct {
	Configs []map[string]any
	Source  string
}
```

- Discovery sends the jobs from Source down to Manager as a list of Configs.
- Discovery will watch for changes for this Source.
- Discovery doesn't have to track specific changes to the source. If any, Discovery should resend the Group.
- Manager will process the changes (calculate the hash for each job and find what has been added/removed).
- If all the jobs in a group go away (e.g. file was deleted), we need to send the config groups with empty Configs to
  Manager.

### Jobs state/state file

Stored in `/var/lib/netdata/god-jobs-statuses.json`.

Format is

```json
{
  "moduleName": {
    "jobName:hash": "state"
  }
}

```

Job states:

| State              | Description                                                     |
|--------------------|-----------------------------------------------------------------|
| success            | successfully started (data being collected)                     |
| retry              | failed, but we need to try again to start it later              |
| failed             | failed to start (e.g. couldn't connect to a DB)                 |
| duplicate_local    | a job with the same module/name is started                      |
| duplicate_global   | a job with the same module/name is registered by another plugin |
| registration_error | an error during registration (only 'too many open files')       |
| build_error        | an error during building (yaml unmarshalling)                   |

Example:

```bash
$ sudo cat /opt/netdata/var/lib/netdata/god-jobs-statuses.json
{
 "activemq": {
  "local:14596621561266494414": "failed"
 },
 "apache": {
  "local:1189662825161939815": "failed",
  "local:17111437997877908439": "failed"
 },
 "bind": {
  "local:100876918761637193": "failed",
  "local:2602159113841357685": "failed"
 },
```

### Jobs lock files

Files are stored in `/var/lib/netdata/lock/`.

See [netdata/netdata#9387](https://github.com/netdata/netdata/issues/9387) for details.

Example:

```bash
$ sudo ls -l /opt/netdata/var/lib/netdata/lock/
total 9
-rw------- 1 netdata netdata 0 Jul  3 11:08 chrony_local.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 dnsmasq_dhcp.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 dnsmasq_local.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 docker_local.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 example.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 example_example2.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 example_example3.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 example_example4.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 example_example5.collector.lock
-rwxrwx--- 1 netdata netdata 0 Jul  3 11:08 hddtemp_local.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 logind.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 nvme.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 ping_example.collector.lock
-rwxrwx--- 1 netdata netdata 0 Jul  3 11:08 postfix_local.collector.lock
-rwxrwx--- 1 netdata netdata 0 Jul  3 11:08 sensors.collector.lock
-rwxrwx--- 1 netdata netdata 0 Jul  3 11:08 smartd_log.collector.lock
-rw------- 1 netdata netdata 0 Jul  3 11:08 systemdunits_service-units.collector.lock
```

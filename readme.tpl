# {{ .title }}

## Overview

{{ .overview.application.description }}
{{ .overview.collector.description }}
## Collected metrics
Metrics grouped by *scope*.

The scope defines the instance that the metric belongs to. An instance is uniquely identified by a set of labels.

{{ .metrics.description }}
{{ if .metrics.folding.enabled }}
<details>
<summary>{{ .metrics.folding.title }}</summary>
{{ end }}

{{- range $_, $scope := .metrics.scope }}

### {{ $scope.name }}

{{ $scope.description }}
{{ if not $scope.labels }}
This scope has no labels.
{{ else }}
Labels:

| Label   | Description |
| -------| -----------  |
{{- range $_, $label := $scope.labels }}
| {{- $label.name -}}| {{- $label.description -}} |
{{- end }}
{{ end }}
Metrics:
{{ if hasKey $.metrics "availability" }}
{{- $availList := list }}
{{- range $_, $name := $.metrics.availability }}
    {{- $availList = append $availList $name}}
{{- end }}
| Metric   | Dimensions | Unit | {{- $availList | join "/" }} |
| -------|  :-------: | :--------: | :--------: |
{{- range $_, $metric := $scope.metrics }}
    {{- $dimList := list }}
    {{- range $_, $dim := $metric.dimensions }}
        {{- $dimList = append $dimList $dim.name}}
    {{- end }}
    {{- $metricAvailList := list }}
    {{- range $_, $name := $availList }}
        {{- if and (hasKey $metric "availability") (has $name $metric.availability) }}
            {{- $metricAvailList = append $metricAvailList "+" }}
        {{- else }}
            {{- $metricAvailList = append $metricAvailList "-" }}
        {{- end }}
    {{- end }}
| {{- $metric.name -}}| {{- $dimList | join ", " }} | {{- $metric.unit -}} | {{ $metricAvailList | join " " }} |
{{- end }}
{{ else }}
| Metric   | Dimensions | Unit |
| -------|  :-------: | :--------: |
{{- range $_, $metric := $scope.metrics }}
  {{- $dimList := list }}
  {{- range $_, $dim := $metric.dimensions }}
    {{- $dimList = append $dimList $dim.name}}
  {{- end }}
| {{- $metric.name -}}| {{- $dimList | join ", " }} | {{- $metric.unit -}} |
{{- end }}
{{ end }}

{{- end }}

{{ if .metrics.folding.enabled }}
</details>
{{ end }}
## Setup

### Prerequisites
{{ if .setup.prerequisites.list }}
{{ range $_, $val := .setup.prerequisites.list }}
#### {{ $val.title }}

{{ $val.text }}
{{- end }}
{{ else }}
No action required.
{{- end }}

### Configuration

#### File

The configuration file name is `go.d/{{ .name }}.conf`.

The file format is YAML. Generally the format is:

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
sudo ./edit-config go.d/{{ .name }}.conf
```

#### Options

{{ .setup.configuration.options.description }}
{{ if .setup.configuration.options.folding.enabled -}}
<details>
<summary>{{ .setup.configuration.options.folding.title }}</summary>
{{ end }}
| Name   | Description | Default | Required |
| :-------:| ----------- | :-------: | :-------: |
{{- range $key, $val := .setup.configuration.options.list }}
| {{- $val.name -}}| {{- $val.description -}} | {{- $val.default }} | {{ ternary "yes" "" $val.required }} |
{{- end }}
{{ if .setup.configuration.options.folding.enabled }}
</details>
{{- end }}

{{ range $key, $val := .setup.configuration.options.list }}
{{- if hasKey $val "details" -}}
##### {{$val.name }}

{{ $val.details }}
{{ end }}
{{- end }}

#### Examples

{{- range $_, $val := .setup.configuration.examples.list }}

##### {{ $val.name }}
{{ if $.setup.configuration.examples.folding.enabled }}
{{ $val.description}}
<details>
<summary>{{ $.setup.configuration.examples.folding.title }}</summary>

```yaml
{{ $val.data -}}
```

</details>
{{- else }}
{{ $val.description}}

```yaml
{{ $val.data -}}
```
{{- end }}
{{- end }}

## Troubleshooting

### Debug mode

To troubleshoot issues with the `{{ .name }}` collector, run the `go.d.plugin` with the debug option enabled. The output
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
  ./go.d.plugin -d -m {{ .name }}
  ```
{{ if .troubleshooting.problems.list }}
### Common Problems
{{- range $key, $val := .troubleshooting.problems.list }}

#### {{ $val.name}}

{{ $val.text}}
{{- end }}
{{- end }}

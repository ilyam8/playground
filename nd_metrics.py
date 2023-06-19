import csv
import json
import urllib.request

TARGET = "http://10.10.11.2:19999/api/v1/charts"
OUTPUT_FILE = "/Users/ilyam/Projects/playground/playPython/metrics.csv"


class Chart:
    def __init__(self,
                 context,
                 chart_id,
                 title,
                 units,
                 plugin,
                 module,
                 chart_type,
                 dimensions,
                 labels,
                 ):
        self.context = context
        self.chart_id = chart_id
        self.title = title
        self.units = units
        self.plugin = plugin
        self.module = module
        self.chart_type = chart_type
        self.dimensions = dimensions
        self.labels = labels


def write_csv(filename, charts):
    charts = sorted(charts, key=lambda v: v.context, reverse=False)
    with open(filename, mode='w') as f:
        w = csv.writer(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        w.writerow([
            'metric', 'scope', 'dimensions', 'unit', 'description', 'chart_type', 'labels', 'plugin', 'module',
        ])
        for c in charts:
            w.writerow([
                c.context,
                "TODO" if c.labels else "",
                c.dimensions,
                c.units,
                c.title,
                c.chart_type,
                c.labels,
                c.plugin,
                c.module,
            ])


def main():
    all_contexts = dict()

    content = urllib.request.urlopen(TARGET).read()
    data = json.loads(content)
    for k, v in data['charts'].items():
        if not k.startswith("netdata."):
            continue

        context = v["context"]
        title = v["title"]
        idx = title.find("(")
        if idx > 0:
            title = title[0:idx - 1]

        if context not in all_contexts:
            all_contexts[context] = list()

        all_contexts[context].append(Chart(
            context=v["context"],
            chart_id=v["id"],
            title=title,
            units=v["units"],
            plugin=v["plugin"],
            module=v["module"],
            chart_type=v["chart_type"],
            dimensions=", ".join([d for d in v["dimensions"]]),
            labels=", ".join([lbl for lbl in v["chart_labels"] if not lbl.startswith("_")]),
        ))

    chart_list = list()
    for k, charts in all_contexts.items():
        chart_list.append(charts[0])

    write_csv(OUTPUT_FILE, chart_list)


main()

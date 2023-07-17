# playground


<details>
<summary>Collapsible section without HTML tags</summary>

As much as you need!

Netdata supports **tiering**, to downsample past data and save disk space. With default settings, it has 3 tiers:

- `tier 0`, with high resolution, per-second, data.
- `tier 1`, mid-resolution, per minute, data.
- `tier 2`, low-resolution, per hour, data.

All tiers are updated in parallel during data collection. Just increase the disk space you give to Netdata to get a
longer history for your metrics. Tiers are automatically chosen at query time depending on the time frame and the
resolution requested.

</details>

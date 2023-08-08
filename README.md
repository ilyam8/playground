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


> **NOTE**<br/>
> Netdata Functions are available only when you are signed-in to Netdata and your Netdata Agent is claimed.
> This has been done to protect your privacy. Netdata Cloud checks that the users of the Agent dashboard are allowed to view this information.

> **WARNING**<br/>
> Netdata Functions are available only when you are signed-in to Netdata and your Netdata Agent is claimed.
> This has been done to protect your privacy. Netdata Cloud checks that the users of the Agent dashboard are allowed to view this information.

> **IMPORTANT**<br/>
> The `systemd-journal` function is currently available only on Netdata Agents that have been installed from source, or with native packages of the Linux distribution (RPM, DEB). Users running static builds of Netdata or running Netdata in a docker container, we are working to bring `systemd-journal` to them too. Stay tuned...

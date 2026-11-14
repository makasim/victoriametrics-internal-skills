# Changelog entry examples

Real entries that follow the rules in [SKILL.md](SKILL.md).

```md
**Update Note 1:** `vmctl` in [vm-native](https://docs.victoriametrics.com/victoriametrics/vmctl/victoriametrics/) mode: `--vm-native-filter-time-end` is now a required parameter. See [#11830](https://github.com/VictoriaMetrics/VictoriaMetrics/pull/11830).

* SECURITY: upgrade Go builder from Go1.27.3 to Go1.27.4. See [the list of issues addressed in Go1.27.4](https://github.com/golang/go/issues?q=milestone%3AGo1.27.4%20label%3ACherryPickApproved).
* SECURITY: [vmauth](https://docs.victoriametrics.com/victoriametrics/vmauth/): slow down requests with invalid auth tokens even if `unauthorized_user` has URLs configured. Previously, such requests were proxied to `unauthorized_user` without delay, which allowed brute-forcing auth tokens. See [GHSA-rpfx-hrcp-f73x](https://github.com/VictoriaMetrics/VictoriaMetrics/security/advisories/GHSA-rpfx-hrcp-f73x).

* FEATURE: [vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/) and [vmsingle](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/): add support for [linode_sd_configs](https://docs.victoriametrics.com/victoriametrics/sd_configs/#linode_sd_configs) for discovering scrape targets from Linode instances. See [#9118](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/9118). Thanks to @cxdy for the contribution.
* FEATURE: [vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/): add a new flag `-remoteWrite.queuePath`, which allows configuring [persistent-queue](https://docs.victoriametrics.com/victoriametrics/vmagent/#on-disk-persistence) path for each `-remoteWrite.url` independently. See [#11662](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/11662).

* BUGFIX: [vmsingle](https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/) and `vmstorage` in [VictoriaMetrics cluster](https://docs.victoriametrics.com/victoriametrics/cluster-victoriametrics/): properly release memory after historical [data backfilling](https://docs.victoriametrics.com/victoriametrics/#backfilling). Previously storage kept 8MiB*CPU memory for each month of ingested data until restart. See [#11672](https://github.com/VictoriaMetrics/VictoriaMetrics/issues/11672). Thanks to @mars71003219 for the contribution.
* BUGFIX: [stream aggregation](https://docs.victoriametrics.com/victoriametrics/stream-aggregation/): properly delay flushes after a sudden ingestion lag spike when [aggregation windows](https://docs.victoriametrics.com/victoriametrics/stream-aggregation/#aggregation-windows) are enabled. Previously, a data gap or a restart could reduce the tolerance for delayed samples to the aggregation interval, resulting in more dropped samples than necessary. See [#11866](https://github.com/VictoriaMetrics/VictoriaMetrics/pull/11866).
```

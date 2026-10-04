# Cyber lab

A bar badge for an Omarchy cyber lab. It reports two facts:

- Whether `dumpcap`, `tcpdump`, `wireshark`, or `termshark` is already running.
- Whether the newest `~/Work/<name>/scope.md` has an `Authorized by:` line with a name on it.

The label is `cap` during a capture, `scope` when a lab folder exists but nobody is named, and `lab` otherwise. Click opens that `scope.md`. The plugin does not start a capture, does not install packages, and does not edit the scope file.

`status.sh` prints one JSON object and exits. `CYBER_LAB_WORK` overrides `~/Work` for a test.

```bash
omarchy plugin validate .
omarchy plugin add https://github.com/calledtoconstruct/omarchy-cyber-lab.git --enable
```

This is the widget the [cyber bundle](https://github.com/calledtoconstruct/omarchy-bundles/tree/main/bundles/cyber) installs. A case-manager application and a capture start/stop control do not exist yet. Those would decide when a capture starts. This badge only shows what is already running.

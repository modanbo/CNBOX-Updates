# CNBOX-Updates

Public **read-only distribution channel** used by `CNBOX_Manager.exe`.

This repository intentionally contains only release-facing material:

- `channel.json` — stable machine-readable update manifest.
- `manager/` — CNBOX Manager binaries.
- `payloads/` — version-mapped CNBOX update payloads.
- `manifests/` — hashes and release metadata.
- `profiles/` — optional minimal diagnostic collection profiles.

The private engineering repositories and Google Drive project library remain the source of truth for development and validation. They are not mirrored here.

## Safety model

The Manager only installs a CNBOX payload when its WoT / Aslain / XVM compatibility entry matches and the CNBOX-scoped clean-baseline verification passes. Unrelated Aslain plugins are outside the gate unless they touch a declared CNBOX dependency.

Binary publishing is hash-gated. The public publishing workflow only accepts allow-listed temporary HTTPS sources and safe destination prefixes.

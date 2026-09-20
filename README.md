# CNBOX-Updates

Public **read-only distribution channel** used by `CNBOX_Manager.exe`.

This repository intentionally contains only release-facing material:

- `channel.json` — stable machine-readable update manifest.
- `manager/` — CNBOX Manager binaries.
- `payloads/` — version-mapped CNBOX update payloads.
- `language/` — reusable CNBOX Chinese translation donor packages.
- `manifests/` — hashes and release metadata.
- `profiles/` — optional minimal diagnostic collection profiles.

The private engineering repositories and Google Drive project library remain the source of truth for development and validation. They are not mirrored here.

## Unified public CNBOX install

Current public releases use `installMode: CNBOX_AUTHORITATIVE`.

The Manager matches the unified Box by WoT version. Aslain is not required: the published payload contains the complete CNBOX/Aslain-XVM dependency set needed by the Box.

Before install/update/repair, Manager transaction-safely cleans the complete declared CNBOX/XVM ownership scope and then fully overwrites that scope with the published unified structure. This includes the full CNBOX XVM profile, PlayersPanel/OTM configuration, py_macro layer, XVM shared runtime/l10n resources, XVM/OpenWG runtime WOTMODs, XVM audio/client loader, and CNBOX owner files. Aslain does not need to be installed first. If Aslain is installed, unrelated plugins outside the CNBOX ownership scope are retained.

The result is one complete public CNBOX structure whether the user never installed Aslain, installed Aslain with different XVM/list/OTM choices, or reinstalled CNBOX over an existing Aslain setup.

## Safety model

- Every published payload and Manager binary is SHA-256 gated.
- Authoritative cleanup is restricted to explicit managed directories/file patterns from `channel.json`.
- Existing owned files are copied to a temporary transaction-safety area before replacement; failed installs restore them.
- Persistent rollback snapshots remain user-controlled through Manager's Manual Backup workflow.
- Language restore uses the current NA client's local original-language backup and is separate from CNBOX plugin rollback.

Binary publishing is hash-gated. The public publishing workflow only accepts allow-listed temporary HTTPS sources and safe destination prefixes.


## Dependency-focused diagnostics

Manager v1.0.7 diagnostics do not dump the entire Aslain installation.

Both normal Diagnostic collection and Runtime collection include the complete CNBOX dependency scope:
- the full CNBOX Aslain XVM profile;
- XVM py_macro runtime source;
- XVM shared runtime/l10n resources (documentation excluded);
- XVM/OpenWG core/fix WOTMODs;
- XVM audio/client-loader dependencies;
- CNBOX owner files.

Unrelated Aslain plugins are excluded. Each ZIP contains `CNBOX_DEPENDENCY_SCOPE.json` with the collected paths, categories, sizes and SHA-256 hashes.

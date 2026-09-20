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


## Current public artifacts

Manager:
- version: 1.0.9
- stable path: `manager/CNBOX_Manager.exe`
- versioned path: `manager/CNBOX_Manager_v1.0.9.exe`
- SHA256: `2b1535948687e4c4e8aa8ffb6eec07a9268f5de6138dab59ef00cadef4b492ff`

Unified Box:
- release: `2401-R34-R2F9-UNIFIED-R2`
- WoT: `2.4.0.1`
- Aslain required: **No**
- install policy: **full overwrite inside CNBOX/XVM ownership scope**
- public payload: `payloads/2.4.0.1/unified/CNBOX_PAYLOAD_R2.zip`
- SHA256: `b7d703104af74569b57817813709847eca2043fd2eb5f6498e1dc9c2d6839fe1`

The R2 payload was rebuilt from the locked NA dependency capture. It contains the complete Box dependency set required for standalone installation; it is not an overlay that depends on a prior Aslain installation.


## Manager v1.0.8 behavior fixes

- Aslain is shown as optional for authoritative standalone CNBOX releases. If Aslain cannot be detected, the UI shows that it is not required instead of treating the missing local Aslain version as an installation problem.
- Standalone CNBOX selection is resolved by WoT version before legacy Aslain detection logic.
- Original-language backups use the same base folder selected as “回滚备份位置”, under `CNBOX_LANGUAGE_BACKUPS`.
- A matching legacy AppData language backup is migrated automatically when needed.


## Manager v1.0.9 Aslain detection restoration

Aslain remains informational for the standalone CNBOX, but Check Updates once again tries to identify the
installed Aslain build instead of displaying "not required".

Detection order when local metadata is unavailable:
1. published exact file-hash fingerprint;
2. transient local Aslain metadata scan;
3. if neither can prove a version, display "未读取到本地版本".

The fingerprint exclusion logic was also corrected: only files owned by the CNBOX version CURRENTLY
installed on the client can disqualify an Aslain fingerprint. A newer available CNBOX release must not
invalidate the fingerprint for the user's current Aslain installation.

Standalone CNBOX install/update compatibility remains based on WoT version and does not depend on the
detected Aslain version.

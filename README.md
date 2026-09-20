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
- version: 1.1.0
- stable path: `manager/CNBOX_Manager.exe`
- versioned path: `manager/CNBOX_Manager_v1.1.0.exe`
- SHA256: `d22e775889f9a7a587ec128154385e6eefbb64c86864448cc9891aa25d5ade75`

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


## Manager v1.0.10 button-state review

- Check Updates clears stale Install/Update state before each new detection pass.
- Install/Update is enabled only for an actionable Box update; if the published Box is already the verified current version, the button stays disabled.
- Same-version damaged/missing Box files use Reinstall/Repair instead of Install/Update.
- Rollback is enabled only when at least one backup predates the current Manager-recorded install state.
- A current or later backup cannot make Rollback clickable merely because its Aslain/CNBOX labels differ.
- The v1.0.9 Hash-first Aslain version detection and v1.0.8 shared language-backup root remain unchanged.


## Manager v1.0.11 creator/public track separation

`2401-03-R34-R2F9-FINAL_LOCK-R1` and
`2401-R34-R2F9-UNIFIED-R2` are not sequential Box updates. They share functional ID
`WOT2401-R34-R2F9`.

- The creator/Aslain track follows the detected Aslain build and is used to produce each new Box migration.
- The public standalone track packages the already-locked creator Box with its complete dependencies so external users do not need Aslain.
- A creator-track client is never offered the public standalone package as its update source.
- If Aslain advances before a new creator migration exists, Manager waits for that Aslain migration instead of offering the public package.
- Fresh/public clients continue to receive the standalone public package.
- The complete R34/R2F9 functional dependency tree is published as `manifests/2.4.0.1/CNBOX_FUNCTIONAL_R34_R2F9.json` and is SHA-256 verified before structure comparison.


## Manager v1.0.13 public UI and pre-install restore

Public CNBOX Manager is now a separate build flavor for external users.

Public EXE does **not** expose:
- Runtime collection;
- Diagnostic collection;
- collection-save-path controls;
- Open Collection Folder.

Those development/diagnostic controls remain only in the private Creator build.

Both Public and Creator builds add **恢复安装前状态**:
- before every CNBOX install/update/repair, Manager creates one persistent PRE_INSTALL snapshot in the selected rollback backup root;
- only the latest PRE_INSTALL snapshot is retained per client;
- manual backups are preserved separately and are never pruned by this feature;
- the restore button is enabled only after a newer CNBOX installed state has been committed;
- PRE_INSTALL snapshots are not mixed into the historical “回滚旧版本” list;
- restoring the snapshot also restores the previous Manager InstalledState, including the “no CNBOX installed” state.


## Manager v1.1.0 naming

The current Manager feature set is released as v1.1.0. This supersedes the internal v1.0.13 label without changing the tested behavior.

Public and Creator remain separate builds. The public executable continues to omit Runtime/Diagnostic collection UI; the Creator executable retains those development tools. The pre-install restore, manual backup, historical rollback, language, and creator/public track rules are unchanged.

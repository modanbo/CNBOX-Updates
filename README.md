# NAJXBox Updates — `CNBOX-Updates` compatibility endpoint

Public **read-only distribution channel** used by current `NAJXBox Manager` and legacy `CNBOX_Manager.exe` clients.

The repository name remains `CNBOX-Updates` during the controlled brand migration so existing raw updater URLs continue to work. A new `NAJXBox-Updates` canonical repository will only replace it after the explicit compatibility bridge is verified.

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

Manager / Creator:
- version: **2.0.2**
- external product name: **NAJXBox**
- legacy stable Public path: `manager/CNBOX_Manager.exe`
- canonical Public alias: `manager/NAJXBox_Manager.exe`
- versioned Public path: `manager/NAJXBox_Manager_v2.0.2.exe`
- legacy stable Creator path: `manager/CNBOX_Manager_Creator.exe`
- canonical Creator alias: `manager/NAJXBox_Manager_Creator.exe`
- versioned Creator path: `manager/NAJXBox_Manager_Creator_v2.0.2.exe`
- Public SHA256: `7e6660b49b1614cef15d6e74467c4923648c9634479d76d0968c44cf4ebc45b4`
- Creator SHA256: `b71ffdd4983b37af9bcc502e5660b2247488fa12c6c8a9a35ff2ee621e20e974`
- dual-flavor ZIP: `manager/NAJXBox_Manager_v2.0.2.zip`
- dual-flavor ZIP SHA256: `46de3c1b7e5e4013191a772a84a09c36e0819919973eef47c8a3696200d4ec63`
- source commit: `9ce4102057f5059490e671bb8ddeb8ce5ce739d8`
- verified build/self-test/UI closure: run `35773869617`
- detailed guide: `manager/NAJXBox_Manager_v2.0.2_README.md`
- GitHub Release: `v2.0.2` — https://github.com/modanbo/CNBOX-Updates/releases/tag/v2.0.2

The old `CNBOX_Manager.exe` updater endpoint intentionally remains live and carries the exact same Public v2.0.2 bytes as the new `NAJXBox_Manager.exe` alias. This prevents legacy Manager clients from losing their update chain during the repository rename migration.

Manager v2.0.2 adds explicit current-Mod identity, the Public-standalone pre-test dependency-closure collection model, Runtime-superset/no-double-upload semantics, and NAJXBox external branding. Public and Creator remain separate build flavors and test candidates never become Public releases automatically.

Unified Box:
- release: `2401-R34-R2F9-UNIFIED-R2`
- WoT: `2.4.0.1`
- Aslain required: **No**
- install policy: **full overwrite inside CNBOX/XVM ownership scope**
- public payload: `payloads/2.4.0.1/unified/CNBOX_PAYLOAD_R2.zip`
- SHA256: `b7d703104af74569b57817813709847eca2043fd2eb5f6498e1dc9c2d6839fe1`

The Manager 2.0 promotion does not change the Public Box functional lock. The current Public Box remains the verified standalone FINAL_LOCK above.

## Current Creator / Aslain compatibility lock

The private Creator engineering track is separate from the public standalone distribution.

Current Creator Box:
- release: `2401-04-R34-R2F9-FINAL_LOCK-R1`
- WoT: `2.4.0.1`
- Aslain: `2.4.0.1 #04`
- XVM: `13.1.0.0090`
- Creator payload: `payloads/2.4.0.1/aslain-04/CNBOX_PAYLOAD.zip`
- payload SHA256: `7870c94e00e59c670068f951b2e09dc0b19fdb93db015e97781098145d375a50`
- release metadata: `manifests/2.4.0.1/CNBOX_CREATOR_ASLAIN04_R34_R2F9.json`
- status: `FINAL_LOCK / STATIC_PROMOTED / TWO_REVIEW_PASS / RUNTIME_NOT_REQUIRED_FOR_THIS_DELTA`

This #04 migration is a low-risk controlled XVM 0089 -> 0090 rebase. The CNBOX-critical `battle.swf` and `xvm_battle_classic.swf` remain byte-identical to the prior Runtime-proven #03 lock. The visible CNBOX change is the clearer 17x15 yellow spotted triangle, with its existing geometry preserved. Automatic compatibility preflight, two independent static reviews, synthetic install, and exact rollback passed.

Runtime collection is not a mandatory promotion gate for this delta. If a real in-game problem is observed later, the Creator workflow collects targeted Runtime evidence for that problem.

The public standalone release remains `2401-R34-R2F9-UNIFIED-R2`; publishing this Creator compatibility lock does **not** move Public users to XVM 0090 or change the Public Manager release.


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

`2401-04-R34-R2F9-FINAL_LOCK-R1` and
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


## Manager v1.1.2 localization / vehicle-name cache fix

v1.1.2 was the release that closed the vehicle-name localization defect; v1.2.0 keeps that tested language pipeline unchanged and adds explicit current-localization status display.

Real NA Runtime confirmed all four user-facing paths:
1. Chinese UI + Chinese vehicle names: PASS.
2. Restore original NA English: PASS.
3. Chinese UI + English vehicle names: PASS.
4. Restore original NA English again: PASS.

The root cause was not missing CN vehicle-name data and not an XVM hardcoded-English table. The versioned `res_mods` language overlay already produced Chinese values through Wulf, but WoT persisted already-converted English `vehicles_list` / `vehicles_cache` objects in `data.wgpdc`. v1.1.2 therefore treats the localization-version key and the derived PDC as part of the language transaction.

v1.1.2 rules:
- official NA `res` stays original during normal localization;
- translated files are written to the Manager-owned versioned `res_mods/<WoTVersion>/text/lc_messages` overlay;
- font override is written to the same versioned `res_mods` layer;
- the NA client's own `loc_version.xml` version/revision are preserved, while localized mode uses `language=zh_sg`;
- `data.wgpdc` is invalidated only while WoT is fully exited, then WoT rebuilds localized VehicleItem/VehicleType caches on next launch;
- direct Chinese-vehicle-name ↔ English-vehicle-name switching is supported; there is **no need to restore original English between the two localized modes**;
- `恢复原始语言` removes CNBOX-owned overlay files, restores pre-existing overlay files, restores original `loc_version.xml`, repairs legacy official-`res` writes if necessary, and invalidates PDC for an English rebuild;
- if WoT/WGC updates the client while localized, a newer localization revision is preserved and is not overwritten by the previous generation's sidecar;
- language operations fail closed when the selected WoT client is running, including root/win64/win32 executable layouts.

For the full operational and recovery model, see `manager/CNBOX_Manager_v1.1.2_README.md`.

### Direct switching rule

With World of Tanks fully exited:

`中文界面 + 英文坦克名称` → click **汉化（中文坦克名称）** directly.

`中文界面 + 中文坦克名称` → click **汉化（英文坦克名称）** directly.

No intermediate **恢复原始语言** step is required.



## Manager v1.2.0 current localization status

v1.2.0 keeps the v1.1.2 localization / `loc_version` / `data.wgpdc` transaction unchanged and adds a visible current-language state to the Manager UI.

The language row now reports one of:
- `原始 NA 英文`;
- `中文界面 + 中文坦克名称`;
- `中文界面 + 英文坦克名称`;
- a red warning state when the CNBOX owner record and `loc_version.xml` disagree, the localization is not CNBOX-owned, or the state cannot be proven.

The status is derived from the selected NA client, current WoT version, `loc_version.xml`, and the versioned `CNBOX_LANGUAGE_OVERLAY_OWNER.json`. It is **not** inferred from which button was clicked last.

The window title and main heading also display the Manager version, for example `CNBOX Manager v1.2.0` or `CNBOX Manager v1.2.0 [Creator]`.

### Direct localized-mode switching

With World of Tanks fully exited:

`中文界面 + 英文坦克名称` → click **汉化（中文坦克名称）** directly.

`中文界面 + 中文坦克名称` → click **汉化（英文坦克名称）** directly.

No intermediate **恢复原始语言** step is required. The Manager withdraws the previous owned overlay, rebuilds the selected mode, invalidates `data.wgpdc`, and WoT rebuilds the corresponding vehicle-name cache on next launch.

Use **恢复原始语言** only when the goal is to return to the original NA English UI + English vehicle names.

The v1.2.0 change does not alter the already Runtime-proven v1.1.2 language core. The previously completed real-client sequence remains authoritative:
1. Chinese UI + Chinese vehicle names — PASS.
2. Restore original NA English — PASS.
3. Chinese UI + English vehicle names — PASS.
4. Restore original NA English again — PASS.


# NAJXBox Updates — Public Distribution

Role: **CURRENT PUBLIC DISTRIBUTION**

Machine update authority: `channel.json`.

## Current release set

- Manager Public: **2.1.5**
  - `manager/NAJXBox_Manager.exe`
  - legacy alias: `manager/CNBOX_Manager.exe`
  - SHA256: `47706d47671df61787a4fc8b5088e178b1fcc0c595590635a77f183d1bc469d5`
- Manager Creator (GitHub engineering distribution only): **2.1.5**
  - SHA256: `682a1804d76bf8d0fb9d22b26934d780889c86135acdef49649c96d703e368f8`
- Box: **1.1.0**
  - compatibility/public alias: `2402-01-R34-R2F9-UNIFIED-R6`
  - WoT: `2.4.0.2`
  - payload: `payloads/2.4.0.2/unified/CNBOX_PAYLOAD_R6.zip`
  - SHA256: `b40c9b17b8ac42806b857bb92120e2ebc36148498ff28a6c046d72890d7406f2`
- MoE / 打环 (WoT 2.4.1.0): **1.3.1 FINAL_LOCK / GitHub+Drive frozen, consolidated Gitee pending**
  - payload: `moe/1.3.1/NAJXBOX_MoE_1.3.1_WOT_2.4.1.0_FINAL_LOCK.zip`
  - SHA256: `e003fbeaf1b015ae03fae521878a3ddf8a0e26dbb3b0c247fce3cfe1a6f34d2f`
  - Older-client compatibility (WoT 2.4.0.2): **1.3.0**, SHA256 `5d6bcfc871fdec58f8c8195eaecb0b9351a980ea917f3c054c0de66ebb134e19`; preserved, not the WoT241 package
- Language / 汉化 (WoT 2.4.1.0): **1.1.3 FINAL_LOCK**
  - payload: `language/NAJXBOX_LANGUAGE_1.1.3_WOT_2.4.1.0_FINAL_LOCK_20261014.zip`
  - SHA256: `592a0822cd3547f09772bb16ea70ddb2cc21da381c3a548ed6eae624e67afcc5`
  - Previous 1.1.2 / WoT 2.4.0.2 remains rollback/history, not the current Language pack

Environment boundaries (module-specific; not one universal WoT version):
- Box 1.1.0/R6 formally targets WoT `2.4.0.2`, frozen XVM `13.1.0.0093`; its WoT 2.4.1.0 / Aslain #02 engineering migration has failed real-client Runtime in prior attempts and is **not** a promoted Public Box release.
- MoE 1.3.1 and Language 1.1.3 target WoT `2.4.1.0`; older-client MoE 1.3.0 is retained separately.
- For exact client matching and package selection, `channel.json` is the machine install authority; do not infer compatibility from a single global version line.

## Current-tree retention rule

This repository's live distribution tree keeps the current installable release set. Superseded binary releases are retained by Git history and by the private engineering/Drive rollback archives rather than as competing current files.

Unique engineering history/reference material such as `moe/HISTORY.md`, `moe/reference/`, `moe/source/` and `moe/diagnostics/` is retained.

## Gitee

Gitee `modanbo/cnbox-updates-cn` is a **Public-only exact mirror** rebuilt from the current GitHub channel. Creator/private/history/test/evidence content is forbidden there.

Manager 2.1.5 is already the established Public release. Gitee is a distinct Public-only publication gate: MoE 1.3.1 consolidated Gitee synchronization is **intentionally deferred by the owner** until Language and Box overall closure. GitHub/Drive exact frozen MoE 1.3.1 does not imply that the latest Gitee mirror has passed. Do not push Creator or test artifacts to Gitee.

For release identity, always use `channel.json` and `CURRENT_RELEASE_INDEX.md`.

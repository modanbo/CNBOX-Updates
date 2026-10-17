# NAJXBox Updates — Public Distribution

Role: **CURRENT PUBLIC DISTRIBUTION**

Machine update authority: `channel.json`.

## Current release set (verified 2026-10-16)

- Manager Public: **2.1.5**
  - `manager/NAJXBox_Manager.exe`
  - legacy alias: `manager/CNBOX_Manager.exe`
  - SHA256: `47706d47671df61787a4fc8b5088e178b1fcc0c595590635a77f183d1bc469d5`
- Manager Creator (GitHub engineering distribution only): **2.1.5**
  - SHA256: `682a1804d76bf8d0fb9d22b26934d780889c86135acdef49649c96d703e368f8`
- Box (current WoT 2.4.1.0): **1.2.0 FINAL_LOCK**
  - Aslain clean build: `2.4.1.0 #03` (provenance, not standalone install prerequisite); XVM `13.1.0.0098`
  - exact original tested payload: `payloads/2.4.1.0/unified/CNBOX_PAYLOAD_R6.zip`
  - SHA256: `70c756fe280c76dbac2655d5bb1428d635f0e004f52d480dc5acf8fbb9ee1fe9` (14,585,152 bytes; 533 installed members)
  - Manager channel: WoT241 standalone and Creator rows; exact 533-file functional manifest at `manifests/2.4.1.0/CNBOX_FUNCTIONAL_R34_R2F9_R6.json`
  - Google Drive FINAL and frozen release provenance: [BOX 1.2.0 FINAL](https://drive.google.com/file/d/1g6T6pSm97lmF7-L7VIcHAgV1X03rKvWd/view)
- Box (previous WoT 2.4.0.2 compatibility / HISTORY): **1.1.0**
  - public compatibility alias: `2402-01-R34-R2F9-UNIFIED-R6`
  - previous payload: `payloads/2.4.0.2/unified/CNBOX_PAYLOAD_R6.zip`
  - SHA256: `b40c9b17b8ac42806b857bb92120e2ebc36148498ff28a6c046d72890d7406f2` (534 installed members; older client channel retained)
- MoE / 打环 (WoT 2.4.1.0): **1.3.1 FINAL_LOCK / GitHub+Drive frozen, consolidated Gitee pending**
  - payload: `moe/1.3.1/NAJXBOX_MoE_1.3.1_WOT_2.4.1.0_FINAL_LOCK.zip`
  - SHA256: `e003fbeaf1b015ae03fae521878a3ddf8a0e26dbb3b0c247fce3cfe1a6f34d2f`
  - Older-client compatibility (WoT 2.4.0.2): **1.3.0**, SHA256 `5d6bcfc871fdec58f8c8195eaecb0b9351a980ea917f3c054c0de66ebb134e19`; preserved, not the WoT241 package
- Language / 汉化 (WoT 2.4.1.0): **1.1.3 FINAL_LOCK**
  - payload: `language/NAJXBOX_LANGUAGE_1.1.3_WOT_2.4.1.0_FINAL_LOCK_20261014.zip`
  - SHA256: `592a0822cd3547f09772bb16ea70ddb2cc21da381c3a548ed6eae624e67afcc5`
  - Previous 1.1.2 / WoT 2.4.0.2 remains rollback/history, not the current Language pack

Environment boundaries (module-specific; not one universal WoT version):
- Box **1.2.0** targets WoT `2.4.1.0`, Aslain `#03`, XVM `13.1.0.0098`, and is **formally locked and published**. Earlier Aslain #02 migration failures remain engineering HISTORY, not the current release. Box **1.1.0** on WoT `2.4.0.2` / XVM `13.1.0.0093` is the preserved older-client compatibility track.
- MoE 1.3.1 and Language 1.1.3 target WoT `2.4.1.0`; older-client MoE 1.3.0 is retained separately.
- For exact client matching and package selection, `channel.json` is the machine install authority; do not infer compatibility from a single global version line.

## Current-tree retention rule

This repository's live distribution tree keeps the current installable release set. Superseded binary releases are retained by Git history and by the private engineering/Drive rollback archives rather than as competing current files.

Unique engineering history/reference material such as `moe/HISTORY.md`, `moe/reference/`, `moe/source/` and `moe/diagnostics/` is retained.

## Gitee

Gitee `modanbo/cnbox-updates-cn` is a **Public-only exact mirror** rebuilt from the current GitHub channel. Creator/private/history/test/evidence content is forbidden there.

Manager 2.1.5 is already the established Public release. Gitee is a separate **deferred, nonblocking backup mirror** for the current WoT241 release set; closing Box 1.2.0, MoE 1.3.1, and Language 1.1.3 on GitHub/Drive does **not** prove any newer Gitee synchronization. Keep Gitee status DEFERRED until its independent exact Public-only allowlist and hash readback passes. Never push Creator or test artifacts to Gitee.

For release identity, always use `channel.json` and `CURRENT_RELEASE_INDEX.md`.

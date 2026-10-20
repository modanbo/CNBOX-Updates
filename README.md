# NAJXBox Updates — Public Distribution

Role: **CURRENT PUBLIC DISTRIBUTION**

Machine update authority: `channel.json`.

## Current release set (2026-10-20: BOX1.2.1 newly FINAL_LOCK; Manager2.1.6 unchanged)

- Manager Public: **2.1.6 FINAL_LOCK**
  - `manager/NAJXBox_Manager.exe`
  - legacy alias: `manager/CNBOX_Manager.exe`
  - SHA256: `26bf0e7a0365095245a71752d22dd1139f681b9455e68bc40b72027ec5adcce8`
- Manager Creator (GitHub engineering distribution only): **2.1.6 FINAL_LOCK**
  - SHA256: `4df6364253fcd1f1873c8acc8ac4c7ea47e45a0c51a52735a06ace3f2426a64a`
  - Formal manifest: `manager/NAJXBox_Manager_2.1.6_RELEASE_MANIFEST.json`; 2.1.5 versioned binaries remain retained as rollback/HISTORY.
- Box (current WoT 2.4.1.0): **1.2.1 FINAL_LOCK** — exact owner-authorized T03 
  - Public **standalone** install does **not** require Aslain; #05 is manufacturing provenance only; XVM `13.1.0.0098`
  - immutable original ZIP: `payloads/2.4.1.0/unified/CNBOX_PAYLOAD_1.2.1.zip`
  - SHA256: `ce38abf70ca43b443810a375d067367622b5cac96263511cef63c0b9186be36f` (14,608,734 bytes / 533 entries)
  - changed only XVM Prestige/JX horizontal 1px helper and two Loading vehicle-format XCs from 1.2.0; **530/533 payload members byte-identical, map/minimap unchanged**
  - functional manifest: `manifests/2.4.1.0/CNBOX_FUNCTIONAL_R34_R2F9_R6_1.2.1.json`; Manager standalone/Creator `channel.json` each list all 533 exact files
  - [Google Drive FINAL exact copy](https://drive.google.com/file/d/1sEPP-51tvNUPBWJ6KtpTAewwNCtB8WUM/view); owner explicitly accepted formal lock without new T03 game Runtime; **NOT_TESTED, not fabricated PASS**
- Box (previous WoT 2.4.1.0 / ROLLBACK): **1.2.0**; original 533-file SHA `70c756fe280c76dbac2655d5bb1428d635f0e004f52d480dc5acf8fbb9ee1fe9`, original public `payloads/2.4.1.0/unified/CNBOX_PAYLOAD_R6.zip`, manifest `manifests/2.4.1.0/CNBOX_FUNCTIONAL_R34_R2F9_R6.json` and original [Drive file](https://drive.google.com/file/d/1g6T6pSm97lmF7-L7VIcHAgV1X03rKvWd/view) retained unchanged.
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
- Box **1.2.1** targets WoT `2.4.1.0`, XVM `13.1.0.0098`, and is **independent of Aslain being installed**; source Aslain `#05` is provenance only. Box **1.2.0** is retained as same-WoT-generation history/rollback. Earlier Aslain migration failures remain engineering HISTORY, not the current release. Box **1.1.0** on WoT `2.4.0.2` / XVM `13.1.0.0093` is the preserved older-client compatibility track.
- MoE 1.3.1 and Language 1.1.3 target WoT `2.4.1.0`; older-client MoE 1.3.0 is retained separately.
- For exact client matching and package selection, `channel.json` is the machine install authority; do not infer compatibility from a single global version line.

## Current-tree retention rule

This repository's live distribution tree keeps the current installable release set. Superseded binary releases are retained by Git history and by private engineering/Drive rollback archives; the explicitly retained Manager/Creator 2.1.5 versioned executables are rollback/HISTORY, not competing current aliases.

Unique engineering history/reference material such as `moe/HISTORY.md`, `moe/reference/`, `moe/source/` and `moe/diagnostics/` is retained.

## Gitee

Gitee `modanbo/cnbox-updates-cn` is a **Public-only exact mirror** rebuilt from the current GitHub channel. Creator/private/history/test/evidence content is forbidden there.

GitHub Public Manager/Creator **2.1.6** is the established current release. The last independently verified Gitee Public-only snapshot may still carry **Manager 2.1.5** and older Box/MoE bytes; it is a **deferred, nonblocking backup mirror**, not current GitHub release authority. Gitee synchronization for the current WoT241 release set is not proved; closing Box 1.2.1, MoE 1.3.1, and Language 1.1.3 on GitHub/Drive does **not** prove any newer Gitee synchronization. Keep Gitee status DEFERRED until its independent exact Public-only allowlist and hash readback passes. Never push Creator or test artifacts to Gitee.

For release identity, always use `channel.json` and `CURRENT_RELEASE_INDEX.md`.

# NAJXBox Updates — Public Distribution

Role: **CURRENT PUBLIC DISTRIBUTION**

Machine update authority: `channel.json`.

## 2026-10-25 Owner instruction — Aslain updates alone never republish CNBOX

**An Aslain upstream revision is not a CNBOX release revision.** Daily checks continue, but if the actual Box / MoE / Language / Manager+Creator release payloads and their required native interfaces have no proven change, do **NOT** rebuild, replace, rename or republish any locked GitHub ZIP/EXE, module manifest or current `channel.json` module version/hash/download URL. Do not update `latestAslainVersion` in the install channel merely to represent an Aslain-only revision; upstream observations belong in documentation and the lightweight Aslain index instead. Only a proven CNBOX-owned/required change starts module-specific candidate work, and formal promotion still requires the owner's explicit approval.

**Last reviewed upstream**: Aslain Classic `2.4.1.0 #08`, user Choice36 SHA `aa54b627c2a91aed4f23badddf7436810d43a793bb5bce170d2c59770f88624f`, official installer SHA `d32a833868d2dedcc2a1108762464eee86d0acf4068f267ad6c9c9acd1b37923`. Independent native/selected install-source owner audits found **zero new proven Box-owned path SHA changes** versus frozen Box1.2.1; static dual reviews PASS but actual game Runtime and Creator physical rollback remain `NOT_TESTED`. The real original installation and audit are archived on [Google Drive](https://drive.google.com/drive/folders/1x8dSPfgGCGgJR8y5FvPW4JhhQp7kdMNU), latest complete [Drive checkpoint](https://drive.google.com/file/d/1nREYV6XkXaGRWsaRNotPc1oQY9CZghjgtit0MLyBPtw/view). `aslain_catalogs/index.json.latestReviewedUpstream` records this without duplicating any binary or declaring native #08 files uploaded to GitHub. The sole engineering Master/Drive same-ID mirror synchronization for #08 is still **DOC_SYNC_PENDING**, not claimed complete.

**GitHub retention (owner 2026-10-24 onward):** keep every actively required manufacturing/audit/recovery tool and at most `CURRENT_LOCKED + IMMEDIATELY_PREVIOUS_LOCKED` formal released version per module; no extra TEST binary. Earlier rollback copies already archived Drive-only need not be re-uploaded just to fill the optional previous slot. Once a third formal lock is expressly approved and safely backed up, remove the oldest GitHub version only after consumer/rollback verification. Drive keeps all generations and source evidence.

## Current release set (formal versions unchanged by Aslain-only updates)

- Manager Public: **2.1.6 FINAL_LOCK**
  - `manager/NAJXBox_Manager.exe`
  - legacy alias: `manager/CNBOX_Manager.exe`
  - SHA256: `26bf0e7a0365095245a71752d22dd1139f681b9455e68bc40b72027ec5adcce8`
- Manager Creator (GitHub engineering distribution only): **2.1.6 FINAL_LOCK**
  - SHA256: `4df6364253fcd1f1873c8acc8ac4c7ea47e45a0c51a52735a06ace3f2426a64a`
  - Formal manifest: `manager/NAJXBox_Manager_2.1.6_RELEASE_MANIFEST.json`; 2.1.5 previous-version binaries are **Google Drive HISTORY/ROLLBACK only** (original bundle ID `1javYKKLXdio5-mZcugVTsBSXb50mmmv3`); they are not an additional GitHub release.
- Box (current WoT 2.4.1.0): **1.2.1 FINAL_LOCK** — exact owner-authorized T03 
  - Public **standalone** install does **not** require Aslain; #05 is manufacturing provenance only; XVM `13.1.0.0098`
  - immutable original ZIP: `payloads/2.4.1.0/unified/CNBOX_PAYLOAD_1.2.1.zip`
  - SHA256: `ce38abf70ca43b443810a375d067367622b5cac96263511cef63c0b9186be36f` (14,608,734 bytes / 533 entries)
  - changed only XVM Prestige/JX horizontal 1px helper and two Loading vehicle-format XCs from 1.2.0; **530/533 payload members byte-identical, map/minimap unchanged**
  - functional manifest: `manifests/2.4.1.0/CNBOX_FUNCTIONAL_R34_R2F9_R6_1.2.1.json`; Manager standalone/Creator `channel.json` each list all 533 exact files
  - [Google Drive FINAL exact copy](https://drive.google.com/file/d/1sEPP-51tvNUPBWJ6KtpTAewwNCtB8WUM/view); owner explicitly accepted formal lock without new T03 game Runtime; **NOT_TESTED, not fabricated PASS**
- Box **1.2.0 HISTORY / Drive-only rollback**: original SHA `70c756fe280c76dbac2655d5bb1428d635f0e004f52d480dc5acf8fbb9ee1fe9`; archived original [Drive package](https://drive.google.com/file/d/1g6T6pSm97lmF7-L7VIcHAgV1X03rKvWd/view) and historical manifest `manifests/2.4.1.0/CNBOX_FUNCTIONAL_R34_R2F9_R6.json`. Prior GitHub Public R6 ZIP is no longer a live download after 2026-10-22 storage cleanup.
- Box 1.1.0 / WoT 2.4.0.2 — **GOOGLE DRIVE HISTORY ONLY, NOT A THIRD GITHUB LOCKED VERSION**.
  - Exact original 534-file SHA256: `b40c9b17b8ac42806b857bb92120e2ebc36148498ff28a6c046d72890d7406f2`.
  - [Verified original Drive archive](https://drive.google.com/file/d/1hVtQ1Bw-lop9yAxo-yh2UFRT5GtYca0l/view); the original GitHub live ZIP was demoted and removed under owner Issue #19.
  - No Box1.1.0 row remains in `channel.json`; WoT2.4.0.2 users cannot obtain this old Box through current GitHub update channel; recover exact file from Drive history when needed.
- MoE / 打环 (WoT 2.4.1.0): **1.3.1 FINAL_LOCK / GitHub+Drive frozen, consolidated Gitee pending**
  - payload: `moe/1.3.1/NAJXBOX_MoE_1.3.1_WOT_2.4.1.0_FINAL_LOCK.zip`
  - SHA256: `e003fbeaf1b015ae03fae521878a3ddf8a0e26dbb3b0c247fce3cfe1a6f34d2f`
  - Previous WoT 2.4.0.2 **MoE 1.3.0** SHA `5d6bcfc871fdec58f8c8195eaecb0b9351a980ea917f3c054c0de66ebb134e19` is preserved [Drive history only](https://drive.google.com/file/d/1Js4yxjtZYLxXCOB2uDdlpDJxGhFWqhNC/view); not available through current GitHub `channel.json`.
- Language / 汉化 (WoT 2.4.1.0): **1.1.3 FINAL_LOCK**
  - payload: `language/NAJXBOX_LANGUAGE_1.1.3_WOT_2.4.1.0_FINAL_LOCK_20261014.zip`
  - SHA256: `592a0822cd3547f09772bb16ea70ddb2cc21da381c3a548ed6eae624e67afcc5`
  - Previous **1.1.2** / WoT 2.4.0.2 is [Drive-only rollback history](https://drive.google.com/file/d/1XMphhS629sCCvS_BLjJYwwr6EW7rRfkm/view), not a current GitHub package.

Environment boundaries (module-specific; not one universal WoT version):
- Box **1.2.1** targets WoT `2.4.1.0`, XVM `13.1.0.0098`, and is **independent of Aslain being installed**; source Aslain `#05` is provenance only. Box **1.2.0** is retained solely as the original Google Drive same-WoT-generation rollback. Earlier Aslain migration failures remain engineering HISTORY, not the current release. Box **1.1.0** on WoT `2.4.0.2` / XVM `13.1.0.0093` is Drive-only historical evidence, no longer offered through this live channel.
- MoE 1.3.1 and Language 1.1.3 target WoT `2.4.1.0`; older-client MoE 1.3.0 is retained in Google Drive HISTORY, not the current online channel.
- For exact client matching and package selection, `channel.json` is the machine install authority; do not infer compatibility from a single global version line.

## Historical 2026-10-22 single-CURRENT cleanup — superseded retention policy

**Historical record, not current retention permission.** The following 2026-10-22 cleanup took place under its then-current rule; the current 2026-10-24/25 owner policy above permits at most two formal locked versions while preserving all tools. On 2026-10-22 the rule applied to **Box, MoE, Language, Manager+Creator** as GitHub **CURRENT_LOCKED=1, PREVIOUS_LOCKED=0, ACTIVE_TEST=0 per module**; its 2026-10-20 `2LOCK+1TEST` predecessor was superseded. Manager Public/Creator 2.1.6 builds and necessary stable aliases belong to a single formal version identity, not competing releases. **All previous locks, test candidates, original binary archives, success/failure/retry history, runtime and rollback evidence live on Google Drive**.

GitHub `channel.json` is authority **only for currently installable content**. Its live versions are Box **1.2.1**, Manager+Creator **2.1.6**, MoE **1.3.1**, Language **1.1.3**. Previous client releases **may not auto-install from this live channel**; use the exact original files and SHA256 recorded in Google Drive history for restoration. Current frozen ZIP/EXE bytes were not changed as part of storage cleanup. All archived files remain traceable in [storage Issue #19](https://github.com/modanbo/NA-BOX/issues/19) and private Master §9A.

Source, provenance/manifest histories and meaningful engineering proof can remain as non-installable text references on GitHub; they do not create another live release. Removing Git paths reduces the working tree, **not necessarily historic Git objects, LFS or Actions quota**. Cleanup requires original Drive SHA/ZIP CRC + Git blob verification, live consumer URL audit, two independent reviews and reverse readback.

## Gitee

Gitee `modanbo/cnbox-updates-cn` is a **Public-only exact mirror** rebuilt from the current GitHub channel. Creator/private/history/test/evidence content is forbidden there.

GitHub Public Manager/Creator **2.1.6** is the established current release. The last independently verified Gitee Public-only snapshot may still carry **Manager 2.1.5** and older Box/MoE bytes; it is a **deferred, nonblocking backup mirror**, not current GitHub release authority. Gitee synchronization for the current WoT241 release set is not proved; closing Box 1.2.1, MoE 1.3.1, and Language 1.1.3 on GitHub/Drive does **not** prove any newer Gitee synchronization. Keep Gitee status DEFERRED until its independent exact Public-only allowlist and hash readback passes. Never push Creator or test artifacts to Gitee.

For release identity, always use `channel.json` and `CURRENT_RELEASE_INDEX.md`.

## Aslain native catalog history storage — 2026-10-20

The complete prior `aslain_catalogs` tree (45 exact original Git files / 28,124,611 original bytes, including WoT 2.4.0.2 histories and current-generation comparison/audit artifacts) was archived as an immutable, manifest-verified Google Drive [HISTORY/REFERENCE package](https://drive.google.com/file/d/1bmJQUJbG0s4ZoWG7x9nBQBp4OC3KuWos/view), SHA256 `65c3f3c4a78f8579c2e9057a7215ea3e744729624ea5f6bbcb054692ead75985`. Its inner source ZIP contains the exact original 45 files plus per-path SHA256, Git blob SHA1, size, and source commit metadata; every member was independently read back and verified.

The current GitHub `aslain_catalogs` native catalog has a preserved #07 entry and older comparison entries; its lightweight `index.json.latestReviewedUpstream` separately records the complete #08 Drive audit. A metadata pointer is not an EXE/native archive and does not trigger any CNBOX release update. The original and complete #08 bytes live in Drive. Archived paths are **not** live download endpoints. Module CURRENT_RELEASE binaries, rollback payloads, `channel.json` and Manager stable URLs remain unchanged. See private engineering Master §9A and Issue #19.

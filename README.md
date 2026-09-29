# NAJXBox Updates — Public Distribution

Role: **CURRENT PUBLIC DISTRIBUTION ONLY**

This repository is the stable Public update endpoint for NAJXBox Manager and legacy CNBOX-compatible clients.

Source of truth for machine update logic: `channel.json`.

## Current Public release

### Manager Public
- Version: **2.1.1**
- Canonical binary: `manager/NAJXBox_Manager.exe`
- Legacy compatibility alias: `manager/CNBOX_Manager.exe`
- SHA256: `35adb9af766646293eba0633b7bc7bc1901e0fa45383e35f39221ad7e7d2287b`

Creator 2.1.1 remains an engineering distribution on GitHub/Google Drive and is **not mirrored to Public Gitee**.

### Box
- Public release: **2401-R34-R2F9-UNIFIED-R5**
- Status: **FINAL_LOCK**
- WoT: **2.4.0.1**
- XVM: **13.1.0.0090**
- Package: `payloads/2.4.0.1/unified/CNBOX_PAYLOAD_R5.zip`
- SHA256: `cf8ce97f9e33ee013c0383d2c940d5ee37985749bd8e12e299b13a8ad70829b6`
- Current Creator/Aslain compatibility lock: **2401-09-R34-R2F9-FINAL_LOCK-R5**

Aslain #09 is a low-risk dependency rebase. The Public R5 Box payload remains byte-identical; no Public Box rebuild was required.

### Language
- Pack version: **1.1**
- Package: `language/CNBOX_LANGUAGE_PACK_2.4.0.1.zip`
- SHA256: `e6fd0b357617bf4267a3b29458f9b810be9717d907d929c5c8c0fcb5b098a3a7`

### MoE / 打环
- Version: **1.2.9**
- Status: **FINAL_LOCK / Runtime PASS**
- Package: `moe/1.2.9/NAJXBOX_MoE_INDEPENDENT_1.2.9_LOBBY_LIFECYCLE_OWNER_REBUILD_WOT_2.4.0.1.zip`
- Package SHA256: `624276153a5b65bd74eda0009ffba23061cb0d111ccb78dd7f1328b1f100136c`
- Installed WOTMOD SHA256: `fc81ac5bf0baa92339a179373835cd0246be78fb9cddde44d239270f5c8035b2`

Runtime closure covers initial Hangar, repeated vehicle switching, non-Hangar return, server-switch recreation/restoration, and post-server-switch vehicle switching.

## Public Gitee mirror

Gitee repository: `modanbo/cnbox-updates-cn`

The Gitee repository is rebuilt as an **exact current Public-only mirror**. Every mirror run removes obsolete files first, then writes only the current allowlisted release surface.

Current Gitee surface:
- `README.md`
- `CURRENT_RELEASE_INDEX.md`
- `channel.json`
- `manager/CNBOX_Manager.exe`
- `payloads/2.4.0.1/unified/CNBOX_PAYLOAD_R5.zip`
- `manifests/2.4.0.1/CNBOX_FUNCTIONAL_R34_R2F9_R5.json`
- `language/CNBOX_LANGUAGE_PACK_2.4.0.1.zip`
- `moe/1.2.9/NAJXBOX_MoE_INDEPENDENT_1.2.9_LOBBY_LIFECYCLE_OWNER_REBUILD_WOT_2.4.0.1.zip`
- `moe/1.2.9/manifest.json`
- `moe/1.2.9/SHA256SUMS.txt`

No Creator binary, engineering history, RC, TEST_CANDIDATE, or obsolete release files belong in the Public Gitee mirror.

## Authority

For update decisions, always use `channel.json`.
For a human-readable snapshot, use `CURRENT_RELEASE_INDEX.md`.

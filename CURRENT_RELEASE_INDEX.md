# NAJXBox Current Public Release Index

Updated: 2026-09-29

| Component | Current Public authority | Status | SHA256 |
|---|---|---|---|
| Manager Public | 2.1.1 — `manager/CNBOX_Manager.exe` | FINAL | `35adb9af766646293eba0633b7bc7bc1901e0fa45383e35f39221ad7e7d2287b` |
| Box | 2401-R34-R2F9-UNIFIED-R5 — `payloads/2.4.0.1/unified/CNBOX_PAYLOAD_R5.zip` | FINAL_LOCK | `cf8ce97f9e33ee013c0383d2c940d5ee37985749bd8e12e299b13a8ad70829b6` |
| Box manifest | `manifests/2.4.0.1/CNBOX_FUNCTIONAL_R34_R2F9_R5.json` | FINAL_LOCK | `0a10f9a97864b92260cd1eae520aec13097b9f010a71f53b47f177bb342e494a` |
| Language | 1.1 — `language/CNBOX_LANGUAGE_PACK_2.4.0.1.zip` | FINAL | `e6fd0b357617bf4267a3b29458f9b810be9717d907d929c5c8c0fcb5b098a3a7` |
| MoE / 打环 | 1.2.9 — `moe/1.2.9/NAJXBOX_MoE_INDEPENDENT_1.2.9_LOBBY_LIFECYCLE_OWNER_REBUILD_WOT_2.4.0.1.zip` | FINAL_LOCK / RUNTIME_PASS | `624276153a5b65bd74eda0009ffba23061cb0d111ccb78dd7f1328b1f100136c` |

## Compatibility pointers

- WoT: **2.4.0.1**
- XVM: **13.1.0.0090**
- Public Box install identity: **2401-R34-R2F9-UNIFIED-R5**
- Current Creator/Aslain compatibility identity: **2401-09-R34-R2F9-FINAL_LOCK-R5**
- Aslain #09 did not change Public Box bytes.

## Distribution boundary

- Gitee is **Public-only**.
- Creator Manager 2.1.1 stays on GitHub/Google Drive and is not mirrored to Gitee.
- Old Manager, Box, MoE, RC, TEST_CANDIDATE, and engineering-history files are removed from the Gitee working tree during every exact-mirror rebuild.
- `channel.json` is the machine authority; this file is the human-readable release index.

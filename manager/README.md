# NAJXBox Manager - Public Files

Current authority: ../channel.json.

Current version: **2.1.1**

Validated authority:
- exact source head: efb0f6d5ef2ec6bb538f1c3387066b9b6bd7e8eb
- self-hosted build run: 36506936627 - SUCCESS
- BO real-client cache gate run: 36506936510 - SUCCESS
- Public SelfTest: PASS
- Creator SelfTest: PASS
- startup stale published MoE cache refresh: PASS on real client
- full Check Updates WoT/Aslain/XVM/Box/language/MoE reconciliation: PASS on real client
- failed online refresh preserves last successful display only while stale action authority remains cleared: PASS
- Creator integration-test and MoE-test picker directories survive refresh/restart state: PASS

Live GitHub files:
- CNBOX_Manager.exe - legacy stable Public compatibility alias.
- NAJXBox_Manager.exe - canonical stable Public alias.
- NAJXBox_Manager_v2.1.1.exe - current versioned Public binary.
- CNBOX_Manager_Creator.exe - legacy Creator compatibility alias.
- NAJXBox_Manager_Creator.exe - canonical Creator alias.
- NAJXBox_Manager_Creator_v2.1.1.exe - current versioned Creator binary.

Public Manager SHA256: 35adb9af766646293eba0633b7bc7bc1901e0fa45383e35f39221ad7e7d2287b
Creator Manager SHA256: 04ce46f68feee330bc97b22e574c08e8bc401bb04afacda587b9c6a6ca639244

Public Box binding remains **2401-R34-R2F9-UNIFIED-R5**.
Public MoE binding remains **1.2.9 FINAL_LOCK**.

2.1.1 cache semantics:
- “检查更新” still performs the complete existing reconciliation pipeline, including official/latest Aslain detection.
- starting a new explicit check immediately invalidates stale install/update/repair authority.
- the last successful dashboard text stays visible while refresh runs and when an online refresh fails.
- stale display history never grants install/update/repair authority.
- a successful startup lightweight language/MoE refresh replaces and persists stale published labels.
- Creator remembers integration-test ZIP and MoE-test ZIP folders independently.

Distribution boundary:
- Public self-update channel points to the Public Manager.
- Creator remains available on GitHub/Drive for engineering use.
- This publication does not modify Box, MoE payload, language/font payload, or unrelated Aslain plugins.

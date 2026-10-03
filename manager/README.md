# NAJXBox Manager - Public Files

Current authority: ../channel.json.

Current version: **2.1.2**

Frozen release authority:
- exact engineering baseline: R8 `1ff9b52317cef6847165ce0c56a55089391cb0ea`
- exact final-candidate source head: `b7ba1d1c062cc433ee37af4d84d232e6e12970ba`
- final frozen build run: `37080651689`
- Review 1: PASS
- Review 2: PASS
- Public Build/SelfTest/UI: PASS
- Creator Build/SelfTest/UI: PASS
- Defender: NOT_REQUIRED / NON_BLOCKING (ISSUE-071)
- exact Public VirusTotal report identity: MATCH
- exact Public SHA256: `9e6b7ca804ce4d71ba659246c8b1dfe03b1e12a26d65bbc39a4e6217538626c2`
- exact Creator SHA256: `af37ac23811cd5a4787ab18ee7543f8766b0d748220ca1ed69d800dde1328c6f`
- no rebuild after Run #11 freeze

VirusTotal release note:
- the exact Public EXE report showed Microsoft ML detection `Trojan:Win32/Wacatac.B!ml`;
- the project owner explicitly authorized release of this exact frozen SHA after review;
- this is recorded as an exact-SHA release exception and is not represented as a zero-detection result.

Live GitHub files:
- `CNBOX_Manager.exe` - legacy stable Public compatibility alias.
- `NAJXBox_Manager.exe` - canonical stable Public alias.
- `NAJXBox_Manager_v2.1.2.exe` - current versioned Public binary.
- `CNBOX_Manager_Creator.exe` - legacy Creator compatibility alias.
- `NAJXBox_Manager_Creator.exe` - canonical Creator alias.
- `NAJXBox_Manager_Creator_v2.1.2.exe` - current versioned Creator binary.

Public Manager SHA256: `9e6b7ca804ce4d71ba659246c8b1dfe03b1e12a26d65bbc39a4e6217538626c2`
Creator Manager SHA256: `af37ac23811cd5a4787ab18ee7543f8766b0d748220ca1ed69d800dde1328c6f`

2.1.2 preserves the validated R8 functional design. Relative to exact R8, only formal version identity/self-test identity changed inside the Manager source tree; locked UI, install/update/repair/rollback, RuntimeCollector, Box, MoE and Language transaction ownership remain unchanged.

Distribution boundary:
- Public self-update channel points to the Public Manager.
- Creator remains available on GitHub/Drive for engineering use.
- This Manager publication does not modify Box, MoE payload, language/font payload, or unrelated Aslain plugins.

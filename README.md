# NAJXBox Updates — CNBOX-Updates compatibility endpoint

Role: **CURRENT PUBLIC DISTRIBUTION ONLY**

This repository is the stable update endpoint used by NAJXBox Manager and legacy compatibility clients. The repository name remains `CNBOX-Updates` intentionally so existing update URLs continue to work.

Engineering history, failed candidates, private Creator notes and long retrospectives belong in private `modanbo/NA-BOX` and Google Drive, not in this current Public README.

## Current Public authority

Source of truth: `channel.json`.

### Manager
- version: `2.0.9`
- Public SHA256: `3335f513b60b671b95f377bd14bad586bddd4cc55a809492b9d26817e8d98bd3`
- Creator SHA256: `4f220a44bc3c80fd00ef89ec8cfee3737e33e08d0935e39aef95bd892ed5552f`
- stable Public aliases: `manager/CNBOX_Manager.exe`, `manager/NAJXBox_Manager.exe`
- current versioned Public: `manager/NAJXBox_Manager_v2.0.9.exe`

Creator remains an engineering flavor on GitHub/Drive and is not mirrored to Gitee.

### Box
- Public: `2401-R34-R2F9-UNIFIED-R5`
- SHA256: `cf8ce97f9e33ee013c0383d2c940d5ee37985749bd8e12e299b13a8ad70829b6`
- WoT: `2.4.0.1`
- XVM: `13.1.0.0090`
- Creator/Aslain compatibility lock: `2401-09-R34-R2F9-FINAL_LOCK-R5`
- Aslain #09 selected-dependency LOW_RISK_REBASE did not change the 534-file R5 Public payload bytes; trigger was Aslain Mod Menu 2.0.17 -> 2.1.01, with Runtime not required for this delta.

### Language
- packVersion: `1.1`
- canonical package: `language/CNBOX_LANGUAGE_PACK_2.4.0.1.zip`
- SHA256: `e6fd0b357617bf4267a3b29458f9b810be9717d907d929c5c8c0fcb5b098a3a7`
- enhanced TahomaZH SHA256: `108e0ae0dbd7ad0330114cf082bdc33ecdae30aa6dcb3cb3b1a82dae75331b45`
- Chinese vehicle-name mode PASS / English vehicle-name mode PASS / Restore Original PASS.

### MoE / 打环
- version: `1.2.8`
- status: FINAL_LOCK / Runtime PASS
- package SHA256: `71bc51dff5e3b72d835b97f41267b2e9d6e445bd030706cc8145ef31c8966a2e`
- installed WOTMOD SHA256: `7ec910ae68d82904b22ad984a4db14f3874f5abf010ce780ab6f97cc654190cb`
- BattlePage / Error #1065 closure PASS.

## Directory roles

- `channel.json` — current machine authority
- `manager/` — current Manager aliases/versioned binaries
- `payloads/` — Public Box releases; older released payloads are rollback/history
- `language/` — current language package
- `moe/` — MoE release history + current 1.2.8
- `manifests/` — release/hash metadata

Older released Box/MoE directories may remain as rollback/history, but they are not current unless `channel.json` selects them.

## Gitee mirror

`modanbo/cnbox-updates-cn` is the exact current **Public-only** fallback mirror.

Final exact mirror closure:
- commit: `9f83864`
- push: `e6a7ac2..9f83864 main -> main`
- allowlist: 8 files
- current set: Manager Public 2.0.9 + Box R5 + language 1.1 + MoE 1.2.8
- no Creator/private/history/RC/test files

## Safety / compatibility

Published payloads and Manager binaries are SHA256-gated. Official WoT `res` is not replaced by the language layer; the enhanced font is a versioned `res_mods` overlay controlled by Manager.

Do not infer current state from an old release directory or historical package name. Always read `channel.json`.

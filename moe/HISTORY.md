# CNBOX Standalone MoE — Public Package History

This file is append-only release history for the Manager's independent MoE component.

## Update rule

Before publishing a new MoE version:
- read the internal `NA-BOX/02_TOOLS/CNBOX_MoE/HISTORY_MASTER.md`;
- compare upstream package/version/hash first;
- do not repeat full decomposition when upstream members are unchanged;
- preserve Box isolation and user drag config.

## 2026-09-21 — ProTanki 8.1.01 baseline

Pinned Aslain package:
`MarksOnGun_Gun_Marks_Calculator_a834e732.zip`

SHA256:
`3df826d272877fca504b48d968b68e4e82e7118ba7da17c27ae61c5fc24201ee`

Original ProTanki WOTMOD SHA256:
`e83eeab978e7599fb0924e01933df1c863977ee33984e2701270b23cda27a408`

The component is independent from Box and is managed by Manager install/update/uninstall state.

### 1.0.4

Payload:
`a5820434ca85f126c3dfb951fa57a03ebae88bc4300c8ad79bb7d02b0e3b32ff`

WOTMOD:
`71289c39f36c33480879c1f61bb8677229909810ba9aa30016739d7738eb6220`

Outcome:
- static structure passed;
- live user evidence showed the plugin did not display;
- this version replaced more of the Flash host/lifecycle layer than necessary.

Do not use 1.0.4 as the presentation architecture reference.

### 1.0.5 — DISPLAY_FIX_CANDIDATE

Payload:
`fbc330dfb1e7edc7eacf0bacc50991dacc40e2ff1e289a94fe7fcf4ba9c86fa1`

WOTMOD:
`b0120e0ebf5b1f4ac0f44d63fab594021d96e71cd7aabb0263db44b64a00a924`

Changes:
- original ProTanki `ProGunMarks` host restored/preserved;
- only stock `GunMarksPanelNew` is customized;
- original timeline TextFields are reused;
- `zh_sg.yml` fallback added from upstream English text bundle;
- backend calculation remains protected/original;
- original drag and persisted offset chain remains intact.

Locked battle data mapping:
- `predictedRating + deltaRating`
- `battleMovingDamage`
- `predictedMovingDamage + deltaDamage`

User drag config:
`mods/configs/protanki/gunMarksCalculator.json`

Live display verification remains the next gate before changing 1.0.5 from candidate status.

## Garage panel

The ProTanki package above contains the battle UI only. The requested garage MoE card is a separate layer and must be sourced/decomposed independently, then packaged behind the same single Manager “打环插件” option.


### 1.0.6 — GARAGE_INTEGRATION_CANDIDATE

Payload:
`80faef4b00bacc441cc68db9dd40566206149eb0f3f00718ecc6881cb34e0772`

ProTanki battle WOTMOD:
`b0120e0ebf5b1f4ac0f44d63fab594021d96e71cd7aabb0263db44b64a00a924`

CHAMPi EVV garage WOTMOD:
`47811ac68dbf4d7e2fe539a161b38d06d33a9e79f697c1007948b8f27491eee2`

Garage upstream:
- CHAMPi Expected Vehicle Values 2.05.000
- Aslain package `MarksOnGun_Expected_Vehicle_Values_2edd8787.zip`
- package SHA256 `4fcb507d6ab133b959c99fa18af5c917e98b824f7a2b0e86210db5a3df87555c`

Architecture:
- ProTanki remains the visible battle MoE owner;
- EVV supplies garage current MoE %, average damage, 65/85/95/100 thresholds and persistent Ctrl-drag;
- EVV protected backend is byte-preserved;
- EVV battle presentation is callback-compatible but intentionally blank, preventing duplicate battle panels;
- EVV garage model/JavaScript is unchanged; a CSS-only CN reference skin is appended.

Static combined-package closure: PASS.

The Manager still exposes one independent “打环插件” component. Box owns none of these files.

History rule: do not re-decompose EVV while version remains 2.05.000 and the pinned package SHA256 remains unchanged.


### 1.0.7 — GARAGE_DRAG_POSITION_FIX_CANDIDATE

Live trigger:
- 1.0.6 garage card rendered, proving model/injection alive;
- card appeared clipped at the bottom-right;
- user could not drag it.

Payload:
`7e26d95369f9929b1149412ec1952665ff9622dc28f86e7d942f178311f1cef6`

ProTanki battle core remains unchanged:
`b0120e0ebf5b1f4ac0f44d63fab594021d96e71cd7aabb0263db44b64a00a924`

CHAMPi EVV garage core:
`52ab79d3b4384433abf20dab1af63d34486f54cacf58f3ae40d67d87501d0cc8`

1.0.7 changes only EVV garage interaction:
- force `currentState.moveMode = true` after every model refresh so Ctrl+drag cannot be silently disabled by upstream settings state;
- after paint, detect a clipped/out-of-viewport `#evv2-root`;
- migrate it to a safe visible location above the vehicle carousel;
- persist the repaired location through EVV's existing `saveCurrentPosition -> savePosition` path;
- calculation/backend, ProTanki battle core, EVV garage data model, thresholds, and CN visual skin remain unchanged.

Static closure: PASS.

Runtime screenshot evidence is archived in Google Drive as:
`RUNTIME_MOE_1.0.6_GARAGE_VISIBLE_CLIPPED_DRAG_FAIL_20260923.png`.

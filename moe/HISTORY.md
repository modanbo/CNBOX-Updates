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

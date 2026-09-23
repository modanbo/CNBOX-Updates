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


### 1.0.8 — UI_REVIEW_CANDIDATE

Project-owner rule:
- finish battle + garage UI first;
- double-review after both are built;
- do not rewrite proven third-party calculation/data/event/drag/settings functions;
- CNBOX is changing presentation only.

Payload:
`d375acdc450295314dd01749bd1b2978cc33fb797987079b6bf9621dc1f2b384`

ProTanki CN UI WOTMOD:
`3201597966d72b632ec9950fc59993dc5f60a6305191b7f053fcfb5f216b53ec`

CHAMPi EVV CN garage WOTMOD:
`f388941f0036167c3587262b92e0f371521374b513410649296b821a48f20c8e`

UI target:
- battle reference measured about 154 × 98 px;
- garage reference measured about 220 × 141 px;
- battle: MoE%+delta / 本场标伤 / 平均标伤+delta;
- garage: ring + mark indicator + current%+delta / 平均标伤 / 65-85-95-100 2×2 matrix.

Function freeze:
- ProTanki protected backend byte-identical to pinned upstream;
- ProTanki `ProGunMarks` host decompiles identical before/after;
- CHAMPi EVV protected backend byte-identical to pinned upstream;
- CHAMPi `EVV2.js` byte-identical to pinned upstream;
- original EVV garage Ctrl+drag/savePosition/anchor migration remains untouched;
- 1.0.7 custom runtime drag/position patch is removed from the active source baseline.

Static review:
`STATIC_MOE_108_UI_ONLY_REVIEW_PASS`

Workflow run:
`35877692148`

The EVV visible battle panel remains presentation-neutralized solely to prevent a second battle UI; ProTanki is the single visible battle owner. This does not alter EVV calculation/model data.

1.0.8 is the new presentation architecture baseline. Future fixes must not reintroduce runtime-function wrapping without a separate, evidence-based review.


## 2026-09-23 — OFFICIAL_CN_SWF_UI_AUTHORITY

User-supplied official CN package `打环百分比插件-国服版` 2.4.0.1 was decomposed directly.

Authority hashes:
- WBP: `3eea4d9432a0e7ed0400583d2108bc4873b6e14531d576023dec2bd948c6bd16`
- `mod_mark_on_gun.wotmod`: `d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4`
- `wotassist.markongun.swf`: `06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`

Baseline correction:
- 1.0.8 remains historical evidence and is **SUPERSEDED FOR UI GEOMETRY / VISUAL AUTHORITY**.
- Do not propagate 1.0.8 guessed `154x98` / `220x140` geometry.
- Official embedded visual sizes are BATTLE `147x93` and LOBBY `210x134`.
- Official SWF has separate `MarkOnGunPanel` (LOBBY) and `MarkOnGunUI` (BATTLE) structures, normal/hover state ownership, relative sibling layout, official arrows/stars/circle/background assets, and exact text/component coordinates.

Locked future architecture:
- keep mature NA/Global calculation, events, data acquisition, drag and persisted-position code unchanged;
- implement **UI Adapter only**;
- map mature data into the official CN SWF LOBBY/BATTLE presentation instead of inventing new geometry.

Reference:
`moe/reference/CN_OFFICIAL_SWF_UI_AUTHORITY_2.4.0.1_20260923.md`


### 1.0.9 — OFFICIAL_CN_UI_REVIEW_CANDIDATE

Official UI authority:
- user-supplied CN official 2.4.0.1 SWF;
- BATTLE 147×93;
- LOBBY normal/hover 210×134;
- official arrows 6×11, stars 22×21 and relative component layout.

Architecture:
- ProTanki 8.1.01 backend, ProGunMarks host, battle events, drag and persisted offset are unchanged;
- only `GunMarksPanelNew` presentation is adapted to the official CN BATTLE structure;
- CHAMPi EVV 2.05.000 backend/model/Ctrl-drag/anchor/savePosition are unchanged;
- upstream `EVV2.js` is retained byte-for-byte as the built file prefix, with only an isolated presentation tail appended;
- the 1.0.7 custom runtime drag/position patch remains removed.

Static closure:
- workflow run `35889690717`: SUCCESS;
- `STATIC_MOE_109_UI_ONLY_REVIEW_PASS`;
- artifact digest `sha256:221ba386f7f5760eedc4456b4132d01e433e528c52a3e90649ff9f0a3aaeee7f`.

Payload:
`0cdf01752860e172ae52bcd75ad31993bf13a5698662910f76b8f699f2aa2744`

ProTanki UI WOTMOD:
`8728f3d3a15a17e98873bf4e51ae32ec96fb01053ffd119f5f276b332b24e2f4`

CHAMPi EVV garage WOTMOD:
`fc22480047e9f64e14fe5f0a38e283bfe4f7382250246b36b07ec0829968b4d6`

Status:
- branch: `work/moe-component-1.0.9-cn-official-ui`;
- static review complete;
- live WoT runtime review still required;
- do not switch the public channel to 1.0.9 before runtime closure.


#### 1.0.9 channel exposure correction

For real-game Runtime testing through the existing Manager UI, `channel.moePacks` now points to **1.0.9** on `main`.

This is **candidate exposure, not formal Runtime promotion**:
- status remains `OFFICIAL_CN_UI_REVIEW_CANDIDATE`;
- Manager/Creator can display and install 1.0.9;
- Runtime validation is still required before changing the candidate to a final/locked status.

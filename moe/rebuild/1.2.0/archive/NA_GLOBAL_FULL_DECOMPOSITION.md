# NAJXBox MoE — NA / Global Plugin Full Decomposition Record

Date: 2026-09-23
Use: data/event/formula/reference evidence for 1.2.0
Important: this does NOT authorize reinstalling the old stacks.

## 1. ProTanki Gun Marks Calculator 8.1.01

Whole package was decomposed for:
- WOTMOD file ownership;
- Flash view ownership;
- protected Python import surface;
- event/data ownership;
- settings dependencies;
- drag/cursor path;
- localization files.

Known owned areas include:
- `res/gui/flash/protanki_gunmarks_battle.swf`
- `res/scripts/client/gui/mods/mod_pro_gunmarks.pyc`
- `res/mods/protanki.gunmarks/text/*.yml`
- preview assets
- ProGunMarks host
- old/new/new-simple panel variants
- dragArea and persisted battle position flow

Protected Python core:
- Pjorion/protected backend means source-equivalent line-by-line recovery is not claimed.
- Import trace, symbols, surrounding calls, Runtime behavior, Flash contract and field semantics are archived.
- Therefore ProTanki is fully decomposed for **ownership/integration semantics**, not claimed as original source recovery.

Reference semantics retained:
- combined damage family;
- EWMA factor 2/101;
- field semantics used historically:
  - predictedRating
  - deltaRating
  - battleMovingDamage
  - predictedMovingDamage
  - deltaDamage

Runtime dependency verdict:
- REJECTED for 1.2.0.
- Reason: protected event/data owner is coupled to its own View/panels/drag/settings ecosystem.

## 2. ModsSettingsAPI 1.7.0

Owner roles:
- settings window;
- hotkeys;
- settings callbacks;
- persistence.

Verdict:
- REJECTED.
- Direct source of unwanted third-party settings ownership in earlier candidates.

## 3. ModsListAPI 1.7.9

Owner roles:
- lobby mod-list button;
- mod-list popover;
- lobby injection/integration.

Verdict:
- REJECTED.
- Not necessary for MoE math or WoT-native data.

## 4. CHAMPi Expected Vehicle Values 2.05.000

Decomposed areas:
- WOTMOD inventory;
- garage SWF;
- battle SWF;
- GameFace/JS presentation;
- protected backend import surface;
- threshold semantics;
- Ctrl-drag/savePosition behavior;
- settings dependencies.

Useful historical semantics:
- 65/85/95/100 threshold model;
- garage model organization;
- persisted positioning patterns.

Protected-core limitation:
- protected Python combines data/model/settings ownership;
- no claim of original line-by-line source recovery;
- owner boundaries and observable contract are archived.

Verdict:
- whole WOTMOD REJECTED for 1.2.0.
- Threshold data is reimplemented as NAJXBox-owned local data.

## 5. CHAMPi SettingsGUI 1.81

Owner:
- explicit CHAMPi settings UI.

Verdict:
- REJECTED.

## 6. Aslain ModMenu 2.0.17

Owner:
- garage mod menu/settings entry.

Verdict:
- REJECTED.

## 7. gambiter.guiflash 0.6.6

Critical confirmed ownership:
- Battle/Lobby runtime view lifecycle;
- `SHOW_CURSOR` / `HIDE_CURSOR`;
- draggable component behavior;
- cursor path.

This creates direct overlap with WoT native Ctrl/cursor behavior.

Verdict:
- REJECTED and permanently blocked from 1.2.0 runtime package unless a future independent requirement proves otherwise.

## 8. OpenWG GameFace 1.1.6

Role:
- GameFace integration/injection used by old EVV stack.

Verdict:
- REJECTED for current 1.2.0 Scaleform/official-CN-contract architecture.
- May only be reconsidered if a future owner proof shows a strict non-UI data dependency.

## 9. WoT-native data authority replacing third-party backends

Garage:
- current vehicle dossier
- `movingAvgDamage`
- `damageRating`
- `marksOnGun`

Battle:
- `IBattleSessionProvider.shared.personalEfficiencyCtrl`
- cumulative DAMAGE
- ASSIST_DAMAGE
- STUN
- BLOCKED_DAMAGE
- split assist reconstruction from native efficiency log / summary fallback

Important:
- 1.2.0 observes WoT-owned state after native processing.
- It does not replace `PlayerAvatar.onBattleEvents`.
- Native damage counter must continue to update.

## 10. Formula/reference authority

Current 1.2.0 math:
- `combined = own_damage + max(radio_assist, track_assist, stun_assist)`
- `EWMA_K = 2/101`
- projected moving average = old + K * (combined - old)
- damage -> percentile uses piecewise-linear interpolation over local threshold anchors

Offline tests cover:
- assist max selection;
- EWMA;
- percentile interpolation;
- stable projection fields;
- threshold parsing/cache helper behavior.

## 11. Evidence files

- `WOTMOD_OWNER_INVENTORY.json`
- `OUTER_PACKAGE_INVENTORY.json`
- `PROTANKI_IMPORT_TRACE.txt`
- `EVV_IMPORT_TRACE.txt`
- `PROTANKI_EVENT_OWNER.txt`
- `EVV_DEPENDENCY_BATTLE_HOOKS.txt`
- `META_DEPENDENCIES.txt`
- `RELATIONSHIP_MAP.md`
- `PROTECTED_DEPENDENCY_TOKENS.txt`
- `swf_symbols/`
- `packages/`

## 12. Permanent interpretation rule

“Fully decomposed” for protected NA/Global plugins means:
- package structure known;
- runtime owners known;
- dependency graph known;
- view/settings/cursor/event roles known;
- observable data contract and field semantics known;
- protected import surfaces archived;
- enough evidence exists to reproduce only the required behavior safely.

It does **not** mean the original protected Python source was recovered line-for-line.

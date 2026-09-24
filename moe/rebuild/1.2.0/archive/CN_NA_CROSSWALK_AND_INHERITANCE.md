# NAJXBox MoE 1.2.0 — CN <-> NA Crosswalk and Inheritance Rules

Date: 2026-09-23
Purpose: durable architecture decision map.

## 1. Final ownership split

### CN official plugin contributes
- visual authority;
- View/state contract;
- `as_updateData` contract;
- 210x134 garage geometry;
- 147x93 battle geometry;
- ring/stars/arrows/background assets;
- hover/normal behavior;
- drag/position interaction semantics.

### WoT NA client contributes
- garage dossier values;
- battle personal-efficiency values;
- native cursor lifecycle;
- native damage feedback processing.

### NAJXBox contributes
- one small Python core;
- formula projection;
- local threshold parser/provider;
- CN-contract adapter;
- View registration;
- simple private config;
- one WOTMOD package.

### Old third-party plugins contribute
- reference evidence only.
- They do not ship in 1.2.0.

## 2. Data crosswalk

CN contract -> 1.2.0 source:

- tank id -> current vehicle intCD / controlled battle vehicle compactDescr
- marks on gun -> dossier achievement value
- damage rating -> dossier achievement damageRating
- moving average -> dossier `movingAvgDamage`
- battle damage -> native personalEfficiencyCtrl DAMAGE total
- radio assist -> native efficiency event log/summary
- track assist -> native efficiency event log/summary
- stun assist -> native personalEfficiencyCtrl STUN
- blocked/tanking -> native personalEfficiencyCtrl BLOCKED_DAMAGE
- combined damage -> NAJXBox formula
- projected moving average -> NAJXBox EWMA 2/101
- projected percentile -> local threshold interpolation
- 65/85/95/100 -> local threshold snapshot
- position -> NAJXBox private config
- language -> client language mapping / private config override

## 3. Owner decisions

RETAIN EXACTLY AS AUTHORITY:
- official CN SWF visual contract and geometry.

REIMPLEMENT IN NAJXBOX:
- data adapter;
- formula;
- threshold read;
- config persistence;
- View registration.

READ FROM WOT NATIVE:
- garage dossier;
- personalEfficiencyCtrl;
- native cursor.

REFERENCE ONLY:
- ProTanki calculations/field semantics;
- EVV threshold/model semantics.

REJECT FROM RUNTIME:
- ProTanki WOTMOD;
- EVV WOTMOD;
- ModsSettingsAPI;
- ModsListAPI;
- CHAMPi SettingsGUI;
- Aslain ModMenu;
- GUIFlash;
- OpenWG GameFace.

## 4. Native-damage protection invariant

Forbidden:
- replacing `PlayerAvatar.onBattleEvents`;
- swallowing native event callbacks;
- intercepting DAMAGE before native controller handling;
- installing a third-party framework that owns the battle cursor/event lifecycle.

Allowed:
- reading totals from `personalEfficiencyCtrl`;
- subscribing to `onTotalEfficiencyUpdated` after native ownership remains intact.

Release gate:
- deal damage in real battle;
- WoT native damage counter must increase normally;
- failure blocks release even if MoE UI is visually correct.

## 5. Threshold invariant

Runtime:
- local read only;
- no HTTP;
- no worker-thread network fetch;
- no application-id secret;
- no battle-time cache mutation.

Update workflow:
- threshold snapshot may be refreshed out-of-game;
- provenance/version/timestamp must be recorded;
- Manager/build tooling may replace the local dataset.

## 6. Future update inheritance rules

Do NOT redo full decomposition when:
- official CN WBP/WOTMOD/SWF hashes are unchanged;
- WoT dossier fields used by 1.2.0 remain compatible;
- personalEfficiencyCtrl API/owner path remains compatible;
- third-party packages are not being reintroduced;
- Runtime evidence remains consistent.

A fresh targeted decomposition IS required when any of these changes:
- official CN SWF hash;
- WoT major/minor generation changes owner paths;
- personalEfficiencyCtrl field/event API changes;
- dossier achievement API changes;
- Scaleform/View registration API changes;
- Runtime contradicts the archived owner map;
- user chooses a new upstream UI authority.

## 7. Update procedure

Mandatory order:
1. read this archive index;
2. read GitHub `moe/HISTORY.md`;
3. read Drive MoE master history;
4. compare upstream hashes/versions/owner paths;
5. decompose only changed layers;
6. static diff;
7. Review 1;
8. Review 2;
9. build one candidate;
10. one concentrated Runtime;
11. rollback proof;
12. append result/hashes/root cause to GitHub and Drive.

## 8. Review 1 checklist

- owner map still correct;
- no rejected WOTMOD in package;
- no `PlayerAvatar.onBattleEvents` replacement;
- no cursor owner other than WoT/native official contract behavior;
- one lobby visible owner;
- one battle visible owner;
- official SWF hash exact;
- local threshold data provenance recorded;
- formula tests pass.

## 9. Review 2 checklist

- dead code / old adapters removed;
- no stale 1.1.x fallback;
- package file list minimal;
- Hash/manifest consistent;
- config persistence isolated;
- install/uninstall/rollback ownership clear;
- no third-party settings UI;
- no hidden network path;
- previous failed-version mistakes not reintroduced.

## 10. Runtime checklist

Garage:
- 210x134 official UI;
- correct current rating;
- correct average;
- 65/85/95/100 populated;
- drag/persistence.

Battle:
- 147x93 official UI;
- three rows correct;
- positive/negative deltas correct;
- Ctrl/native cursor normal;
- drag/persistence;
- native WoT damage counter increments;
- displayed MoE values update;
- no duplicate UI;
- no foreign settings/menu UI.

## 11. Historical failure inheritance

1.0.x / 1.1.x remain searchable because they prove what not to do:
- host replacement caused visibility failures;
- hard-coded locale changes caused regressions;
- GameFace adapter assumptions failed;
- `_cleanDamage` slash splitting created a deterministic 0-display bug;
- old stack coincided with WoT native damage counter remaining at 0;
- 1.1.3 did not realize its claimed CN-host architecture.

These failures must never be erased from history.

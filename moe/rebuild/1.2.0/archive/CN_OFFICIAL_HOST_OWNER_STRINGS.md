# Official CN Python host owner-string evidence

Date: 2026-09-23
Source: exact-hash official `mod_mark_on_gun.wotmod`
WOTMOD SHA256: `d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4`

Read-only string inspection of:
`res/scripts/client/gui/mods/mod_markongun.pyc`

## Framework ownership strings present

The official host contains:
- `ViewSettings`
- `WindowLayer`
- `g_entitiesFactories`
- `ScopeTemplates`
- `SFViewLoadParams`
- `IAppLoader`
- `loadView`
- `wotassist.markongun`
- `wotassist.markongun.swf`

This confirms that Scaleform View registration/loading is part of the original host architecture.

## Invasive host hooks also present

The same official host contains owner strings for:
- `PlayerAvatar.onBattleEvents`
- `newBattleEvents`
- `new_lobby_view__populate`
- `new_lobby_view__dispose`
- `new_loadView`
- `onBattleEvents`
- lobby/battle state interception helpers

These are **reference evidence only** for 1.2.0.

## 1.2.0 decision

Retain:
- ViewSettings / WindowLayer / entity-factory / SFView loading model;
- exact official SWF contract.

Reject/reimplement:
- PlayerAvatar battle-event replacement;
- lobby view populate/dispose monkey patches;
- generic loadView monkey patch;
- CN request/server/cache ownership.

1.2.0 instead uses:
- App lifecycle INITIALIZED notification;
- direct entity factory registration;
- explicit `SFViewLoadParams`;
- read-only `personalEfficiencyCtrl` observation;
- local-only thresholds.

This is a deliberate owner reduction, not an accidental omission of the original host hooks.

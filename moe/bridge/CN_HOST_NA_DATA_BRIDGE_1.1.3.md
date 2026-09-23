# NAJXBox MoE 1.1.3 — CN Contract Host + NA Data Bridge

Date: 2026-09-23  
Status: STATIC ARCHITECTURE LOCK — no Runtime publication yet

## Goal

Stop adapting two different NA presentation stacks to look like the CN official plugin.

Use the mature NA providers only as data owners and use the CN official MoE contract as the presentation/interaction authority.

No CN server/network logic is retained.

## Evidence read before design

- ProTanki 8.1.01 pinned package and hash unchanged.
- CHAMPi EVV 2.05.000 pinned package and hash unchanged.
- CN official WBP/SWF authority unchanged.
- Existing decomposition/history reused; only bridge boundaries were targeted.
- Protected NA Python providers were inspected only far enough to prove that full reverse engineering is unnecessary.

## Data owners

### Garage — CHAMPi EVV 2.05.000

Use the already-proven GameFace state boundary:
- moePercent
- moePercentDelta
- moeAVG
- moeMarks
- moe1
- moe2
- moe3
- moe4

The 1.1.1 garage 210x134 official card and its Runtime-proven interaction path are frozen for 1.1.3.

### Battle — ProTanki 8.1.01

Use the already-proven Flash boundary:
`ProGunMarks.as_setData(param1:Object)`

Direct fields:
- predictedRating
- deltaRating
- battleMovingDamage
- predictedMovingDamage
- deltaDamage

Do not decrypt or duplicate ProTanki calculation/network logic.

## CN official contract

Official SWF:
`wotassist.markongun.swf`
SHA256:
`06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`

Official data-array indices:
- 0 tank id
- 1 radio assist
- 2 track assist
- 3 stun assist
- 4 tanking
- 5 battle damage
- 6 moving average damage
- 7 current moving average damage
- 8 current battle damage
- 9 damage rating
- 10 in battle
- 11 visible
- 12 mastery/percentile dict
- 13 lobby delta
- 14 estimate dict
- 15 gun marks

Official Flash entrypoints:
- as_updateData(values, reason, setActive)
- as_loadConfig()
- savePosition()
- getPanelPosition()
- retrieveData()

The CN Python package proves UI wrapper and data/network owner are separable:
- `GunMarkerCalc` owns CN request/calculation.
- Python `MarkOnGunUI` wrapper only drives the Flash view and position/config callbacks.

Therefore CN network URLs, requestData, mastery/estimate API and CN curve dictionaries are NOT bridge dependencies.

## 1.1.3 implementation choice: Hybrid CN Contract Host

A literal transplant of the full CN Python/network package is rejected because it would add unnecessary CN-only server logic.

A full reverse engineering of the protected NA Python providers is also rejected because the finished data already crosses stable public presentation boundaries.

### Garage

Keep the Runtime-proven 1.1.1 path unchanged:
EVV currentState -> official 210x134 CN contract card.

### Battle

Replace ProTanki skin-variant presentation ownership with one CN contract battle host.

The host consumes the five finished ProTanki fields directly and presents the official 147x93 structure:
- predictedRating -> damage rating
- deltaRating -> damage-rating delta
- battleMovingDamage -> current battle damage
- predictedMovingDamage -> average mark damage
- deltaDamage -> average mark-damage delta

No MDICT / ESTIMATEDICT is needed because those CN dictionaries exist only so the CN backend can derive values that ProTanki already provides directly.

## Interaction ownership

CN official `MarkOnGunUI` interaction semantics are the authority:
- ROLL_OVER -> DRAG_OPEN cursor
- MOUSE_DOWN -> MOVE cursor + startDrag
- MOUSE_UP -> stopDrag + savePosition
- ROLL_OUT / MOUSE_OUT -> ARROW and stopDrag as appropriate

WoT native battle input remains the owner of:
default no cursor -> hold Ctrl -> cursor visible.

NAJXBox must not implement a new Ctrl hotkey.

The 1.1.3 battle host should make the visible 147x93 CN panel itself the hit/drag surface. The old invisible ProTanki dragArea must no longer be the interaction owner.

Position persistence still uses the mature ProTanki `updatePosition(offsetBattle)` callback so the user's existing config remains compatible.

## Frozen code / forbidden changes

1.1.3 must not modify:
- ProTanki Python backend or calculation.
- CHAMPi EVV Python backend/model.
- EVV garage currentState semantics.
- user config ownership.
- WoT Ctrl-key/cursor handling.
- CN network/request logic must not be introduced.

## Static gate before first Runtime

1. Garage payload bytes must equal the 1.1.1 known-good garage core.
2. ProTanki Python backend must equal pinned upstream.
3. Only battle Flash presentation/interaction bridge may differ.
4. No old/new/new-simple UI may remain reachable as visible owner.
5. Visible 147x93 panel is the mouse hit surface.
6. No NAJXBox Ctrl/key handler exists.
7. Two static review passes.
8. Only after all gates pass may channel.json expose 1.1.3.

## Runtime gate — one consolidated test

Garage:
- official 210x134 card unchanged;
- drag and position persistence unchanged.

Battle:
- hold Ctrl -> WoT cursor appears;
- official 147x93 panel visible;
- panel can be dragged directly;
- release persists position;
- next battle/restart restores position;
- five NA data fields display correctly.


# NAJXBox MoE — Official CN Plugin Full Decomposition Record

Date: 2026-09-23
Authority: user-supplied official CN package for WoT 2.4.0.1
Use: UI / view-contract / interaction authority for NAJXBox MoE 1.2.0

## 1. Provenance and exact binary chain

Recovered original upload:
- `2.4.0.1-105ad6c75b9855c6fd70c247bfa01312.wbp`
- duplicate upload with `(1)` suffix is byte-identical.

Verified chain:
- WBP size: 310025 bytes
- WBP SHA256: `3eea4d9432a0e7ed0400583d2108bc4873b6e14531d576023dec2bd948c6bd16`
- contained `Files/mod_mark_on_gun.wotmod`
- WOTMOD size: 320639 bytes
- WOTMOD SHA256: `d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4`
- contained `res/gui/flash/wotassist.markongun.swf`
- SWF size: 36170 bytes
- SWF SHA256: `06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`

The above is the only accepted CN UI binary authority.

## 2. Visible view owners

LOBBY:
- class/owner: `MarkOnGunPanel`
- normal state ID: 0
- hover state ID: 1
- exact embedded geometry: 210x134

BATTLE:
- class/owner: `MarkOnGunUI`
- normal state ID: 2
- hover state ID: 3
- exact embedded geometry: 147x93

Reserved/legacy constants:
- BATTLELONG normal ID: 4
- BATTLELONG hover ID: 5
- do not treat as active until reachability is proven.

## 3. Official embedded resources

- Lobby normal background: 210x134
- Lobby hover background: 210x134
- Battle background: 147x93
- Lobby circle: 40x40
- star light/dark: 22x21
- up/down arrow: 6x11
- font owner: `$FieldFont`

Relative `+N` x-values are semantic relative placement. The official `Utils.adjustComponentList` path uses the previous component's real textWidth/bitmap width. Do not convert these to guessed absolute positions.

## 4. Official LOBBY contract

Key visible roles:
- ring/circle
- 3 mark stars
- current damage rating %
- rating delta arrow and delta %
- average mark damage
- 65 / 85 / 95 / 100 threshold values

Locked representative placement:
- circle: x20 y24
- stars: x72/89/106 y11
- damage rating: x73 y37
- avg label/value: around x73 y61
- threshold rows: y95 and y114

Behavior:
- damage rating from `DATA_DAMAGE_RATING`
- average from `DATA_MOVING_AVG_DAMAGE`
- delta from `DATA_LOBBY_DELTA`
- stars from `DATA_MARKONGUN`
- threshold display uses 65/85/95/100 values
- ring angle = damageRating / 100 * 360

## 5. Official BATTLE contract

Three visible rows:
1. current/projected MoE percentage + delta
2. current battle mark damage
3. projected average mark damage + delta

Representative placement:
- rating x14 y14
- battle label/value y42/41
- average label/value y66/65
- arrows 6x11
- positive delta: `#3EFF99`
- negative delta: `#FF553E`

## 6. as_updateData data-array contract

The 1.2.0 adapter preserves a 16-slot array:

0 `tank_id`
1 radio assist
2 track assist
3 stun assist
4 tanking/blocked
5 battle damage
6 moving average damage
7 current/projected moving average damage
8 combined damage
9 damage rating
10 in-battle flag
11 visible flag
12 MDICT / threshold dictionary
13 lobby delta
14 ESTIMATEDICT / percentile curve
15 marks on gun

Exact adapter constants are maintained in `source/contract.py`.

## 7. Interaction semantics retained as authority

Retain:
- official normal/hover semantics;
- official panel-position contract;
- official drag/position callback contract;
- official visual assets and sizing;
- official `as_updateData` contract.

Do not retain:
- CN-specific request server;
- CN RequestCache;
- CN network ownership for MDICT/ESTIMATEDICT;
- any monkey-patch/event suppression that could interfere with WoT-native feedback.

## 8. 1.2.0 usage rule

The CN plugin is the **presentation and contract authority**, not the NA data provider.

1.2.0 must:
- host one NAJXBox-owned official-contract SWF;
- feed it WoT-native NA data;
- preserve CN geometry and behavior;
- avoid CN network/server dependencies;
- avoid old ProTanki/EVV presentation ownership.

## 9. Authority references

Primary:
- `moe/reference/CN_OFFICIAL_SWF_UI_AUTHORITY_2.4.0.1_20260923.md`
- `moe/rebuild/1.2.0/OFFICIAL_SWF_ASSET_PROVENANCE.md`

If any future extraction contradicts this file, verify the binary SHA first. A different SHA means a different upstream artifact and requires a new decomposition record rather than silently overwriting this one.

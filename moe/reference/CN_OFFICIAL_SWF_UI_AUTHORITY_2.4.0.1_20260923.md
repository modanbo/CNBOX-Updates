# NAJXBox MoE — CN official SWF UI authority

Date: 2026-09-23
Source: user-supplied `打环百分比插件-国服版`, version 2.4.0.1, author metadata `国服官方`.
Authoritative UI binary: `res/gui/flash/wotassist.markongun.swf`.

## Baseline correction

`MoE 1.0.8 UI_REVIEW_CANDIDATE` is retained as historical evidence, but it is **SUPERSEDED FOR UI GEOMETRY / VISUAL AUTHORITY**.
The estimated 1.0.8 values (`154x98` battle and about `220x140` garage) must not be propagated into future UI work.

Locked architecture:
- mature NA/Global calculation functions: unchanged
- mature events: unchanged
- mature data acquisition: unchanged
- mature drag / persisted position mechanism: unchanged
- new work: presentation adapter only
- visual/state authority: the official CN SWF LOBBY/BATTLE structure

## Provenance

- WBP SHA256: `3eea4d9432a0e7ed0400583d2108bc4873b6e14531d576023dec2bd948c6bd16`
- `mod_mark_on_gun.wotmod` SHA256: `d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4`
- `wotassist.markongun.swf` SHA256: `06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`

## Real view owners and state IDs

- LOBBY owner: `MarkOnGunPanel`
- BATTLE owner: `MarkOnGunUI`
- `LOBBY_NORMAL_ID=0`
- `LOBBY_HOVER_ID=1`
- `BATTLE_NORMAL_ID=2`
- `BATTLE_HOVER_ID=3`
- `BATTLELONG_NORMAL_ID=4`
- `BATTLELONG_HOVER_ID=5`

Six constants/classes exist. The current extracted `getViewID()` path proves LOBBY normal/hover and BATTLE normal/hover reachability. BATTLELONG is treated as reserved/legacy until a reachable path is proven.

## Exact embedded visual resources

- BATTLE normal background: **147x93**
- LOBBY normal background: **210x134**
- LOBBY hover background: **210x134**
- LOBBY circle: **40x40**
- star light/dark: **22x21**
- arrow up/down: **6x11**

The WBP preview card also matches the 210x134 LOBBY background exactly.

## LOBBY component authority

`+N` x values are relative positions. Official `Utils.adjustComponentList` computes them from the previous component's actual `textWidth` / bitmap width plus the sibling offset. Do not convert these into guessed fixed x coordinates.

| idx | role | x | y | text/resource | style |
|---:|---|---:|---:|---|---|
|0|circle/ring base|20|24|40x40 circle|dynamic ring|
|1|star1|72|11|22x21|light/dark|
|2|star2|89|11|22x21|light/dark|
|3|star3|106|11|22x21|light/dark|
|4|damage rating|73|37|`0%`|18, `#FFFCF6`|
|5|rating arrow|`+7`|39|6x11|sign state|
|6|rating delta|`+3`|39|`3.2%`|14, up `#3EFF99`, down `#FF553E`|
|7|avg label|73|61|`平均标伤`|12, white, alpha .6|
|8|avg value|`+5`|60|`0`|14, `#FFEECC`|
|9/10|65/value|19/55|95|`65%` / `--`|13|
|11/12|85/value|125/160|95|`85%` / `--`|13|
|13/14|95/value|19/54|114|`95%` / `--`|13|
|15/16|100/value|119/160|114|`100%` / `--`|13|

LOBBY behavior: DR is `DATA_DAMAGE_RATING.toFixed(2)%`; average is `DATA_MOVING_AVG_DAMAGE.toFixed(0)`; delta is `DATA_LOBBY_DELTA.toFixed(2)%`; stars use `changeStars(DATA_MARKONGUN)`; 65/85/95/100 use percentile values. The ring is dynamically drawn (fill `#FFEECC`, angle `damageRating/100*360`, radii 20/12, glow `#6B5239`). Official font owner is `$FieldFont`.

## BATTLE component authority

Visible official background is **147x93**.

| idx | role | x | y | text/resource | style |
|---:|---|---:|---:|---|---|
|0|damage rating|14|14|`{DR}`|18, `#FFFCF6`|
|1|DR arrow|`+7`|17|6x11|sign state|
|2|DR delta|`+3`|18|`0.00`|14|
|3|battle label|14|42|`本场标伤`|14, white, alpha .7|
|4|battle damage|`+6`|41|`0`|14, white|
|5|avg label|15|66|`平均标伤`|14, white, alpha .7|
|6|avg damage|`+6`|65|`0`|14, white|
|7|avg delta arrow|`+7`|66|6x11|sign state|
|8|avg delta|`+3`|66|`6`|14|

Positive delta color: `#3EFF99`. Negative delta color: `#FF553E`.

## NA/Global adapter mapping

Battle mapping remains the already-validated mature semantic mapping:
- `predictedRating` -> official damage rating
- `deltaRating` -> official DR arrow/delta
- `battleMovingDamage` -> official 本场标伤 value
- `predictedMovingDamage` -> official 平均标伤 value
- `deltaDamage` -> official average arrow/delta

Garage maps the existing mature garage model's current MoE %, delta, average mark damage, mark count, and 65/85/95/100 thresholds into the official LOBBY components.

**The adapter owns presentation only. It must not own or wrap calculation, data acquisition, events, mature drag, or persisted-position paths.**

## Next implementation baseline

- BATTLE: keep ProTanki 8.1.01 backend/host/drag/persistence; replace only presentation with the official 147x93 resources and component layout.
- LOBBY: keep CHAMPi EVV 2.05.000 model/data/drag/savePosition; add an isolated presentation adapter for the official 210x134 structure.
- Do not reuse 1.0.8 hand-drawn background/arrows/ring or guessed geometry.

# NAJXBox MoE 1.2.0 — Official SWF contract verdict

Date: 2026-09-23
Status: `CONTRACT_MATCH / ADAPTER_REQUIRED / NO_FORMATTED_STRING_BRIDGE`

Authority source:
- exact official SWF SHA256 `06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`;
- decompiled ActionScript archived at commit `83593e62e0868a1e0281e426e5987e6bf21235ba` under `moe/cn_official_reference/scripts/`.

## Python callback surface required by MarkOnGunUI

The official ActionScript declares and calls:
- `py_getCustomConfig`;
- `openURL`;
- `populated`;
- `savePosition`;
- `getPanelPosition`;
- `retrieveData`.

The SWF exposes:
- `as_loadConfig()`;
- `as_updateData(values:Array, reason:String, setActive:Boolean)`;
- `as_clearPercentile()`;
- `as_setMaskLobbyPanel(mask:Boolean)`;
- `as_hide()/as_show()`.

1.2.0 `source/view.py` supplies the required Python callbacks and calls the two required SWF entrypoints used by the minimal adapter:
- `as_loadConfig()` after View population;
- `as_updateData(array, reason, True)` on data refresh.

## Position contract

`Utils.loadPanelPosition()` expects:
`lobby_x,lobby_y,battle_x,battle_y`.

This matches `config.position_string()`.

Official SWF behavior:
- Battle panel calls `savePosition(true, x, y)`.
- Lobby panel calls parent `savePosition(false, x, y)`.
- Official SWF itself owns its internal startDrag/stopDrag and hover cursor presentation.

1.2.0 must not add an external GUIFlash/third-party drag framework.

## Battle data consumption — exact official behavior

Official battle display uses:
- `DATA_DAMAGE_RATING` as pre-battle/current dossier rating baseline;
- `DATA_C_DAMAGE` as current battle combined mark-damage value;
- `DATA_MOVING_AVG_DAMAGE` as pre-battle moving average;
- `DATA_C_MOVING_AVG_DAMAGE` as projected moving average;
- `DATA_ESTIMATEDICT` as the damage/percentile curve.

The SWF itself computes:
- average delta = projected moving average - original moving average;
- estimated rating from `DATA_ESTIMATEDICT` and the moving-average offset;
- rating delta = estimated rating - original rating.

Therefore:
- do NOT pass a formatted ProTanki string;
- do NOT split values such as `0/9634`;
- do NOT pre-substitute a projected rating into `DATA_DAMAGE_RATING`;
- keep `DATA_DAMAGE_RATING` as the dossier baseline and let the official contract calculate its displayed estimate.

This is the permanent prevention rule for the historical 1.1.2/1.1.3 zero-display regression.

## Lobby data consumption

Official lobby panel reads:
- `DATA_DAMAGE_RATING`;
- `DATA_MOVING_AVG_DAMAGE`;
- `DATA_LOBBY_DELTA`;
- `DATA_MDICT` 65/85/95/100;
- `DATA_MARKONGUN`.

## Cursor ownership interpretation

The official SWF changes the cursor only inside its own mouse hover/drag handlers using WoT `App.cursor`.
It does not justify installing GUIFlash or another third-party cursor lifecycle owner.

Battle Runtime still requires the WoT-native cursor path to make the panel mouse-reachable. No custom Ctrl/key hook is added by 1.2.0.

## Result

Current `contract.py` slot model is structurally compatible with the official SWF.

Remaining static gates before Runtime:
1. exact SWF staged into the one-WOTMOD build;
2. Python 2.7 bytecode build;
3. minimal package inventory audit;
4. View load/registration review;
5. Review 1;
6. Review 2.

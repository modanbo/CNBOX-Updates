# MoE 1.1.3 — NA data-owner bridge analysis summary

Date: 2026-09-23

This file intentionally keeps conclusions only. Raw protected third-party bytecode, decompiler output, and one-shot analysis workflows are not retained as project source.

## ProTanki 8.1.01

Pinned package remains:
`MarksOnGun_Gun_Marks_Calculator_a834e732.zip`
SHA256:
`3df826d272877fca504b48d968b68e4e82e7118ba7da17c27ae61c5fc24201ee`

The Python module is protected. Full reverse engineering is not required for the 1.1.3 bridge.

Stable finished-data boundary already exists at:
`ProGunMarks.as_setData(param1:Object)`

Bridge fields:
- predictedRating
- deltaRating
- battleMovingDamage
- predictedMovingDamage
- deltaDamage

These are sufficient to drive the official 147x93 battle contract directly.

## CHAMPi EVV 2.05.000

Pinned package remains:
`MarksOnGun_Expected_Vehicle_Values_2edd8787.zip`
SHA256:
`4fcb507d6ab133b959c99fa18af5c917e98b824f7a2b0e86210db5a3df87555c`

The Python module is protected by a separate wrapper. Full reverse engineering is unnecessary because the garage GameFace model already publishes the required finished state:
- moePercent
- moePercentDelta
- moeAVG
- moeMarks
- moe1
- moe2
- moe3
- moe4

## Official CN plugin separation

Targeted local analysis of the user-supplied official CN WBP proved:
- `GunMarkerCalc` owns CN-specific data/network calculation.
- Python `MarkOnGunUI` wrapper owns the Flash view bridge, position callbacks, and lifecycle.
- Flash `MarkOnGunUI.as_updateData(values, reason, setActive)` accepts a fixed data array.
- CN request URLs / MDICT / ESTIMATEDICT are data-provider concerns, not UI-host requirements.

Therefore 1.1.3 does not import CN network logic.

## Architecture decision

Do not decrypt or duplicate either mature NA algorithm.

Use finished-data boundaries:
- EVV currentState -> Runtime-proven official 210x134 garage contract.
- ProTanki as_setData -> official 147x93 battle contract.

The visible battle contract panel owns mouse interaction. WoT remains the owner of Ctrl cursor activation. Position persistence continues through the existing ProTanki updatePosition(offsetBattle) callback.

See:
`moe/bridge/CN_HOST_NA_DATA_BRIDGE_1.1.3.md`

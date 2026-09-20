# CNBOX Language Packs

This directory is the public, read-only distribution area for CNBOX Manager language payloads.

## Manager UI modes

- 汉化（中文坦克名称） — ASIA Simplified Chinese UI plus CN `*_vehicles.mo` overlay.
- 汉化（英文坦克名称） — ASIA Simplified Chinese UI while retaining ASIA/WG vehicle names.
- 恢复原始语言 — restores the exact NA language files captured by Manager before the first language change.

## Payload layout

A released ZIP must contain only:

```text
asia/res/text/lc_messages/*.mo
asia/res/gui/flash/fontconfig.xml
cn/res/text/lc_messages/*_vehicles.mo
language_pack_manifest.json
```

No executable, realm/server config, `version.xml`, `mods`, or `res_mods` content belongs in a language payload.

## Versioning / publish gate

Language payloads are bound to an exact WoT four-part version (for example `2.4.0.1`).
The public `channel.json` must not advertise a payload until its ZIP has been generated from matching NA / ASIA / CN clients, uploaded here, and its SHA-256 is fixed in the channel entry.

Current Manager source baseline: v1.0.3.


## Dynamic-base mode (Manager v1.0.4+)

The published 2.4.0.1 ZIP is a reusable translation donor base, not an exact-version replacement package.

For a newer NA client, Manager:
1. saves/restores the exact current NA English language snapshot for that client generation;
2. parses the current NA .mo files as the skeleton;
3. merges matching ASIA translations by exact msgid/key;
4. leaves new/unmatched NA keys in English;
5. optionally overlays only CN vehicle-name base + _short keys.

This means NA may update before ASIA/CN. A newer donor refresh only needs to contribute newly available translations; old donor content remains usable.

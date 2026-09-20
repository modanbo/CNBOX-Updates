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

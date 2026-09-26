# NAJXBox Language Packs

Current authority: `../channel.json`.

## Current language authority

- WoT: `2.4.0.1`
- packVersion: `1.1`
- current alias: `CNBOX_LANGUAGE_PACK_2.4.0.1.zip`
- final archive copy: `CNBOX_LANGUAGE_PACK_2.4.0.1_FONT_R1_FINAL.zip`
- SHA256: `e6fd0b357617bf4267a3b29458f9b810be9717d907d929c5c8c0fcb5b098a3a7`
- enhanced TahomaZH SHA256: `108e0ae0dbd7ad0330114cf082bdc33ecdae30aa6dcb3cb3b1a82dae75331b45`
- official base-font SHA256: `5c7b7f32ffa1cc1d8cef019da5f727b43253018558ceaaaaba5ca993c69435ca`
- Runtime: Chinese vehicle names PASS / English vehicle names PASS / Restore Original PASS

## Manager UI modes

- 中文界面 + 中文坦克名 — Chinese UI + CN vehicle-name layer + enhanced TahomaZH.
- 中文界面 + 英文坦克名 — Chinese UI + English vehicle names + the same enhanced TahomaZH.
- 恢复原始语言 — removes/restores the exact NAJXBox language-owned overlay paths.

Normal use requires Manager `2.0.9+` and does not require a PowerShell font patch.

## Payload layout

A released ZIP contains:

```text
asia/res/text/lc_messages/*.mo
asia/res/gui/flash/fontconfig.xml
asia/res/gui/flash/fonts_zh_cn_sg.swf
cn/res/text/lc_messages/*_vehicles.mo
language_pack_manifest.json
```

## Enhanced font safety gates

Manager installs the whole enhanced SWF only when:

1. manifest WoT version exactly matches the selected client;
2. current official base-font SHA matches `enhancedFontBaseSha256`;
3. embedded enhanced-font SHA matches `enhancedFontSha256`.

Older donor dynamic `.mo` localization may remain usable for newer NA skeletons, but the old whole-font SWF is not carried forward across a version/base-font mismatch.

## Publication boundary

GitHub + Google Drive hold the current localization authority.

Gitee is intentionally deferred until Aslain #08 Box + localization + MoE are synchronized together and old Gitee files are removed in one exact rebuild.

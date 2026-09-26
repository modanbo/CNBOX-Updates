# NAJXBox MoE — CURRENT RUNTIME LOCK

Updated: 2026-09-26

Current formal version: **1.2.8 FINAL_LOCK**

Current package:
`NAJXBOX_MoE_INDEPENDENT_1.2.8_BATTLEPAGE_RUNTIME_FIX_WOT_2.4.0.1.zip`

SHA256:
`71bc51dff5e3b72d835b97f41267b2e9d6e445bd030706cc8145ef31c8966a2e`

Installed WOTMOD:
- path: `mods/2.4.0.1/najxbox.moe_independent_1.2.4.wotmod`
- SHA256: `7ec910ae68d82904b22ad984a4db14f3874f5abf010ce780ab6f97cc654190cb`
- embedded `meta.xml` version: `1.2.8`
- legacy internal filename remains `1.2.4` intentionally so the exact Runtime-tested bytes are preserved.

## 2026-09-26 BattlePage compatibility closure

Former Runtime failure:
`ReferenceError: Error #1065: Variable BattlePage is not defined`

1.2.8 keeps the proven 1.2.4 dossier / personalEfficiencyCtrl data-lifecycle baseline and applies the NA BattlePage compatibility guard. The formal archive is byte-for-byte identical to the exact Runtime-passed candidate; no post-Runtime recompile/repack was performed.

Real-client Runtime:
- Chinese UI + Chinese vehicle names: PASS
- Chinese UI + English vehicle names: PASS
- restored original English: PASS
- localized Runtime selects `najxbox_moe_zh.swf`: PASS
- English Runtime selects `najxbox_moe_en.swf`: PASS
- `MarkOnGunUI` init -> draw/update -> dispose observed
- live MoE values update during battle
- no new `BattlePage is not defined` / Error #1065 after 1.2.8 installation
- Box/Tier regression: PASS

## Architecture lock retained

- Official CN plugin = UI/contract/geometry authority.
- WoT NA dossier = garage data authority.
- WoT native `personalEfficiencyCtrl` = battle data authority.
- Box does not own MoE files.
- user drag-position state must survive update/reinstall/uninstall.
- failed 1.2.5 / 1.2.6 / older 1.2.7 experiments remain negative evidence only.

Future work starts from this exact 1.2.8 authority unless new Runtime evidence proves an owner change.

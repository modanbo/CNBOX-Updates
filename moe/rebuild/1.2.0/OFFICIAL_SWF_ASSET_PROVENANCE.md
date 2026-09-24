# NAJXBox MoE 1.2.0 — Official CN SWF asset provenance

Date: 2026-09-23
Status: `EXACT_AUTHORITY_ASSET_FOUND`

The original user-uploaded WBP was recovered from the ChatGPT file library:

- `2.4.0.1-105ad6c75b9855c6fd70c247bfa01312.wbp`
- duplicate upload `2.4.0.1-105ad6c75b9855c6fd70c247bfa01312(1).wbp`

Both uploaded copies are byte-identical.

## Verified hash chain

WBP:
- size: 310025 bytes
- SHA256: `3eea4d9432a0e7ed0400583d2108bc4873b6e14531d576023dec2bd948c6bd16`

Contained file:
- path: `Files/mod_mark_on_gun.wotmod`
- size: 320639 bytes
- SHA256: `d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4`

Contained official UI binary:
- path: `res/gui/flash/wotassist.markongun.swf`
- extracted size: 36170 bytes
- SHA256: `06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`

This exactly matches the authority chain already locked in:
- `moe/reference/CN_OFFICIAL_SWF_UI_AUTHORITY_2.4.0.1_20260923.md`
- `moe/rebuild/1.2.0/OWNER_VERDICT.md`

## Consequence

The prior historical-payload recovery probe result `EXACT_HASH_NOT_FOUND` remains valid for 1.0.9–1.1.3 payloads, but it no longer represents an asset blocker. The authority binary was not embedded in those derived payloads; it was preserved in the original uploaded WBP.

No ProTanki/EVV SWF may substitute for this binary.

Runtime package creation is still blocked until the authority SWF is physically staged into the single NAJXBox WOTMOD and the remaining View/package/two-review gates close.

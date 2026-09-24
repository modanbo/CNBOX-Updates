# NAJXBox MoE 1.2.0 — WOTMOD container verdict

Date: 2026-09-23
Status: `OFFICIAL_CN_CONTAINER_VERIFIED / NO_META_XML_REQUIRED`

## Exact source chain

Recovered from the original user-uploaded:
`2.4.0.1-105ad6c75b9855c6fd70c247bfa01312.wbp`

WBP SHA256:
`3eea4d9432a0e7ed0400583d2108bc4873b6e14531d576023dec2bd948c6bd16`

Contained WOTMOD:
`Files/mod_mark_on_gun.wotmod`

WOTMOD size: 320639 bytes

WOTMOD SHA256:
`d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4`

## Exact official WOTMOD members

The official CN WOTMOD contains exactly four file members:

1. `res/gui/flash/wotassist.markongun.swf`
2. `res/scripts/client/gui/mods/mod_artefact.pyc`
3. `res/scripts/client/gui/mods/mod_markongun.pyc`
4. `res/scripts/client/gui/mods/mod_mog_probe.pyc`

There is **no `meta.xml`** in the authority WOTMOD.

The official SWF hash inside this WOTMOD is:
`06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`

## Container conclusion

A WOTMOD used by this official CN plugin does not require a root `meta.xml`.

Therefore the NAJXBox 1.2.0 single-WOTMOD candidate may validly use a pure `res/` payload with no `meta.xml`, matching the authority container style.

The earlier ProTanki package containing `meta.xml` is package-specific evidence and must not be generalized into a WoT-wide requirement.

## 1.2.0 target container

Target runtime members:

- 1 exact authority SWF, renamed `res/gui/flash/najxbox_moe.swf`
- 1 local threshold snapshot at `res/mods/najxbox_moe/thresholds.json`
- 8 CPython 2.7 runtime `.pyc` files under `res/scripts/client/gui/mods/`

Expected total: **10 files**
Expected `meta.xml`: **0**
Third-party WOTMODs: **0**

This container decision is now evidence-backed by the official CN package, not an inferred convention.

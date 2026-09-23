# CNBOX / NAJXBox compatibility result — Aslain 2.4.0.1 #06

Date: 2026-09-23 (America/New_York)

## Result

Classification: **A. LOW_RISK_REBASE**

The migration-history gate was completed before this decision. The current Drive baseline pointer, master index, Aslain #05 R4 migration/review records, release records, and COMPLETE_BINARY_TEARDOWN_V2 reference were reviewed first.

Aslain #06 does not cross the current CNBOX dependency boundary:

- WoT remains `2.4.0.1 #950` for the current project generation.
- XVM remains `13.1.0.0090` at the CNBOX boundary.
- OpenWG.Common remains `2.8.2` at the CNBOX boundary.
- No locked CNBOX PlayersPanel / battle / marker / EFF / atlas / spot-death-icon lifecycle owner requires a rewrite.
- No WoT/localization generation delta was detected, so no language payload rebuild is required.

The native #05→#06 catalog diff contains four broad critical-tag matches. The internal archive audit closes the apparent player-panel risk: the existing changed members are shared Aslain helper/menu components (`Aslain Modpack Summary 1.14.0.78→1.14.0.81` and `mods_gui 3.01.01→3.01.02`) plus shared menu/static inventory additions; the actual OldSkool/CHAMPi panel owner payloads are not shown as modified. Independent diff review also found no XVM package/reference delta and no OpenWG package delta.

## Creator candidate

The already reviewed R4 candidate is therefore rebased to Aslain #06 **byte-for-byte**, without rewriting unchanged owners:

- version: `2401-06-R34-R2F9-TEST-CANDIDATE-R4`
- file: `CNBOX_ASLAIN06_TEST_CANDIDATE_R4_FINAL_RUNTIME_HANDOFF.zip`
- SHA256: `65852ab8876c415a96e02f4b46b5680fd3350f7592f290ed9adcb7b488cdcf0c`
- status: `TEST_CANDIDATE`

Review pass 1 and review pass 2 are PASS. The existing R4 synthetic install / verify / rollback proof remains applicable because the payload bytes and WoT generation are unchanged.

`RUNTIME_NOT_REQUIRED_FOR_THIS_UPSTREAM_DELTA = TRUE`

The candidate is **not** promoted to FINAL_LOCK yet because R4 itself still contains previously unproven user-visible changes (tier-font baseline isolation, adaptive long-name sizing, rebuilt yellow triangle). One normal real-game test remains required before R4 promotion; Runtime evidence is requested only if that normal game test actually fails.

The formal Creator rollback authority remains `CNBOX 2401-04-R34-R2F9-FINAL_LOCK-R1`. Public Standalone is unchanged and must not be substituted for Creator/Aslain.

## Publication closure

`channel.json` now exposes Creator Manager `2.0.3` with SHA256 `d577ff95e0dc0104728ad3a73e98f3c0370b7196e1a56fd8b65d3ee2585f988b` and the #06 R4 `TEST_CANDIDATE` metadata above. Public Manager remains `2.0.3` with SHA256 `3abdec35f6294d4ddf4066a84041ce7e362f39e50ebbe575b6a5097c97d4bbeb`.

The final UTF-8 `channel.json` byte SHA256 after the #06 metadata rebase is `bf2a20e02d364d1608b173e3966b591b74ae4ce66668b34b4a7794f8e1d2f8ca` (publication commit `c1cd0da`). The migration guard explicitly compared the restored pre-change authority against the new object and permitted only these semantic paths: `creatorManagerVersion`, `creatorManagerSha256`, `creatorTestPackage.version`, `creatorTestPackage.aslainVersion`, `creatorTestPackage.fileName`, and `creatorTestPackage.notes`. Releases, collection profile, Aslain fingerprints, language packs, and MoE packs were asserted unchanged.

A Windows PowerShell 5.1 UTF-8 read/write attempt briefly produced mojibake while preparing the channel update; it was caught during post-write verification before closure. The channel was restored from the known-good pre-change commit and regenerated with explicit UTF-8 using Python. Future JSON publication scripts must use explicit UTF-8 decoding/encoding and semantic-path guards; PowerShell 5.1 default text encoding must not be trusted for repository JSON containing non-ASCII text.

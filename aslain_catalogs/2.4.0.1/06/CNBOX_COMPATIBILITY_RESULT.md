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

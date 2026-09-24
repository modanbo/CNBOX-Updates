# NAJXBox MoE 1.2.0 — Full Decomposition Archive Index

Date: 2026-09-23
Branch: `work/moe-component-1.2.0-full-rebuild`
Status: LONG-TERM ENGINEERING ARCHIVE

This directory is the durable lookup entry for the MoE rebuild. It replaces chat-memory as the authority for future work.

## Read order

1. `CN_OFFICIAL_FULL_DECOMPOSITION.md`
   - official CN plugin provenance;
   - WBP -> WOTMOD -> SWF hash chain;
   - MarkOnGunPanel / MarkOnGunUI ownership;
   - official 210x134 lobby and 147x93 battle contract;
   - data array slots, UI resources, state IDs and interaction semantics.

2. `NA_GLOBAL_FULL_DECOMPOSITION.md`
   - ProTanki 8.1.01;
   - CHAMPi EVV 2.05.000;
   - ModsSettingsAPI / ModsListAPI / GUIFlash / Aslain ModMenu / CHAMPi SettingsGUI / OpenWG GameFace;
   - event/data/view/cursor/settings ownership;
   - protected-core limitations;
   - why each runtime dependency is rejected for 1.2.0.

3. `CN_NA_CROSSWALK_AND_INHERITANCE.md`
   - exact CN contract <-> NA/WoT-native data mapping;
   - what is retained, reimplemented, rejected, or reference-only;
   - inheritance rules for future WoT/Aslain/plugin updates;
   - when re-decomposition is required and when it is forbidden.

4. `ARTIFACT_HASH_LEDGER.md`
   - authoritative hashes and sizes;
   - source identities;
   - historical candidate hashes;
   - recovered original asset evidence.

5. Existing incident/evidence files in `moe/rebuild/1.2.0/`
   - `OWNER_VERDICT.md`
   - `DATA_FORMULA_EVIDENCE.md`
   - `WOTMOD_OWNER_INVENTORY.json`
   - `OUTER_PACKAGE_INVENTORY.json`
   - `PROTANKI_IMPORT_TRACE.txt`
   - `EVV_IMPORT_TRACE.txt`
   - `PROTANKI_EVENT_OWNER.txt`
   - `EVV_DEPENDENCY_BATTLE_HOOKS.txt`
   - `META_DEPENDENCIES.txt`
   - `RELATIONSHIP_MAP.md`
   - `PROTECTED_DEPENDENCY_TOKENS.txt`
   - `THRESHOLD_*_PROBE.txt`
   - `STATIC_GATE_VERIFY.txt`
   - `STATIC_CLOSURE_STATUS.md`
   - `OFFICIAL_SWF_ASSET_PROVENANCE.md`

## Permanent rules

- 1.1.x and earlier candidates are failure/history evidence only; they are not architecture baselines.
- Never reintroduce a rejected third-party WOTMOD because an older candidate happened to contain it.
- Never infer owner semantics from UI screenshots when exact binary or contract evidence exists.
- Never replace or hook `PlayerAvatar.onBattleEvents` in the 1.2.0 architecture.
- WoT native damage counter normal operation is a hard release gate.
- Runtime threshold access is local-read-only; no battle-time network fetch.
- The official CN SWF remains the presentation/contract authority.
- Future work must append evidence; never delete failed-version evidence.

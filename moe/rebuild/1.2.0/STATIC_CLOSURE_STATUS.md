# NAJXBox MoE 1.2.0 — Static Closure Status

Date: 2026-09-23
Branch: `work/moe-component-1.2.0-full-rebuild`
State: `STATIC_CLOSURE_IN_PROGRESS / NO_RUNTIME_PACKAGE`

## Locked runtime architecture

- one NAJXBox-owned WOTMOD;
- one Python core;
- one official-CN-contract SWF;
- local/simple position + language config;
- local threshold data only;
- no ProTanki, EVV, GUIFlash, ModsSettingsAPI, ModsListAPI, CHAMPi SettingsGUI, Aslain ModMenu, or OpenWG GameFace runtime dependency;
- battle data observes WoT-native `personalEfficiencyCtrl`;
- never replace or swallow `PlayerAvatar.onBattleEvents`;
- WoT native damage counter is a hard Runtime release gate.

## Static corrections in this continuation

1. Removed runtime threshold networking/threading/cache-write ownership.
2. Added threshold local-only tests.
3. Restored the executable test runner after detecting a runner-regression while extending tests.
4. Added native-damage observer-only gate.
5. Added rejected-framework source gate.
6. Added one-lobby/one-battle view-owner and no-cursor-owner gate.
7. Added exact-hash historical SWF recovery probe.

## Official SWF gate

Expected authoritative binary:
- logical runtime name: `najxbox_moe.swf`;
- authority source name: `wotassist.markongun.swf`;
- SHA256: `06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851`;
- Battle geometry: 147x93;
- Garage geometry: 210x134.

Recovery rule:
- historical payloads may be searched recursively;
- filename is not evidence;
- only the exact SHA256 match is acceptable;
- no reconstructed/adapted ProTanki or EVV SWF may substitute for the authority binary.

## Remaining blockers before first Runtime package

- exact official SWF asset available in the branch;
- core CI confirmed PASS after the latest ownership gates;
- WOTMOD layout/build script implemented around the single-owner architecture;
- packaged/local threshold snapshot with recorded provenance/version;
- package audit proves rejected third-party WOTMODs are absent;
- View/SWF contract verified against the recovered official binary;
- Review 1 PASS;
- Review 2 PASS.

Until all items close: **do not produce a Runtime package and do not expose 1.2.0 through Manager.**

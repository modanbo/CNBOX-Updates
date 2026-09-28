# NAJXBox MoE 1.2.9 — Lobby Visibility Route Re-Audit

Date: 2026-09-28
Role: EVIDENCE / NEGATIVE-PATH CLOSURE / DO NOT PROMOTE

## Authority read before this audit
- Current MoE authority: 1.2.8 FINAL_LOCK
- Package SHA256: 71bc51dff5e3b72d835b97f41267b2e9d6e445bd030706cc8145ef31c8966a2e
- Installed WOTMOD SHA256: 7ec910ae68d82904b22ad984a4db14f3874f5abf010ce780ab6f97cc654190cb
- 1.2.4 remains the proven garage-data / Lobby-lifecycle lineage.
- 1.2.5/1.2.6/old 1.2.7 remain negative evidence only.
- Official CN plugin remains UI / contract / lifecycle-behavior authority.
- ProTanki / EVV remain reference-only and must not become runtime owners again.

## Runtime results that invalidate the R1-R4 route
R1:
- Enter Hangar: panel flashes briefly, then disappears.
- Root symptom: window-count model treated normal Hangar windows as blockers.

R2:
- First selected vehicle shows panel.
- Selecting another vehicle makes panel disappear.
- Root symptom: active SUB_VIEW alias gating is sensitive to normal Hangar vehicle/view churn.

R3:
- Enter Hangar and switching vehicles works.
- Leave to another UI and return to Hangar: panel remains hidden.
- Root symptom: return lifecycle was not closed.

R4:
- Return-path patch still failed Runtime.
- Verdict: stop incremental Wulf/window-manager patching.

All R1-R4 are negative evidence only. No candidate from this interval may be used as a future baseline.

## Exact 1.2.8 bytecode audit
An exact CPython-2.7 disassembly was produced from the formal 1.2.8 WOTMOD, not from an archived source approximation.

Critical finding:

`_MoeView._apply_hangar_visibility(self, attempt)`

- second argument is a retry-attempt counter;
- method reads `self._hangar_visible`;
- method does not interpret the argument as visibility;
- it calls `as_showLobbyPanel()` or `as_hideLobbyPanel()` according to `self._hangar_visible`;
- retry callbacks increment `attempt + 1`.

But the exact 1.2.8 external helper does:

`fn(bool(visible))`

Therefore the external helper is not actually passing a visibility value into a visibility setter. Treating this call as the visibility owner was a structural mistake.

The exact 1.2.8 helper also uses:

`visible = bool(sid and 'hangar' in sid)`

which is a reduced approximation, not the exact official-CN route contract.

## Exact official CN host audit
The pinned official CN WBP was redownloaded and hash-verified:
- WBP SHA256: 3eea4d9432a0e7ed0400583d2108bc4873b6e14531d576023dec2bd948c6bd16
- mod_mark_on_gun.wotmod SHA256: d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4

The protected host still exposes enough code-object names/constants to prove its lifecycle model.

### new_updateVisibleRoute
Code-object names include:
- getNonEmptyEnteredStates
- first
- STATE_ID
- g_gunMarkerCalc.inBattle
- g_gui.setMaskLobbyPanelS
- g_gui.showLobbyPanelS
- g_gui.hideLobbyPanelS

Exact route constant:
`subScope/subLayer/hangar/{root}`

Logged branches:
- "in battle or loading hangar ... invoke setMaskLobbyPanelS(False) and showLobbyPanelS"
- "not in battle and not loading hangar ... invoke setMaskLobbyPanelS(True) and hideLobbyPanelS"

Therefore the original host uses exact route semantics plus persistent mask. It does not use substring `'hangar' in sid`.

### Hangar lifecycle
Original host also contains:
- new_hangar__populate
- new_hangar___updateAll
- new_hangar___vehicleLoaded
- new_hangar__dispose
- new_hangar_onEscape
- new_lobby_view__populate
- new_lobby_view__dispose

`new_hangar__dispose` references `hangarDisposedS`, matching Flash `as_hangarDisposed()`.

### Additional view loading
Original host also contains `new_loadView` and an explicit set of page aliases.
This shows the original author handled a second class of UI transitions that may not be represented only by the Hangar route.

The old page-name list is evidence of the problem class, not a future-proof implementation template.

## Three-plugin structure review

### Official CN MoE
Owns:
- presentation contract;
- MarkOnGunPanel / MarkOnGunUI;
- persistent mask semantics;
- Hangar/lobby lifecycle behavior.

This is the only relevant lifecycle authority for the present bug.

### ProTanki 8.1.01
Owns:
- battle panel and BattleDisplayable lifecycle;
- drag/settings/presentation stack.

It is battle reference evidence only and must not be used to solve Lobby visibility.

### CHAMPi EVV 2.05.000
Owns:
- garage model/presentation lifecycle in its old GameFace stack;
- threshold/model/settings behavior.

It is garage semantic reference evidence only and must not be reintroduced for Lobby visibility.

## Corrected architecture verdict
The R1-R4 strategy added a new Wulf/window-manager visibility owner beside:
- the existing NAJXBox LobbyView state;
- the existing 1.2.8 route helper;
- the official SWF mask state.

This created competing owners and timing races.

Verdict:
**REJECT R1-R4 VISIBILITY ROUTE.**

Do not produce R5 by adding another condition.

## Next engineering step
Before another functional candidate:

1. Rebase from exact 1.2.8 FINAL_LOCK only.
2. Keep SWFs, ui.pyc, datasource, bridge, math, storage, thresholds and BattlePage bytes frozen.
3. Reconstruct one Lobby visibility owner from the official lifecycle semantics.
4. Route transitions must use the exact official Hangar route contract, not substring matching.
5. Route visibility must drive the Flash mask/show/hide contract directly; do not misuse `_apply_hangar_visibility(bool)`.
6. Return-to-Hangar keeps the proven `_on_vehicle() -> _push('vehicle-changed') -> as_updateData` refresh.
7. Overlay/fullscreen behavior must be solved as one lifecycle class, not by adding page-name fixes one at a time.
8. The next build should first be diagnostic/read-only if any current NA lifecycle owner remains uncertain.
9. No Public/Manager/channel/Gitee promotion until one concentrated Runtime closes:
   - Hangar initial display;
   - repeated vehicle switching;
   - leave/return;
   - Tech Tree / Depot;
   - overlay/fullscreen event pages;
   - battle and return;
   - no package-load error;
   - no Box/Tier regression.

Status: ROUTE RE-AUDIT COMPLETE / IMPLEMENTATION PAUSED.

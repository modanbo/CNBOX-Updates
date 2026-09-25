# NAJXBox MoE — CURRENT RUNTIME LOCK

Updated: 2026-09-25

Current package:
`NAJXBOX_MoE_INDEPENDENT_1.2.4_GARAGE_MATCH_ORIGINAL_LOBBY_RETURN_REFRESH_WOT_2.4.0.1.zip`

SHA256:
`c206018ec1c8a66266efcd3be02132c1734c2a3c7bbbe89d6baba5a5732370be`

Runtime PASS:
- Hangar display normal.
- Other Lobby pages hide the MoE panel.
- Returning to Hangar restores the panel immediately without reselecting a vehicle.

Final lifecycle chain:
- `LobbyStateMachine._LobbyStateMachine__updateVisibleRoute`
- `ServicesLocator.appLoader`
- `POP_UP_CRITERIA.VIEW_ALIAS`
- alias `NAJXBOX_MOE_INDEPENDENT_LOBBY`
- leave Hangar: `_apply_hangar_visibility(False)`
- return Hangar: `_apply_hangar_visibility(True)` then `_on_vehicle()`
- refresh: `_on_vehicle() -> _push('vehicle-changed') -> as_updateData(...)`

Failed paths retained as negative evidence:
- `LobbySimpleEvent.HANGAR_STATUS_CHANGED` absent in current client.
- `gui.app_loader.g_appLoader` import fails.
- raw alias string is invalid criteria for `containerManager.getView`.
- show-only return path does not refresh current vehicle data.
- inner WOTMOD Deflate rewrite can cause package-load rejection; preserve Stored / method 0.

Architecture lock remains unchanged:
- Official CN plugin = UI/contract/geometry/lifecycle behavior authority.
- WoT NA dossier = garage data authority.
- WoT native `personalEfficiencyCtrl` = battle data authority.
- 1.2.5+ experiments are negative evidence only unless revalidated from scratch.

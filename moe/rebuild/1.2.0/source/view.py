# -*- coding: utf-8 -*-
"""Single official-CN-contract Scaleform host for NAJXBox MoE 1.2.0."""
from frameworks.wulf import WindowLayer
from gui.Scaleform.framework import ScopeTemplates, ViewSettings, g_entitiesFactories
from gui.Scaleform.framework.entities.View import View
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.app_loader.settings import APP_NAME_SPACE
from gui.shared import EVENT_BUS_SCOPE, events, g_eventBus
from gui.shared.personality import ServicesLocator

import config
import contract
import engine
import threshold_runtime

SWF_FILE = "najxbox_moe.swf"
LOBBY_ALIAS = "NAJXBOX_MOE_LOBBY"
BATTLE_ALIAS = "NAJXBOX_MOE_BATTLE"

_setup_done = False


class _BaseMoeView(View):
    MODE = "lobby"

    def __init__(self, *args, **kwargs):
        View.__init__(self, *args, **kwargs)
        self._alive = False
        self._last_data = contract.empty_array(self.MODE == "battle")

    def _populate(self):
        View._populate(self)
        self._alive = True
        threshold_runtime.add_listener(self._on_threshold_ready)
        if self.MODE == "lobby":
            self._attach_lobby()
        else:
            self._attach_battle()
        try:
            self.flashObject.as_loadConfig()
        except Exception:
            pass
        self._push("populate")

    def _dispose(self):
        self._alive = False
        threshold_runtime.remove_listener(self._on_threshold_ready)
        if self.MODE == "lobby":
            self._detach_lobby()
        else:
            self._detach_battle()
        View._dispose(self)

    # -------- callbacks exposed to the official SWF --------

    def py_getCustomConfig(self):
        return config.language_code()

    def getPanelPosition(self):
        return config.position_string()

    def savePosition(self, is_battle, x, y):
        config.save_position(bool(is_battle), x, y)

    def retrieveData(self):
        return list(self._last_data)

    def populated(self):
        self._push("flash-populated")

    def openURL(self, url):
        # Deliberately disabled. 1.2.0 has no UI link/settings ownership.
        return

    # -------- lifecycle --------

    def _attach_lobby(self):
        try:
            from CurrentVehicle import g_currentVehicle
            g_currentVehicle.onChanged += self._on_vehicle_changed
        except Exception:
            pass

    def _detach_lobby(self):
        try:
            from CurrentVehicle import g_currentVehicle
            g_currentVehicle.onChanged -= self._on_vehicle_changed
        except Exception:
            pass

    def _attach_battle(self):
        engine.subscribe_efficiency(self._on_efficiency_updated)

    def _detach_battle(self):
        engine.unsubscribe_efficiency(self._on_efficiency_updated)

    def _on_vehicle_changed(self, *args, **kwargs):
        self._push("vehicle-changed")

    def _on_efficiency_updated(self, *args, **kwargs):
        # Read AFTER WoT's own controller has updated. No event hook/replacement.
        self._push("native-efficiency-updated")

    def _on_threshold_ready(self, threshold_key):
        if not self._alive:
            return
        try:
            state = engine.read_garage_state() if self.MODE == "lobby" else engine.read_battle_state()
        except Exception:
            state = None
        if not state:
            return

        matched = False
        try:
            matched = int(state.get("tank_id") or 0) == int(threshold_key or 0)
        except (TypeError, ValueError):
            matched = False
        if not matched:
            matched = str(state.get("vehicle_key") or "") == str(threshold_key or "")
        if matched:
            self._push("threshold-ready")

    def _push(self, reason):
        if not self._alive:
            return
        try:
            if self.MODE == "lobby":
                state = engine.read_garage_state()
                if state:
                    engine.remember_baseline(state)
                    row = threshold_runtime.get(state.get("tank_id"), state.get("vehicle_key"))
                    data = contract.lobby_array(state, row)
                else:
                    data = contract.empty_array(False)
            else:
                state = engine.read_battle_state()
                if state:
                    row = threshold_runtime.get(state.get("tank_id"))
                    data = contract.battle_array(state, row)
                else:
                    data = contract.empty_array(True)
            self._last_data = list(data)
            self.flashObject.as_updateData(self._last_data, str(reason), True)
        except Exception:
            # UI failure must never propagate into WoT battle controllers.
            pass


class NajxMoeLobbyView(_BaseMoeView):
    MODE = "lobby"


class NajxMoeBattleView(_BaseMoeView):
    MODE = "battle"


def _register(alias, cls):
    if g_entitiesFactories.getSettings(alias) is not None:
        return
    g_entitiesFactories.addSettings(ViewSettings(
        alias,
        cls,
        SWF_FILE,
        WindowLayer.WINDOW,
        None,
        ScopeTemplates.DEFAULT_SCOPE))


def _on_app_initialized(event):
    try:
        if event.ns == APP_NAME_SPACE.SF_LOBBY:
            app = ServicesLocator.appLoader.getApp(event.ns)
            if app is not None:
                app.loadView(SFViewLoadParams(LOBBY_ALIAS))
        elif event.ns == APP_NAME_SPACE.SF_BATTLE:
            app = ServicesLocator.appLoader.getApp(event.ns)
            if app is not None:
                app.loadView(SFViewLoadParams(BATTLE_ALIAS))
    except Exception:
        pass


def setup():
    global _setup_done
    if _setup_done:
        return
    _setup_done = True
    _register(LOBBY_ALIAS, NajxMoeLobbyView)
    _register(BATTLE_ALIAS, NajxMoeBattleView)
    g_eventBus.addListener(
        events.AppLifeCycleEvent.INITIALIZED,
        _on_app_initialized,
        EVENT_BUS_SCOPE.GLOBAL)

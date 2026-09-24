# -*- coding: utf-8 -*-
"""NAJXBox MoE 1.2.2 UI host."""
import logging
from frameworks.wulf import WindowLayer
from gui.Scaleform.framework import ScopeTemplates, ViewSettings, g_entitiesFactories
from gui.Scaleform.framework.entities.View import View
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.app_loader.settings import APP_NAME_SPACE
from gui.shared import EVENT_BUS_SCOPE, events, g_eventBus
from gui.shared.personality import ServicesLocator
from gui.mods.najxbox_moe_independent import bridge, datasource, storage

_logger = logging.getLogger('NAJXBox.MoE.Independent')
SWF_FILE = 'najxbox_moe.swf'
LOBBY_ALIAS = 'NAJXBOX_MOE_INDEPENDENT_LOBBY'
BATTLE_ALIAS = 'NAJXBOX_MOE_INDEPENDENT_BATTLE'
_setup_done = False
_lobby_loaded = False
_lobby_wait_bound = False

class _MoeView(View):
    MODE = 'lobby'
    def __init__(self, *args, **kwargs):
        View.__init__(self, *args, **kwargs)
        self._alive = False
        self._last = bridge.empty(self.MODE == 'battle')
    def _populate(self):
        View._populate(self)
        self._alive = True
        if self.MODE == 'lobby':
            self._bind_lobby()
        else:
            datasource.subscribe(self._on_efficiency)
        try:
            self.flashObject.as_loadConfig()
        except Exception:
            _logger.exception('as_loadConfig failed')
        self._push('populate')
    def _dispose(self):
        self._alive = False
        if self.MODE == 'lobby':
            self._unbind_lobby()
        else:
            datasource.unsubscribe(self._on_efficiency)
        View._dispose(self)
    def py_getCustomConfig(self):
        return storage.language_code()
    def getPanelPosition(self):
        return storage.position_string()
    def savePosition(self, is_battle, x, y):
        storage.save_position(bool(is_battle), x, y)
    def retrieveData(self):
        return list(self._last)
    def populated(self):
        self._push('flash-populated')
    def openURL(self, url):
        return
    def _bind_lobby(self):
        try:
            from CurrentVehicle import g_currentVehicle
            g_currentVehicle.onChanged += self._on_vehicle
        except Exception:
            pass
    def _unbind_lobby(self):
        try:
            from CurrentVehicle import g_currentVehicle
            g_currentVehicle.onChanged -= self._on_vehicle
        except Exception:
            pass
    def _on_vehicle(self, *args, **kwargs):
        self._push('vehicle-changed')
    def _on_efficiency(self, *args, **kwargs):
        self._push('native-efficiency-updated')
    def _push(self, reason):
        if not self._alive:
            return
        try:
            state = datasource.garage_state() if self.MODE == 'lobby' else datasource.battle_state()
            if state:
                thresholds = storage.thresholds_for(state.get('tank_id'), state.get('vehicle_key'))
                data = bridge.lobby(state, thresholds) if self.MODE == 'lobby' else bridge.battle(state, thresholds)
            else:
                data = bridge.empty(self.MODE == 'battle')
            self._last = list(data)
            self.flashObject.as_updateData(self._last, str(reason), True)
        except Exception:
            _logger.exception('push failed: mode=%s reason=%s', self.MODE, reason)

class LobbyView(_MoeView):
    MODE = 'lobby'

class BattleView(_MoeView):
    MODE = 'battle'

def _register(alias, cls):
    if g_entitiesFactories.getSettings(alias) is None:
        g_entitiesFactories.addSettings(ViewSettings(alias, cls, SWF_FILE, WindowLayer.WINDOW, None, ScopeTemplates.DEFAULT_SCOPE))

def _detach_waiter():
    global _lobby_wait_bound
    if not _lobby_wait_bound:
        return
    try:
        from CurrentVehicle import g_currentVehicle
        g_currentVehicle.onChanged -= _try_load_lobby
    except Exception:
        pass
    _lobby_wait_bound = False

def _try_load_lobby(*args, **kwargs):
    global _lobby_loaded
    if _lobby_loaded:
        _detach_waiter()
        return
    try:
        from CurrentVehicle import g_currentVehicle
        if not g_currentVehicle.isPresent():
            return
        app = ServicesLocator.appLoader.getApp(APP_NAME_SPACE.SF_LOBBY)
        if app is None:
            return
        _lobby_loaded = True
        _detach_waiter()
        app.loadView(SFViewLoadParams(LOBBY_ALIAS))
    except Exception:
        _logger.exception('deferred lobby load failed')

def _arm_lobby_waiter():
    global _lobby_wait_bound
    try:
        from CurrentVehicle import g_currentVehicle
        if not _lobby_wait_bound:
            g_currentVehicle.onChanged += _try_load_lobby
            _lobby_wait_bound = True
        _try_load_lobby()
    except Exception:
        _logger.exception('failed to arm lobby waiter')

def _on_app_initialized(event):
    try:
        if event.ns == APP_NAME_SPACE.SF_LOBBY:
            _arm_lobby_waiter()
        elif event.ns == APP_NAME_SPACE.SF_BATTLE:
            app = ServicesLocator.appLoader.getApp(event.ns)
            if app is not None:
                app.loadView(SFViewLoadParams(BATTLE_ALIAS))
    except Exception:
        _logger.exception('app initialization failed')

def setup():
    global _setup_done
    if _setup_done:
        return
    _setup_done = True
    _register(LOBBY_ALIAS, LobbyView)
    _register(BATTLE_ALIAS, BattleView)
    g_eventBus.addListener(events.AppLifeCycleEvent.INITIALIZED, _on_app_initialized, EVENT_BUS_SCOPE.GLOBAL)

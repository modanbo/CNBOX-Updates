# -*- coding: utf-8 -*-
"""Read-only WoT data sources. Never replaces native battle event handlers."""

def _safe_int(fn, default=0):
    try:
        return int(fn())
    except Exception:
        return int(default)

def _session_provider():
    try:
        from helpers import dependency
        from skeletons.gui.battle_session import IBattleSessionProvider
        return dependency.instance(IBattleSessionProvider)
    except Exception:
        return None

def _dossier_state(int_cd, vehicle_key=''):
    if not int_cd:
        return None
    try:
        from helpers import dependency
        from skeletons.gui.shared import IItemsCache
        from dossiers2.ui.achievements import MARK_ON_GUN_RECORD, ACHIEVEMENT_BLOCK
        items = dependency.instance(IItemsCache).items
        dossier = items.getVehicleDossier(int(int_cd))
        if dossier is None:
            return None
        stats = dossier.getTotalStats()
        achievement = stats.getAchievement(MARK_ON_GUN_RECORD)
        marks = _safe_int(lambda: achievement.getValue(), 0)
        try:
            rating = float(achievement.getDamageRating() or 0.0)
        except Exception:
            rating = 0.0
        moving_avg = _safe_int(
            lambda: dossier.getRecordValue(ACHIEVEMENT_BLOCK.TOTAL, 'movingAvgDamage'), 0)
        return {
            'tank_id': int(int_cd),
            'vehicle_key': str(vehicle_key or ''),
            'marks': marks,
            'percentile': rating,
            'moving_avg': moving_avg,
        }
    except Exception:
        return None

def garage_state():
    try:
        from CurrentVehicle import g_currentVehicle
        if not g_currentVehicle.isPresent():
            return None
        item = g_currentVehicle.item
        return _dossier_state(int(item.intCD), str(item.name or ''))
    except Exception:
        return None

def _battle_vehicle_context():
    try:
        import BigWorld
        provider = _session_provider()
        shared = provider.shared if provider is not None else None
        vehicle_state = shared.vehicleState if shared is not None else None
        vehicle_id = int(vehicle_state.getControllingVehicleID() or 0) if vehicle_state is not None else 0
        if not vehicle_id:
            return 0, ''
        arena = BigWorld.player().arena
        info = arena.vehicles.get(vehicle_id) if arena is not None else None
        descr = info.get('vehicleType') if info else None
        if descr is None:
            return 0, ''
        return int(descr.type.compactDescr), str(descr.type.name or '')
    except Exception:
        return 0, ''

def _efficiency_ctrl():
    provider = _session_provider()
    shared = provider.shared if provider is not None else None
    return shared.personalEfficiencyCtrl if shared is not None else None

def _assist_split(ctrl):
    track = 0
    radio = 0
    try:
        import BattleFeedbackCommon
        from gui.battle_control.battle_constants import PERSONAL_EFFICIENCY_TYPE as PE
        event_type = BattleFeedbackCommon.BATTLE_EVENT_TYPE
        rows = ctrl.getLoogedEfficiency(PE.ASSIST_DAMAGE) or []
        for row in rows:
            kind = _safe_int(lambda: row.getBattleEventType(), 0)
            damage = _safe_int(lambda: row.getDamage(), 0)
            if kind == event_type.TRACK_ASSIST:
                track += damage
            elif kind == event_type.RADIO_ASSIST:
                radio += damage
    except Exception:
        pass
    return track, radio

def battle_state():
    int_cd, vehicle_key = _battle_vehicle_context()
    if not int_cd:
        return None
    ctrl = _efficiency_ctrl()
    if ctrl is None:
        return None
    try:
        from gui.battle_control.battle_constants import PERSONAL_EFFICIENCY_TYPE as PE
        damage = _safe_int(lambda: ctrl.getTotalEfficiency(PE.DAMAGE), 0)
        assist_total = _safe_int(lambda: ctrl.getTotalEfficiency(PE.ASSIST_DAMAGE), 0)
        stun = _safe_int(lambda: ctrl.getTotalEfficiency(PE.STUN), 0)
        blocked = _safe_int(lambda: ctrl.getTotalEfficiency(PE.BLOCKED_DAMAGE), 0)
    except Exception:
        return None
    track, radio = _assist_split(ctrl)
    if track + radio < assist_total:
        radio += assist_total - (track + radio)
    return {
        'tank_id': int_cd,
        'vehicle_key': vehicle_key,
        'baseline': _dossier_state(int_cd, vehicle_key),
        'damage': damage,
        'radio_assist': radio,
        'track_assist': track,
        'stun_assist': stun,
        'blocked': blocked,
    }

def subscribe(callback):
    ctrl = _efficiency_ctrl()
    if ctrl is None:
        return False
    try:
        ctrl.onTotalEfficiencyUpdated += callback
        return True
    except Exception:
        return False

def unsubscribe(callback):
    ctrl = _efficiency_ctrl()
    if ctrl is None:
        return
    try:
        ctrl.onTotalEfficiencyUpdated -= callback
    except Exception:
        pass

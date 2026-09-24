# -*- coding: utf-8 -*-
"""WoT runtime data reader for NAJXBox MoE 1.2.0.

This module is deliberately READ-ONLY with respect to WoT battle feedback.
It does NOT hook/replace PlayerAvatar.onBattleEvents.
"""
try:
    long
except NameError:
    long = int

_BASELINES = {}


def _safe(callable_obj, default=None):
    try:
        return callable_obj()
    except Exception:
        return default


def _safe_int(callable_obj, default=0):
    try:
        return int(callable_obj())
    except Exception:
        return int(default)


def _current_vehicle_int_cd():
    try:
        from CurrentVehicle import g_currentVehicle
        if not g_currentVehicle.isPresent():
            return 0
        return int(g_currentVehicle.item.intCD)
    except Exception:
        return 0


def read_garage_state():
    """Return current garage MoE dossier values or None."""
    int_cd = _current_vehicle_int_cd()
    if not int_cd:
        return None
    try:
        from CurrentVehicle import g_currentVehicle
        from helpers import dependency
        from skeletons.gui.shared import IItemsCache
        from dossiers2.ui.achievements import MARK_ON_GUN_RECORD, ACHIEVEMENT_BLOCK

        items = dependency.instance(IItemsCache).items
        dossier = items.getVehicleDossier(int_cd)
        if dossier is None:
            return None
        stats = dossier.getTotalStats()
        achievement = stats.getAchievement(MARK_ON_GUN_RECORD)

        marks = _safe_int(lambda: achievement.getValue(), 0)
        percentile = float(_safe(lambda: achievement.getDamageRating(), 0.0) or 0.0)
        moving_avg = _safe_int(
            lambda: dossier.getRecordValue(ACHIEVEMENT_BLOCK.TOTAL, "movingAvgDamage"), 0)

        state = {
            "tank_id": int_cd,
            "vehicle_key": str(g_currentVehicle.item.name or ""),
            "marks": marks,
            "percentile": percentile,
            "moving_avg": moving_avg,
        }
        _BASELINES[int_cd] = dict(state)
        return state
    except Exception:
        return None


def remember_baseline(state):
    if not state:
        return
    try:
        int_cd = int(state.get("tank_id") or 0)
    except Exception:
        return
    if int_cd:
        _BASELINES[int_cd] = dict(state)


def baseline_for(int_cd):
    try:
        return dict(_BASELINES.get(int(int_cd), {})) or None
    except Exception:
        return None


def _session_provider():
    try:
        from helpers import dependency
        from skeletons.gui.battle_session import IBattleSessionProvider
        return dependency.instance(IBattleSessionProvider)
    except Exception:
        return None


def battle_vehicle_int_cd():
    """Return the currently controlled player's vehicle intCD, or 0."""
    try:
        import BigWorld
        provider = _session_provider()
        if provider is None or provider.shared is None:
            return 0
        vehicle_state = provider.shared.vehicleState
        if vehicle_state is None:
            return 0
        vehicle_id = int(vehicle_state.getControllingVehicleID() or 0)
        if not vehicle_id:
            return 0
        arena = BigWorld.player().arena
        info = arena.vehicles.get(vehicle_id) if arena is not None else None
        descr = info.get("vehicleType") if info else None
        return int(descr.type.compactDescr) if descr is not None else 0
    except Exception:
        return 0


def _efficiency_ctrl():
    provider = _session_provider()
    if provider is None or provider.shared is None:
        return None
    return provider.shared.personalEfficiencyCtrl


def _read_assist_split_log(ctrl):
    """Return (track, radio) from WoT's own personal-efficiency event log."""
    try:
        from gui.battle_control.battle_constants import PERSONAL_EFFICIENCY_TYPE as PE
        import BattleFeedbackCommon
        event_type = BattleFeedbackCommon.BATTLE_EVENT_TYPE
        entries = ctrl.getLoogedEfficiency(PE.ASSIST_DAMAGE)
        if not entries:
            return 0, 0
        track = 0
        radio = 0
        for entry in entries:
            kind = _safe_int(lambda: entry.getBattleEventType(), 0)
            damage = _safe_int(lambda: entry.getDamage(), 0)
            if kind == event_type.TRACK_ASSIST:
                track += damage
            elif kind == event_type.RADIO_ASSIST:
                radio += damage
        return track, radio
    except Exception:
        return 0, 0


def _read_assist_split_summary():
    """Whole-battle summary fallback; reads only, never mutates native feedback."""
    try:
        from gui.battle_control.battle_constants import FEEDBACK_EVENT_ID
        provider = _session_provider()
        feedback = provider.shared.feedback if provider and provider.shared else None
        if feedback is None:
            return 0, 0
        evt = feedback.getCachedEvent(FEEDBACK_EVENT_ID.DAMAGE_LOG_SUMMARY)
        if evt is None:
            return 0, 0
        track = _safe_int(
            lambda: getattr(evt, "_BattleSummaryFeedbackEvent__trackAssistDamage"), 0)
        radio = _safe_int(
            lambda: getattr(evt, "_BattleSummaryFeedbackEvent__radioAssistDamage"), 0)
        return track, radio
    except Exception:
        return 0, 0


def read_battle_state():
    """Read cumulative battle values from WoT's native efficiency controller."""
    int_cd = battle_vehicle_int_cd()
    if not int_cd:
        return None
    ctrl = _efficiency_ctrl()
    if ctrl is None:
        return None

    try:
        from gui.battle_control.battle_constants import PERSONAL_EFFICIENCY_TYPE as PE
        damage = _safe_int(lambda: ctrl.getTotalEfficiency(PE.DAMAGE), 0)
        assist = _safe_int(lambda: ctrl.getTotalEfficiency(PE.ASSIST_DAMAGE), 0)
        stun = _safe_int(lambda: ctrl.getTotalEfficiency(PE.STUN), 0)
        blocked = _safe_int(lambda: ctrl.getTotalEfficiency(PE.BLOCKED_DAMAGE), 0)
    except Exception:
        return None

    track_log, radio_log = _read_assist_split_log(ctrl)
    track_sum, radio_sum = _read_assist_split_summary()
    track = max(track_log, track_sum)
    radio = max(radio_log, radio_sum)

    # If the split is temporarily unavailable, preserve the native merged assist total
    # without double-counting it: place the remainder in radio for combined-damage math.
    split_total = track + radio
    if assist > split_total:
        radio += assist - split_total

    vehicle_key = ""
    try:
        import BigWorld
        provider = _session_provider()
        vehicle_id = int(provider.shared.vehicleState.getControllingVehicleID() or 0)
        info = BigWorld.player().arena.vehicles.get(vehicle_id)
        descr = info.get("vehicleType") if info else None
        vehicle_key = str(descr.type.name or "") if descr is not None else ""
    except Exception:
        vehicle_key = ""

    return {
        "tank_id": int_cd,
        "vehicle_key": vehicle_key,
        "damage": damage,
        "assist": assist,
        "radio_assist": radio,
        "track_assist": track,
        "stun_assist": stun,
        "blocked": blocked,
        "baseline": baseline_for(int_cd),
    }


def subscribe_efficiency(callback):
    """Subscribe to native controller updates; return True when armed."""
    try:
        ctrl = _efficiency_ctrl()
        if ctrl is None:
            return False
        if callback not in ctrl.onTotalEfficiencyUpdated:
            ctrl.onTotalEfficiencyUpdated += callback
        return True
    except Exception:
        try:
            ctrl.onTotalEfficiencyUpdated += callback
            return True
        except Exception:
            return False


def unsubscribe_efficiency(callback):
    try:
        ctrl = _efficiency_ctrl()
        if ctrl is not None:
            ctrl.onTotalEfficiencyUpdated -= callback
    except Exception:
        pass

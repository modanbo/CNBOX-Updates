# -*- coding: utf-8 -*-
"""Official-CN SWF data contract adapter for NAJXBox MoE 1.2.0."""
import json

import formula

DATA_TANK_ID = 0
DATA_RADIO_ASSIST = 1
DATA_TRACK_ASSIST = 2
DATA_STUN_ASSIST = 3
DATA_TANKING = 4
DATA_BATTLE_DAMAGE = 5
DATA_MOVING_AVG_DAMAGE = 6
DATA_C_MOVING_AVG_DAMAGE = 7
DATA_C_DAMAGE = 8
DATA_DAMAGE_RATING = 9
DATA_INBATTLE = 10
DATA_VISIBLE = 11
DATA_MDICT = 12
DATA_LOBBY_DELTA = 13
DATA_ESTIMATEDICT = 14
DATA_MARKONGUN = 15


def _json(obj):
    return json.dumps(obj, separators=(",", ":"), sort_keys=True)


def percentile_damage_curve(tank_id, thresholds):
    """Expand WG percentile anchors into the 0..100 damage curve expected by CN SWF."""
    anchors = [(0.0, 0.0)]
    for pct, damage in (thresholds or {}).items():
        try:
            p = float(pct)
            d = float(damage)
        except (TypeError, ValueError):
            continue
        if p > 0 and p <= 100 and d > 0:
            anchors.append((p, d))
    anchors.sort()

    curve = {"tank_id": int(tank_id or 0)}
    if len(anchors) < 2:
        return curve

    for pct in range(0, 101):
        p = float(pct)
        value = None
        for idx in range(1, len(anchors)):
            p0, d0 = anchors[idx - 1]
            p1, d1 = anchors[idx]
            if p <= p1:
                if p1 <= p0:
                    value = d1
                else:
                    value = d0 + (p - p0) / (p1 - p0) * (d1 - d0)
                break
        if value is None:
            value = anchors[-1][1]
        curve[str(pct)] = int(round(value))
    return curve


def mark_threshold_dict(tank_id, thresholds):
    result = {"tank_id": int(tank_id or 0)}
    for pct in (65, 85, 95, 100):
        try:
            value = int((thresholds or {}).get(pct, 0))
        except (TypeError, ValueError):
            value = 0
        if value > 0:
            result[str(pct)] = value
    return result


def lobby_array(state, thresholds, lobby_delta=0.0):
    if not state:
        return empty_array(False)
    tank_id = int(state.get("tank_id") or 0)
    avg = int(state.get("moving_avg") or 0)
    rating = float(state.get("percentile") or 0.0)
    marks = int(state.get("marks") or 0)
    data = [0] * 16
    data[DATA_TANK_ID] = tank_id
    data[DATA_MOVING_AVG_DAMAGE] = avg
    data[DATA_C_MOVING_AVG_DAMAGE] = avg
    data[DATA_DAMAGE_RATING] = rating
    data[DATA_INBATTLE] = False
    data[DATA_VISIBLE] = True
    data[DATA_MDICT] = _json(mark_threshold_dict(tank_id, thresholds))
    data[DATA_LOBBY_DELTA] = float(lobby_delta or 0.0)
    data[DATA_ESTIMATEDICT] = _json(percentile_damage_curve(tank_id, thresholds))
    data[DATA_MARKONGUN] = marks
    return data


def battle_array(battle_state, thresholds):
    if not battle_state:
        return empty_array(True)
    baseline = battle_state.get("baseline") or {}
    tank_id = int(battle_state.get("tank_id") or 0)
    pre_avg = int(baseline.get("moving_avg") or 0)
    pre_pct = float(baseline.get("percentile") or 0.0)
    marks = int(baseline.get("marks") or 0)

    damage = int(battle_state.get("damage") or 0)
    radio = int(battle_state.get("radio_assist") or 0)
    track = int(battle_state.get("track_assist") or 0)
    stun = int(battle_state.get("stun_assist") or 0)
    blocked = int(battle_state.get("blocked") or 0)

    combined = formula.combined_damage(damage, radio, track, stun)
    projected = formula.projected_moving_average(pre_avg, combined)

    data = [0] * 16
    data[DATA_TANK_ID] = tank_id
    data[DATA_RADIO_ASSIST] = radio
    data[DATA_TRACK_ASSIST] = track
    data[DATA_STUN_ASSIST] = stun
    data[DATA_TANKING] = blocked
    data[DATA_BATTLE_DAMAGE] = damage
    data[DATA_MOVING_AVG_DAMAGE] = pre_avg
    data[DATA_C_MOVING_AVG_DAMAGE] = projected
    data[DATA_C_DAMAGE] = combined
    data[DATA_DAMAGE_RATING] = pre_pct
    data[DATA_INBATTLE] = True
    data[DATA_VISIBLE] = bool(tank_id and baseline)
    data[DATA_MDICT] = _json(mark_threshold_dict(tank_id, thresholds))
    data[DATA_LOBBY_DELTA] = 0.0
    data[DATA_ESTIMATEDICT] = _json(percentile_damage_curve(tank_id, thresholds))
    data[DATA_MARKONGUN] = marks
    return data


def empty_array(in_battle):
    data = [0] * 16
    data[DATA_INBATTLE] = bool(in_battle)
    data[DATA_VISIBLE] = False
    data[DATA_MDICT] = "{}"
    data[DATA_ESTIMATEDICT] = "{}"
    return data

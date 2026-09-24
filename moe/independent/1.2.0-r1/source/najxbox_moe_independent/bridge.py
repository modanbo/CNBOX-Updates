# -*- coding: utf-8 -*-
"""Adapter from independent NA data sources to the official CN 16-slot SWF contract."""
import json

from gui.mods.najxbox_moe_independent import mathcore

TANK_ID = 0
RADIO_ASSIST = 1
TRACK_ASSIST = 2
STUN_ASSIST = 3
TANKING = 4
BATTLE_DAMAGE = 5
MOVING_AVG = 6
CURRENT_MOVING_AVG = 7
CURRENT_DAMAGE = 8
DAMAGE_RATING = 9
IN_BATTLE = 10
VISIBLE = 11
MDICT = 12
LOBBY_DELTA = 13
ESTIMATEDICT = 14
MARKS_ON_GUN = 15

def _json(value):
    return json.dumps(value, separators=(',', ':'), sort_keys=True)

def threshold_dict(tank_id, thresholds):
    result = {'tank_id': int(tank_id or 0)}
    for pct in (65, 85, 95, 100):
        try:
            value = int((thresholds or {}).get(pct, 0))
        except (TypeError, ValueError):
            value = 0
        if value > 0:
            result[str(pct)] = value
    return result

def damage_curve(tank_id, thresholds):
    anchors = [(0.0, 0.0)]
    for pct, damage in (thresholds or {}).items():
        try:
            p = float(pct)
            d = float(damage)
        except (TypeError, ValueError):
            continue
        if 0.0 < p <= 100.0 and d > 0.0:
            anchors.append((p, d))
    anchors.sort()
    result = {'tank_id': int(tank_id or 0)}
    if len(anchors) < 2:
        return result
    for raw_pct in range(101):
        pct = float(raw_pct)
        value = None
        for idx in range(1, len(anchors)):
            p0, d0 = anchors[idx - 1]
            p1, d1 = anchors[idx]
            if pct <= p1:
                value = d1 if p1 <= p0 else d0 + (pct - p0) / (p1 - p0) * (d1 - d0)
                break
        if value is None:
            value = anchors[-1][1]
        result[str(raw_pct)] = int(round(value))
    return result

def empty(in_battle):
    data = [0] * 16
    data[IN_BATTLE] = bool(in_battle)
    data[VISIBLE] = False
    data[MDICT] = '{}'
    data[ESTIMATEDICT] = '{}'
    return data

def lobby(state, thresholds):
    if not state:
        return empty(False)
    tank_id = int(state.get('tank_id') or 0)
    avg = int(state.get('moving_avg') or 0)
    data = [0] * 16
    data[TANK_ID] = tank_id
    data[MOVING_AVG] = avg
    data[CURRENT_MOVING_AVG] = avg
    data[DAMAGE_RATING] = float(state.get('percentile') or 0.0)
    data[IN_BATTLE] = False
    data[VISIBLE] = True
    data[MDICT] = _json(threshold_dict(tank_id, thresholds))
    data[LOBBY_DELTA] = 0.0
    data[ESTIMATEDICT] = _json(damage_curve(tank_id, thresholds))
    data[MARKS_ON_GUN] = int(state.get('marks') or 0)
    return data

def battle(state, thresholds):
    if not state:
        return empty(True)
    baseline = state.get('baseline') or {}
    if not baseline:
        return empty(True)
    tank_id = int(state.get('tank_id') or 0)
    own = int(state.get('damage') or 0)
    radio = int(state.get('radio_assist') or 0)
    track = int(state.get('track_assist') or 0)
    stun = int(state.get('stun_assist') or 0)
    blocked = int(state.get('blocked') or 0)
    pre_avg = int(baseline.get('moving_avg') or 0)
    combined = mathcore.combined_damage(own, radio, track, stun)
    projected = mathcore.projected_average(pre_avg, combined)

    data = [0] * 16
    data[TANK_ID] = tank_id
    data[RADIO_ASSIST] = radio
    data[TRACK_ASSIST] = track
    data[STUN_ASSIST] = stun
    data[TANKING] = blocked
    data[BATTLE_DAMAGE] = own
    data[MOVING_AVG] = pre_avg
    data[CURRENT_MOVING_AVG] = projected
    data[CURRENT_DAMAGE] = combined
    data[DAMAGE_RATING] = float(baseline.get('percentile') or 0.0)
    data[IN_BATTLE] = True
    data[VISIBLE] = True
    data[MDICT] = _json(threshold_dict(tank_id, thresholds))
    data[LOBBY_DELTA] = 0.0
    data[ESTIMATEDICT] = _json(damage_curve(tank_id, thresholds))
    data[MARKS_ON_GUN] = int(baseline.get('marks') or 0)
    return data

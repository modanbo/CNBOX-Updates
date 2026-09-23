# -*- coding: utf-8 -*-
"""Pure MoE math for NAJXBox 1.2.0.

No BigWorld/WoT imports are allowed in this module.
Compatible with Python 2.7 and Python 3.
"""

EWMA_K = 2.0 / 101.0
PERCENTILE_ANCHORS = (20, 40, 55, 65, 75, 85, 95, 100)
REQUIRED_ANCHORS = (65, 85, 95, 100)


def combined_damage(own_damage, radio_assist, track_assist, stun_assist):
    """WG MoE combined-damage contribution for the current battle.

    Assistance types are alternatives, not additive: use the largest one.
    """
    own = max(0.0, float(own_damage or 0.0))
    radio = max(0.0, float(radio_assist or 0.0))
    track = max(0.0, float(track_assist or 0.0))
    stun = max(0.0, float(stun_assist or 0.0))
    return own + max(radio, track, stun)


def projected_moving_average(pre_battle_average, battle_combined):
    """100-period EMA projection used by WoT MoE."""
    old = max(0.0, float(pre_battle_average or 0.0))
    cur = max(0.0, float(battle_combined or 0.0))
    return EWMA_K * cur + (1.0 - EWMA_K) * old


def _normalized_points(thresholds):
    """Return sorted (damage, percentile) points, including the implicit origin."""
    points = [(0.0, 0.0)]
    if not isinstance(thresholds, dict):
        return points
    for pct, damage in thresholds.items():
        try:
            p = float(pct)
            d = float(damage)
        except (TypeError, ValueError):
            continue
        if p <= 0.0 or p > 100.0 or d <= 0.0:
            continue
        points.append((d, p))
    points.sort(key=lambda item: (item[0], item[1]))

    # Same-damage anchors must never create a divide-by-zero segment.
    dedup = []
    for damage, pct in points:
        if dedup and damage == dedup[-1][0]:
            if pct > dedup[-1][1]:
                dedup[-1] = (damage, pct)
        else:
            dedup.append((damage, pct))
    return dedup


def percentile_for_damage(damage, thresholds):
    """Piecewise-linear damage -> percentile mapping over WG's anchor table."""
    d = max(0.0, float(damage or 0.0))
    points = _normalized_points(thresholds)
    if len(points) < 2:
        return None

    if d <= points[0][0]:
        return points[0][1]

    for idx in range(1, len(points)):
        d0, p0 = points[idx - 1]
        d1, p1 = points[idx]
        if d <= d1:
            if d1 <= d0:
                return p1
            ratio = (d - d0) / (d1 - d0)
            return p0 + ratio * (p1 - p0)

    return min(100.0, points[-1][1])


def project(pre_battle_average, pre_battle_percentile,
            own_damage, radio_assist, track_assist, stun_assist,
            thresholds):
    """Return the complete battle projection as a plain dict."""
    combined = combined_damage(own_damage, radio_assist, track_assist, stun_assist)
    avg = projected_moving_average(pre_battle_average, combined)
    pct = percentile_for_damage(avg, thresholds)
    if pct is None:
        pct = float(pre_battle_percentile or 0.0)
    base = float(pre_battle_percentile or 0.0)
    return {
        "combined_damage": combined,
        "projected_average": avg,
        "projected_percentile": pct,
        "percentile_delta": pct - base,
        "average_delta": avg - float(pre_battle_average or 0.0),
    }


def has_required_thresholds(thresholds):
    if not isinstance(thresholds, dict):
        return False
    for pct in REQUIRED_ANCHORS:
        try:
            if int(thresholds.get(pct, 0)) <= 0:
                return False
        except (TypeError, ValueError):
            return False
    return True

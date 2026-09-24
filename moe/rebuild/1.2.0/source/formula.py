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

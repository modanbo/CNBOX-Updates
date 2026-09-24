# -*- coding: utf-8 -*-
"""Pure math for the independent NAJXBox MoE candidate."""
EMA_K = 2.0 / 101.0

def combined_damage(own_damage, radio_assist, track_assist, stun_assist):
    own = max(0.0, float(own_damage or 0.0))
    assists = [
        max(0.0, float(radio_assist or 0.0)),
        max(0.0, float(track_assist or 0.0)),
        max(0.0, float(stun_assist or 0.0)),
    ]
    return own + max(assists)

def projected_average(old_average, current_combined):
    old = max(0.0, float(old_average or 0.0))
    cur = max(0.0, float(current_combined or 0.0))
    return old + EMA_K * (cur - old)

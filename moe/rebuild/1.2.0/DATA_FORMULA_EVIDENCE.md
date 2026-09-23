# MoE 1.2.0 — data formula evidence

## Official / observed semantics

WG official documentation states that Marks of Excellence are based on combined damage: own damage plus assisted damage, and compares the vehicle result to recent server-wide performance.

CN official plugin metadata proves these battle buckets are tracked independently:
- DAMAGE
- RADIO_ASSIST
- TRACK_ASSIST
- STUN_ASSIST
- TANKING

The CN calculation object stores:
- battleDamage
- movingAvgDamage
- c_movingAvgDamage
- c_damage
- damageRating

Its calc() code object contains the numeric constant:
`0.019801980198019802`

This is exactly:
`2 / (100 + 1)`

## Working formula for offline verification

Do not ship until test vectors prove the mapping.

Likely combined battle value:
`combined = own_damage + max(radio_assist, track_assist, stun_assist)`

Candidate EMA:
`predicted_moving_avg = moving_avg + (2/101) * (combined - moving_avg)`

The implementation must keep the raw buckets separately so assist-selection logic can be corrected without changing event collection.

## Explicitly excluded guesses

- Do not use blocked/tanking damage as MoE combined damage unless separate proof requires it.
- Do not sum radio + track + stun assistance; double-counting is possible.
- Do not infer current battle damage by splitting formatted strings such as `0/9634`.
- Do not derive 65/85/95/100 from a percentage formula; use an external threshold database.

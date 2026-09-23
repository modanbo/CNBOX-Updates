# MoE 1.2.0 source/reference attribution

NAJXBox 1.2.0 is being rewritten as a single independent WOTMOD.

## Wargaming / World of Tanks

The runtime reads official WoT dossier and battle-controller data and may use the
Wargaming public API method `wot/tanks/mastery` for MoE percentile anchors.

## spoter / marksOnGunExtended

Public source used as an independent behavior cross-check for:
- own damage + max(radio, track, stun) combined damage;
- EWMA coefficient 2/(100+1);
- historical safe-hook ordering (original handler first).

Repository:
https://github.com/spoter/spoter-mods

No spoter UI/settings framework is a runtime dependency of NAJXBox 1.2.0.

## 14th_ua / MoE Calculator (drizzer14)

Public source used as an architecture/API cross-check for:
- dossier reads of marks / damageRating / movingAvgDamage;
- reading native personalEfficiencyCtrl instead of intercepting PlayerAvatar battle events;
- official Wargaming `wot/tanks/mastery` percentile anchors;
- piecewise-linear damage-to-percent mapping.

Repository:
https://github.com/drizzer14/moe-calculator

Its license permits free modification/redistribution with author credit and source link.
NAJXBox keeps this attribution even where the final implementation is independently
written from the documented behavior.

No OpenWG GameFace or other bundled dependency from that project is required by the
target NAJXBox 1.2.0 architecture.

# Legacy Python percentile projection removal

Date: 2026-09-23
Status: REFERENCE ONLY

Removed from `source/formula.py` during Review 2:
- `_normalized_points`
- `percentile_for_damage`
- `project`
- `has_required_thresholds`
- related Python percentile anchor constants.

Reason:
The exact official CN SWF contract owns the battle percentage display and delta calculation. Python 1.2.0 only needs to provide:
- current battle combined mark damage;
- projected moving average using EWMA 2/101;
- the threshold/curve contract payload.

Keeping a second Python-side projected-percentile implementation created two owners for the same visible result and had no Runtime caller. It was therefore dead code and a future divergence risk.

The official SWF behavior is documented in:
- `OFFICIAL_SWF_CONTRACT_VERDICT.md`
- `archive/CN_OFFICIAL_FULL_DECOMPOSITION.md`

Do not reintroduce a Python-side displayed-percentile owner unless the official SWF contract is deliberately replaced.

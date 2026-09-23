# -*- coding: utf-8 -*-
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(__file__))
sys.path.insert(0, os.path.join(ROOT, "source"))

import formula
import wgapi


def close(a, b, eps=1e-9):
    assert abs(a - b) <= eps, (a, b)


def test_combined_damage_uses_max_assist():
    close(formula.combined_damage(1000, 200, 350, 300), 1350.0)


def test_ema_constant_and_projection():
    close(formula.EWMA_K, 2.0 / 101.0)
    old = 2000.0
    combined = 3000.0
    expected = (2.0 / 101.0) * combined + (99.0 / 101.0) * old
    close(formula.projected_moving_average(old, combined), expected)


def test_piecewise_linear_percentile():
    th = {20: 1000, 40: 1500, 55: 1800, 65: 2000, 75: 2200,
          85: 2500, 95: 3000, 100: 3500}
    close(formula.percentile_for_damage(0, th), 0.0)
    close(formula.percentile_for_damage(2000, th), 65.0)
    close(formula.percentile_for_damage(2350, th), 80.0)
    close(formula.percentile_for_damage(999999, th), 100.0)


def test_project_has_stable_fields():
    th = {20: 1000, 40: 1500, 55: 1800, 65: 2000, 75: 2200,
          85: 2500, 95: 3000, 100: 3500}
    out = formula.project(2200, 75.0, 1800, 100, 400, 250, th)
    assert sorted(out) == [
        "average_delta", "combined_damage", "percentile_delta",
        "projected_average", "projected_percentile"
    ]
    close(out["combined_damage"], 2200.0)
    close(out["projected_average"], 2200.0)
    close(out["projected_percentile"], 75.0)
    close(out["percentile_delta"], 0.0)


def test_wg_query_is_bounded_and_deduped():
    q = wgapi.build_query("app", list(range(1, 110)) + [1, 2])
    assert q["application_id"] == "app"
    assert q["distribution"] == "damage"
    assert q["percentile"] == "20,40,55,65,75,85,95,100"
    assert len(q["tank_id"].split(",")) == 100


def test_wg_parse_requires_four_mark_anchors():
    body = {
        "status": "ok",
        "data": {
            "updated_at": 123,
            "distribution": {
                "101": {"20": 900, "65": 1800, "85": 2200, "95": 2600, "100": 3000},
                "102": {"65": 1800, "85": 2200, "95": 2600}
            }
        }
    }
    table, updated = wgapi.parse_response(json.dumps(body))
    assert updated == 123
    assert 101 in table
    assert 102 not in table
    assert table[101][65] == 1800


def test_cache_roundtrip_and_expiry():
    src = {101: {65: 1800, 85: 2200, 95: 2600, 100: 3000}}
    blob = wgapi.make_cache("com", 1000, 900, src)
    assert wgapi.read_cache(blob, "com", 1100, 200) == src
    assert wgapi.read_cache(blob, "com", 1300, 200) == {}
    assert wgapi.read_cache(blob, "eu", 1100, 200) == {}


if __name__ == "__main__":
    for name in sorted(globals()):
        if name.startswith("test_"):
            globals()[name]()
            print("PASS", name)

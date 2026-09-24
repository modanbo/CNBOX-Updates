# -*- coding: utf-8 -*-
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(__file__))
sys.path.insert(0, os.path.join(ROOT, "source"))

import formula
import wgapi
import threshold_runtime


def close(a, b, eps=1e-9):
    assert abs(a - b) <= eps, (a, b)


def _read_source(name):
    path = os.path.join(ROOT, "source", name)
    with open(path, "rb") as fh:
        return fh.read().decode("utf-8")


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


def test_threshold_runtime_is_local_only():
    source = _read_source("threshold_runtime.py")
    forbidden = (
        "http.openUrl", "threading.Thread", "API_URL",
        "APPLICATION_ID", "worldoftanks.com/wot/tanks/mastery"
    )
    for token in forbidden:
        assert token not in source, token


def test_threshold_clean_table_requires_mark_anchors():
    blob = {
        "table": {
            "101": {"20": 900, "65": 1800, "85": 2200, "95": 2600, "100": 3000},
            "102": {"65": 1800, "85": 2200, "95": 2600}
        }
    }
    table = threshold_runtime._clean_table(blob)
    assert 101 in table
    assert 102 not in table
    assert table[101][95] == 2600


def test_native_damage_feedback_is_observer_only():
    source = _read_source("engine.py")
    assert "personalEfficiencyCtrl" in source
    assert "onTotalEfficiencyUpdated" in source
    assert "getTotalEfficiency" in source
    forbidden = (
        "PlayerAvatar.onBattleEvents =",
        "PlayerAvatar.onBattleEvents=",
        "overrideMethod(PlayerAvatar",
        "onBattleEvents = _",
        "_orig_onBattleEvents",
    )
    for token in forbidden:
        assert token not in source, token


def test_rejected_runtime_frameworks_are_absent_from_source():
    joined = "\n".join(
        _read_source(name) for name in (
            "config.py", "contract.py", "engine.py", "formula.py",
            "mod_najxbox_moe.py", "threshold_runtime.py", "view.py", "wgapi.py"
        )
    ).lower()
    forbidden = (
        "gambiter", "modssettingsapi", "modslistapi",
        "protanki", "champi", "aslain.modmenu", "openwg.gameface"
    )
    for token in forbidden:
        assert token not in joined, token


def test_single_official_contract_view_owner():
    source = _read_source("view.py")
    assert 'SWF_FILE = "najxbox_moe.swf"' in source
    assert 'LOBBY_ALIAS = "NAJXBOX_MOE_LOBBY"' in source
    assert 'BATTLE_ALIAS = "NAJXBOX_MOE_BATTLE"' in source
    assert source.count("class NajxMoeLobbyView") == 1
    assert source.count("class NajxMoeBattleView") == 1
    assert "SHOW_CURSOR" not in source
    assert "HIDE_CURSOR" not in source


if __name__ == "__main__":
    tests = [
        (name, obj) for name, obj in sorted(globals().items())
        if name.startswith("test_") and callable(obj)
    ]
    assert tests, "no tests discovered"
    for name, func in tests:
        func()
        print("PASS", name)
    print("PASS_ALL", len(tests))

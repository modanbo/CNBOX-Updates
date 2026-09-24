# -*- coding: utf-8 -*-
import os
import sys

ROOT = os.path.dirname(os.path.dirname(__file__))
sys.path.insert(0, os.path.join(ROOT, "source"))

import formula
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
            "mod_najxbox_moe.py", "threshold_runtime.py", "view.py"
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


def test_wot_package_import_paths_are_explicit():
    loader = _read_source("mod_najxbox_moe.py")
    contract = _read_source("contract.py")
    view = _read_source("view.py")
    assert "from gui.mods.najxbox_moe import view" in loader
    assert "from gui.mods.najxbox_moe import formula" in contract
    assert "from gui.mods.najxbox_moe import config, contract, engine, threshold_runtime" in view
    for source in (loader, contract, view):
        assert "from najxbox_moe import" not in source
    assert "\nimport config\n" not in view
    assert "\nimport contract\n" not in view


def test_official_swf_callback_surface_is_complete():
    source = _read_source("view.py")
    required = (
        "def py_getCustomConfig(self):",
        "def getPanelPosition(self):",
        "def savePosition(self, is_battle, x, y):",
        "def retrieveData(self):",
        "def populated(self):",
        "def openURL(self, url):",
        "self.flashObject.as_loadConfig()",
        "self.flashObject.as_updateData(self._last_data, str(reason), True)",
    )
    for token in required:
        assert token in source, token


def test_threshold_vehicle_key_lookup():
    old_loaded = threshold_runtime._LOADED
    old_table = dict(threshold_runtime._TABLE)
    try:
        threshold_runtime._LOADED = True
        threshold_runtime._TABLE = {
            "usa:A194_AHT_7": {65: 4625, 85: 5636, 95: 6504, 100: 6702}
        }
        assert threshold_runtime.get(0, "usa:A194_AHT_7")[95] == 6504
        assert threshold_runtime.get(0, "usa:missing") == {}
    finally:
        threshold_runtime._TABLE = old_table
        threshold_runtime._LOADED = old_loaded


def test_threshold_clean_table_accepts_vehicle_keys():
    blob = {"table": {
        "usa:A194_AHT_7": {"65": 4625, "85": 5636, "95": 6504, "100": 6702}
    }}
    table = threshold_runtime._clean_table(blob)
    assert table["usa:A194_AHT_7"][65] == 4625
    assert table["usa:A194_AHT_7"][100] == 6702


def test_threshold_listener_accepts_vehicle_key_source():
    source = _read_source("view.py")
    assert "def _on_threshold_ready(self, threshold_key):" in source
    assert 'state.get("vehicle_key")' in source
    assert 'self._push("threshold-ready")' in source


def test_battle_threshold_lookup_uses_vehicle_key():
    source = _read_source("view.py")
    expected = 'threshold_runtime.get(state.get("tank_id"), state.get("vehicle_key"))'
    assert source.count(expected) >= 2


def test_garage_vehicle_key_owner_is_imported():
    source = _read_source("engine.py")
    start = source.index("def read_garage_state():")
    end = source.index("\ndef remember_baseline", start)
    block = source[start:end]
    assert "from CurrentVehicle import g_currentVehicle" in block
    assert 'g_currentVehicle.item.name' in block


def test_legacy_wgapi_is_not_runtime_source():
    assert not os.path.exists(os.path.join(ROOT, "source", "wgapi.py"))


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

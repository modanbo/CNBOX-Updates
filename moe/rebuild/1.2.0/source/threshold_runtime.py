# -*- coding: utf-8 -*-
"""Local-only threshold provider for NAJXBox MoE 1.2.0.

Runtime network access is intentionally forbidden. Threshold data must be
shipped with the NAJXBox package or placed in the private config directory by
an out-of-game update workflow.
"""
import json
import os

try:
    unicode
except NameError:
    unicode = str

_TABLE = {}
_LOADED = False
_LISTENERS = []

PACKAGED_RESOURCE = "mods/najxbox_moe/thresholds.json"
EXTERNAL_PATH = os.path.join("mods", "configs", "NAJXBox_MoE", "thresholds.json")


def _clean_table(blob):
    out = {}
    if not isinstance(blob, dict):
        return out
    rows = blob.get("table", blob)
    if not isinstance(rows, dict):
        return out
    for tank_id, anchors in rows.items():
        try:
            tid = int(tank_id)
        except (TypeError, ValueError):
            continue
        if not isinstance(anchors, dict):
            continue
        row = {}
        for pct, value in anchors.items():
            try:
                p = int(pct)
                d = int(value)
            except (TypeError, ValueError):
                continue
            if p in (20, 40, 55, 65, 75, 85, 95, 100) and d > 0:
                row[p] = d
        if all(p in row for p in (65, 85, 95, 100)):
            out[tid] = row
    return out


def _read_external():
    try:
        if not os.path.isfile(EXTERNAL_PATH):
            return {}
        with open(EXTERNAL_PATH, "rb") as fh:
            return _clean_table(json.loads(fh.read().decode("utf-8")))
    except Exception:
        return {}


def _read_packaged():
    try:
        import ResMgr
        section = ResMgr.openSection(PACKAGED_RESOURCE)
        if section is None:
            return {}
        raw = section.asString
        if not raw:
            return {}
        if not isinstance(raw, unicode):
            raw = raw.decode("utf-8")
        return _clean_table(json.loads(raw))
    except Exception:
        return {}


def _ensure_loaded():
    global _LOADED, _TABLE
    if _LOADED:
        return
    _LOADED = True

    # A private external file may be refreshed by Manager/build tooling without
    # replacing the WOTMOD. If absent, fall back to the packaged snapshot.
    external = _read_external()
    _TABLE = external if external else _read_packaged()


def add_listener(callback):
    if callback not in _LISTENERS:
        _LISTENERS.append(callback)


def remove_listener(callback):
    try:
        _LISTENERS.remove(callback)
    except ValueError:
        pass


def get(tank_id):
    _ensure_loaded()
    try:
        tid = int(tank_id or 0)
    except (TypeError, ValueError):
        return {}
    row = _TABLE.get(tid)
    return dict(row) if row else {}


def reload_local():
    """Reload local threshold data after an out-of-game update is installed."""
    global _LOADED, _TABLE
    before = set(_TABLE)
    _LOADED = False
    _TABLE = {}
    _ensure_loaded()
    changed = before.symmetric_difference(set(_TABLE))
    for tank_id in changed:
        for callback in list(_LISTENERS):
            try:
                callback(tank_id)
            except Exception:
                pass
    return len(_TABLE)

# -*- coding: utf-8 -*-
"""Small local-only storage layer: position/language config and threshold snapshot."""
import json
import os

try:
    unicode
except NameError:
    unicode = str

CONFIG_PATH = os.path.join('mods', 'configs', 'NAJXBox_MoE', 'ui.json')
EXTERNAL_THRESHOLDS = os.path.join('mods', 'configs', 'NAJXBox_MoE', 'thresholds.json')
PACKAGED_THRESHOLDS = 'mods/najxbox_moe/thresholds.json'

_DEFAULT = {
    'language': 'auto',
    'lobby_x': 20,
    'lobby_y': 80,
    'battle_x': 20,
    'battle_y': 160,
}
_thresholds = None

def _as_int(value, fallback):
    try:
        return int(value)
    except (TypeError, ValueError):
        return int(fallback)

def load_ui():
    cfg = dict(_DEFAULT)
    try:
        if os.path.isfile(CONFIG_PATH):
            with open(CONFIG_PATH, 'rb') as fh:
                raw = json.loads(fh.read().decode('utf-8'))
            if isinstance(raw, dict):
                for key in cfg:
                    if key in raw:
                        cfg[key] = raw[key]
    except Exception:
        pass
    return cfg

def save_ui(cfg):
    try:
        folder = os.path.dirname(CONFIG_PATH)
        if not os.path.isdir(folder):
            os.makedirs(folder)
        temp_path = CONFIG_PATH + '.tmp'
        payload = json.dumps(cfg, ensure_ascii=False, indent=2).encode('utf-8')
        with open(temp_path, 'wb') as fh:
            fh.write(payload)
        if os.path.isfile(CONFIG_PATH):
            os.remove(CONFIG_PATH)
        os.rename(temp_path, CONFIG_PATH)
        return True
    except Exception:
        return False

def position_string():
    cfg = load_ui()
    return '%d,%d,%d,%d' % (
        _as_int(cfg.get('lobby_x'), _DEFAULT['lobby_x']),
        _as_int(cfg.get('lobby_y'), _DEFAULT['lobby_y']),
        _as_int(cfg.get('battle_x'), _DEFAULT['battle_x']),
        _as_int(cfg.get('battle_y'), _DEFAULT['battle_y']),
    )

def save_position(is_battle, x, y):
    cfg = load_ui()
    prefix = 'battle_' if is_battle else 'lobby_'
    cfg[prefix + 'x'] = _as_int(x, _DEFAULT[prefix + 'x'])
    cfg[prefix + 'y'] = _as_int(y, _DEFAULT[prefix + 'y'])
    return save_ui(cfg)

def language_code():
    cfg = load_ui()
    explicit = str(cfg.get('language') or 'auto').lower()
    if explicit in ('en', 'zh'):
        return explicit
    try:
        from helpers import getClientLanguage
        lang = str(getClientLanguage() or '').lower()
    except Exception:
        lang = ''
    return 'zh' if lang.startswith('zh') else 'en'

def _clean_thresholds(blob):
    result = {}
    rows = blob.get('table', blob) if isinstance(blob, dict) else {}
    if not isinstance(rows, dict):
        return result
    allowed = (20, 40, 55, 65, 75, 85, 95, 100)
    for raw_key, raw_row in rows.items():
        if not isinstance(raw_row, dict):
            continue
        try:
            key = int(raw_key)
        except (TypeError, ValueError):
            key = str(raw_key or '')
            if not key:
                continue
        row = {}
        for p, value in raw_row.items():
            try:
                pct = int(p)
                dmg = int(value)
            except (TypeError, ValueError):
                continue
            if pct in allowed and dmg > 0:
                row[pct] = dmg
        if all(p in row for p in (65, 85, 95, 100)):
            result[key] = row
    return result

def _load_thresholds():
    global _thresholds
    if _thresholds is not None:
        return _thresholds
    table = {}
    try:
        if os.path.isfile(EXTERNAL_THRESHOLDS):
            with open(EXTERNAL_THRESHOLDS, 'rb') as fh:
                table = _clean_thresholds(json.loads(fh.read().decode('utf-8')))
    except Exception:
        table = {}
    if not table:
        try:
            import ResMgr
            section = ResMgr.openSection(PACKAGED_THRESHOLDS)
            raw = section.asString if section is not None else ''
            if raw and not isinstance(raw, unicode):
                raw = raw.decode('utf-8')
            if raw:
                table = _clean_thresholds(json.loads(raw))
        except Exception:
            table = {}
    _thresholds = table
    return table

def thresholds_for(tank_id, vehicle_key=''):
    table = _load_thresholds()
    try:
        row = table.get(int(tank_id or 0))
    except (TypeError, ValueError):
        row = None
    if row:
        return dict(row)
    key = str(vehicle_key or '')
    row = table.get(key) if key else None
    return dict(row) if row else {}
